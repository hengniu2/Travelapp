import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/hotel.dart';
import '../../widgets/price_widget.dart';
import '../../providers/app_provider.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';
import '../../l10n/app_localizations.dart';

class HotelBookingScreen extends StatefulWidget {
  final Hotel hotel;

  const HotelBookingScreen({super.key, required this.hotel});

  @override
  State<HotelBookingScreen> createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _guests = 1;
  int _rooms = 1;

  int get _nights {
    if (_checkIn == null || _checkOut == null) return 0;
    return _checkOut!.difference(_checkIn!).inDays;
  }

  double get _totalPrice => widget.hotel.pricePerNight * _nights * _rooms;

  Future<void> _selectCheckIn() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _checkIn = date;
        if (_checkOut != null && _checkOut!.isBefore(_checkIn!)) {
          _checkOut = null;
        }
      });
    }
  }

  Future<void> _selectCheckOut() async {
    if (_checkIn == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseSelectStartDate)),
      );
      return;
    }

    final date = await showDatePicker(
      context: context,
      initialDate: _checkIn!.add(const Duration(days: 1)),
      firstDate: _checkIn!,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _checkOut = date;
      });
    }
  }

  void _proceedToPayment() {
    if (_checkIn == null || _checkOut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseSelectDates)),
      );
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.payment),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.total}: \$${_totalPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            Text(l10n.selectPaymentMethod),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: Text(l10n.wallet),
              onTap: () => _processPayment('wallet'),
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: Text(l10n.creditCard),
              onTap: () => _processPayment('card'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _processPayment(String method) {
    Navigator.pop(context);

    final appProvider = Provider.of<AppProvider>(context, listen: false);

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'hotel',
      itemId: widget.hotel.id,
      itemName: widget.hotel.name,
      amount: _totalPrice,
      orderDate: DateTime.now(),
      status: 'confirmed',
      details: {
        'checkIn': _checkIn!.toIso8601String(),
        'checkOut': _checkOut!.toIso8601String(),
        'nights': _nights,
        'rooms': _rooms,
        'guests': _guests,
        'paymentMethod': method,
      },
    );

    appProvider.addOrder(order);

    if (method == 'wallet') {
      appProvider.deductFromWallet(_totalPrice);
    }

    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.bookingConfirmed),
        content: Text(l10n.hotelBookingConfirmed),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bookHotel),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.hotel.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.hotel.location,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Booking Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectCheckIn,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _checkIn == null
                          ? 'Check-in'
                          : DateFormat('MMM dd, yyyy').format(_checkIn!),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectCheckOut,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _checkOut == null
                          ? 'Check-out'
                          : DateFormat('MMM dd, yyyy').format(_checkOut!),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.guests),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _guests > 1
                                  ? () => setState(() => _guests--)
                                  : null,
                            ),
                            Text('$_guests'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => setState(() => _guests++),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.rooms),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _rooms > 1
                                  ? () => setState(() => _rooms--)
                                  : null,
                            ),
                            Text('$_rooms'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => setState(() => _rooms++),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${l10n.nights}:'),
                        Text('$_nights'),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Price:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PriceWidget(price: _totalPrice),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _proceedToPayment,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(l10n.proceedToPayment),
          ),
        ),
      ),
    );
  }
}

