import 'package:flutter/material.dart';
import '../../models/tour.dart';
import '../../widgets/price_widget.dart';
import '../../providers/app_provider.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';

class TourBookingScreen extends StatelessWidget {
  final Tour tour;

  const TourBookingScreen({super.key, required this.tour});

  void _proceedToPayment(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total: \$${tour.price.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text('Select payment method:'),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Wallet'),
              onTap: () => _processPayment(context, 'wallet'),
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Credit Card'),
              onTap: () => _processPayment(context, 'card'),
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

  void _processPayment(BuildContext context, String method) {
    Navigator.pop(context);

    final appProvider = Provider.of<AppProvider>(context, listen: false);

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'tour',
      itemId: tour.id,
      itemName: tour.title,
      amount: tour.price,
      orderDate: DateTime.now(),
      status: 'confirmed',
      details: {
        'startDate': tour.startDate.toIso8601String(),
        'duration': tour.duration,
        'paymentMethod': method,
      },
    );

    appProvider.addOrder(order);

    if (method == 'wallet') {
      appProvider.deductFromWallet(tour.price);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Confirmed!'),
        content: const Text('Your tour booking has been confirmed.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Tour'),
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
                      tour.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Duration: ${tour.duration} days',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Booking Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow('Tour', tour.title),
                    const Divider(),
                    _buildInfoRow('Start Date', tour.startDate.toString().split(' ')[0]),
                    const Divider(),
                    _buildInfoRow('Duration', '${tour.duration} days'),
                    const Divider(),
                    _buildInfoRow('Participants', '1'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Price:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PriceWidget(price: tour.price),
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
            onPressed: () => _proceedToPayment(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Proceed to Payment'),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

