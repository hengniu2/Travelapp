import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../models/insurance.dart';
import '../../widgets/price_widget.dart';
import '../../widgets/image_first_card.dart';
import '../../widgets/ios_bottom_sheet.dart';
import '../../providers/app_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';
import '../../l10n/app_localizations.dart';

class InsuranceScreen extends StatelessWidget {
  const InsuranceScreen({super.key});

  void _purchaseInsurance(BuildContext context, Insurance insurance) {
    final l10n = AppLocalizations.of(context)!;
    final name = l10n.localeName == 'zh' ? (insurance.nameZh ?? insurance.name) : insurance.name;
    showIosActionSheet(
      context,
      title: '$name · ¥${insurance.price.toStringAsFixed(0)}',
      cancelLabel: AppLocalizations.of(context)!.cancel,
      actions: [
        IosSheetAction(
          icon: Icons.account_balance_wallet,
          label: AppLocalizations.of(context)!.wallet,
          onTap: () => _processPayment(context, insurance, 'wallet'),
          color: AppTheme.primaryColor,
        ),
        IosSheetAction(
          icon: Icons.credit_card,
          label: AppLocalizations.of(context)!.creditCard,
          onTap: () => _processPayment(context, insurance, 'card'),
          color: AppTheme.categoryBlue,
        ),
      ],
    );
  }

  void _processPayment(
      BuildContext context, Insurance insurance, String method) {

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
      SnackBar(
        content: Text(AppLocalizations.of(context)!.insurancePurchasedSuccess),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _localizedName(BuildContext context, Insurance insurance) {
    final l10n = AppLocalizations.of(context)!;
    return l10n.localeName == 'zh' ? (insurance.nameZh ?? insurance.name) : insurance.name;
  }

  String _localizedType(BuildContext context, Insurance insurance) {
    final l10n = AppLocalizations.of(context)!;
    return l10n.localeName == 'zh' ? (insurance.typeZh ?? insurance.type) : insurance.type;
  }

  String _localizedCoverage(BuildContext context, Insurance insurance) {
    final l10n = AppLocalizations.of(context)!;
    return l10n.localeName == 'zh' ? (insurance.coverageZh ?? insurance.coverage) : insurance.coverage;
  }

  String _localizedBenefit(BuildContext context, Insurance insurance, int index) {
    final l10n = AppLocalizations.of(context)!;
    if (l10n.localeName == 'zh' && insurance.benefitsZh != null && index < insurance.benefitsZh!.length) {
      return insurance.benefitsZh![index];
    }
    return insurance.benefits[index];
  }

  @override
  Widget build(BuildContext context) {
    final dataService = DataService();
    final insurances = dataService.getInsurancePlans();
    final l10n = AppLocalizations.of(context)!;

    final typeColors = {
      'Basic': AppTheme.categoryBlue,
      'Standard': AppTheme.categoryGreen,
      'Premium': AppTheme.categoryOrange,
    };

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.travelInsurance),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
        itemCount: insurances.length,
        itemBuilder: (context, index) {
          final insurance = insurances[index];
          final typeColor =
              typeColors[insurance.type] ?? AppTheme.primaryColor;
          return ImageFirstCard(
            onTap: () => _purchaseInsurance(context, insurance),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        typeColor.withOpacity(0.9),
                        typeColor.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppDesignSystem.radiusImage)),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.shield,
                      size: 56,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              _localizedName(context, insurance),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                          CardBadge(
                            label: _localizedType(context, insurance),
                            color: typeColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDesignSystem.spacingSm),
                      Text(
                        l10n.coverageLine(_localizedCoverage(context, insurance), insurance.duration),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppDesignSystem.spacingMd),
                      ...insurance.benefits.take(3).toList().asMap().entries.map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle,
                                    size: 16, color: AppTheme.categoryGreen),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(_localizedBenefit(context, insurance, e.key),
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: AppTheme.textPrimary))),
                              ],
                            ),
                          )),
                      const SizedBox(height: AppDesignSystem.spacingMd),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PriceWidget(
                            price: insurance.price,
                            prefix: '¥',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.categoryRed,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: AppTheme.primaryGradient),
                              borderRadius:
                                  AppDesignSystem.borderRadiusSm,
                            ),
                            child: Text(
                              l10n.purchase,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

