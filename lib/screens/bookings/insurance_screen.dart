import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../models/insurance.dart';
import '../../widgets/price_widget.dart';
import '../../providers/app_provider.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';

class InsuranceScreen extends StatelessWidget {
  const InsuranceScreen({super.key});

  void _purchaseInsurance(BuildContext context, Insurance insurance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase ${insurance.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$${insurance.price.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Coverage: ${insurance.coverage}'),
            const SizedBox(height: 8),
            Text('Duration: ${insurance.duration} days'),
            const SizedBox(height: 16),
            const Text('Benefits:'),
            ...insurance.benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(child: Text(benefit)),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            const Text('Select payment method:'),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Wallet'),
              onTap: () => _processPayment(context, insurance, 'wallet'),
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Credit Card'),
              onTap: () => _processPayment(context, insurance, 'card'),
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

  void _processPayment(
      BuildContext context, Insurance insurance, String method) {
    Navigator.pop(context);

    final appProvider = Provider.of<AppProvider>(context, listen: false);

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'insurance',
      itemId: insurance.id,
      itemName: insurance.name,
      amount: insurance.price,
      orderDate: DateTime.now(),
      status: 'confirmed',
      details: {
        'type': insurance.type,
        'coverage': insurance.coverage,
        'duration': insurance.duration,
        'paymentMethod': method,
      },
    );

    appProvider.addOrder(order);

    if (method == 'wallet') {
      appProvider.deductFromWallet(insurance.price);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Insurance purchased successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataService = DataService();
    final insurances = dataService.getInsurancePlans();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Insurance'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: insurances.length,
        itemBuilder: (context, index) {
          final insurance = insurances[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              insurance.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Chip(
                              label: Text(insurance.type),
                              backgroundColor: Colors.green.shade50,
                            ),
                          ],
                        ),
                      ),
                      PriceWidget(price: insurance.price),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Coverage: ${insurance.coverage}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Duration: ${insurance.duration} days',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Benefits:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...insurance.benefits.map((benefit) => Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 4),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle,
                                size: 16, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(child: Text(benefit)),
                          ],
                        ),
                      )),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _purchaseInsurance(context, insurance),
                      child: const Text('Purchase'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

