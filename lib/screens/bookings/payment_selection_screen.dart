import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking_traveler.dart';
import '../../models/order.dart';
import '../../providers/app_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';

/// 选择支付方式：支付宝、微信支付。确认后创建订单并返回成功。
class PaymentSelectionScreen extends StatelessWidget {
  final String bookingType;
  final String itemId;
  final String itemName;
  final double amount;
  final Map<String, dynamic> extraDetails;
  final List<BookingTraveler> travelers;

  const PaymentSelectionScreen({
    super.key,
    required this.bookingType,
    required this.itemId,
    required this.itemName,
    required this.amount,
    required this.extraDetails,
    required this.travelers,
  });

  void _payWith(BuildContext context, String method) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final details = Map<String, dynamic>.from(extraDetails)
      ..['paymentMethod'] = method
      ..['travelers'] = travelers.map((t) => t.toJson()).toList();

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: bookingType,
      itemId: itemId,
      itemName: itemName,
      amount: amount,
      orderDate: DateTime.now(),
      status: 'confirmed',
      details: details,
    );
    appProvider.addOrder(order);

    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.bookingConfirmed),
        content: Text(
          bookingType == 'tour'
              ? l10n.tourBookingConfirmed
              : l10n.hotelBookingConfirmed,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, true);
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
        title: Text(l10n.selectPayment),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              child: Padding(
                padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.totalPriceLabel,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '¥${amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.categoryRed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.selectPayment,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _PaymentOption(
              icon: Icons.account_balance_wallet,
              label: l10n.payWithAlipay,
              subtitle: 'Alipay',
              onTap: () => _payWith(context, 'alipay'),
            ),
            const SizedBox(height: 12),
            _PaymentOption(
              icon: Icons.chat_bubble_outline,
              label: l10n.payWithWeChat,
              subtitle: 'WeChat Pay',
              onTap: () => _payWith(context, 'wechat'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
          child: Row(
            children: [
              Icon(icon, size: 32, color: AppTheme.primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
