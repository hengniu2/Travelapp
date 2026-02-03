import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/companion.dart';
import '../../widgets/price_widget.dart';
import '../../providers/app_provider.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';

class CompanionBookingScreen extends StatefulWidget {
  final Companion companion;

  const CompanionBookingScreen({super.key, required this.companion});

  @override
  State<CompanionBookingScreen> createState() =>
      _CompanionBookingScreenState();
}

class _CompanionBookingScreenState extends State<CompanionBookingScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  int _days = 1;
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _startDate = date;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
        _calculateDays();
      });
    }
  }

  Future<void> _selectEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start date first')),
      );
      return;
    }

    final date = await showDatePicker(
      context: context,
      initialDate: _startDate!.add(const Duration(days: 1)),
      firstDate: _startDate!,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _endDate = date;
        _calculateDays();
      });
    }
  }

  void _calculateDays() {
    if (_startDate != null && _endDate != null) {
      setState(() {
        _days = _endDate!.difference(_startDate!).inDays + 1;
      });
    }
  }

  double get _totalPrice => widget.companion.pricePerDay * _days;

  void _proceedToPayment() {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select dates')),
      );
      return;
    }

    _showPaymentDialog();
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total: \$${_totalPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text('Select payment method:'),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Wallet'),
              onTap: () => _processPayment('wallet'),
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Credit Card'),
              onTap: () => _processPayment('card'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
      type: 'companion',
      itemId: widget.companion.id,
      itemName: widget.companion.name,
      amount: _totalPrice,
      orderDate: DateTime.now(),
      status: 'confirmed',
      details: {
        'startDate': _startDate!.toIso8601String(),
        'endDate': _endDate!.toIso8601String(),
        'days': _days,
        'paymentMethod': method,
      },
    );

    appProvider.addOrder(order);

    if (method == 'wallet') {
      appProvider.deductFromWallet(_totalPrice);
    }

    _showAgreementDialog();
  }

  void _showAgreementDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('E-Agreement'),
        content: const SingleChildScrollView(
          child: Text(
            'By proceeding, you agree to the terms and conditions:\n\n'
            '1. Service terms and cancellation policy\n'
            '2. Payment terms and refund policy\n'
            '3. Liability and insurance coverage\n'
            '4. Code of conduct during the trip\n\n'
            'Do you agree to these terms?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking confirmed!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Agree & Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Companion'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(widget.companion.name[0]),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.companion.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${widget.companion.pricePerDay.toStringAsFixed(2)}/day',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Dates',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectStartDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _startDate == null
                          ? 'Start Date'
                          : DateFormat('MMM dd, yyyy').format(_startDate!),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectEndDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _endDate == null
                          ? 'End Date'
                          : DateFormat('MMM dd, yyyy').format(_endDate!),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Additional Notes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Any special requirements or notes...',
                border: OutlineInputBorder(),
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
                        const Text('Days:'),
                        Text('$_days days'),
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
            child: const Text('Proceed to Payment'),
          ),
        ),
      ),
    );
  }
}



