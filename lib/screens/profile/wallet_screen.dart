import 'package:flutter/material.dart';
import '../../providers/app_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/price_widget.dart';
import '../../utils/travel_images.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import '../../l10n/app_localizations.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appProvider = Provider.of<AppProvider>(context);
    final balance = appProvider.walletBalance;
    final amountController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.wallet),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: AppDesignSystem.borderRadiusImage,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: AppDesignSystem.borderRadiusImage,
                child: TravelImages.buildImageBackground(
                  imageUrl: TravelImages.getWalletBackground(0),
                  opacity: 0.7,
                  cacheWidth: 800,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          l10n.currentBalance,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        PriceWidget(
                          price: balance,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.addMoney),
                    content: TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.amount,
                        prefixText: '\$',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          amountController.clear();
                        },
                        child: Text(l10n.cancel),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final amount = double.tryParse(amountController.text);
                          if (amount != null && amount > 0) {
                            appProvider.addToWallet(amount);
                            Navigator.pop(context);
                            amountController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${l10n.addedToWallet} \$${amount.toStringAsFixed(2)}'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                        child: Text(l10n.add),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.addMoney),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



