import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../providers/app_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import '../../widgets/price_widget.dart';
import '../../widgets/image_first_card.dart';
import '../../widgets/empty_state.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appProvider = Provider.of<AppProvider>(context);
    final orders = appProvider.orders;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.myOrders),
      ),
      body: orders.isEmpty
          ? EmptyState(
              icon: Icons.shopping_bag_outlined,
              headline: l10n.noOrdersYet,
              subtitle: l10n.ordersEmptySubtitle,
              iconColor: AppTheme.primaryColor,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final statusColor = _getStatusColor(order.status);
                final gradients = [
                  AppTheme.primaryGradient,
                  AppTheme.sunsetGradient,
                  AppTheme.oceanGradient,
                ];
                final gradient = gradients[index % gradients.length];
                
                return ImageFirstCard(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(AppDesignSystem.spacingXl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: gradient),
                                borderRadius:
                                    AppDesignSystem.borderRadiusSm,
                              ),
                              child: Icon(
                                _getTypeIcon(order.type),
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: AppDesignSystem.spacingMd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.itemName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimary,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today,
                                          size: 14,
                                          color: AppTheme.textSecondary),
                                      const SizedBox(width: 4),
                                      Text(
                                        DateFormat('MMM dd, yyyy')
                                            .format(order.orderDate),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppTheme.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            CardBadge(
                              label: order.status.toUpperCase(),
                              color: statusColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDesignSystem.spacingLg),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDesignSystem.spacingLg,
                              vertical: AppDesignSystem.spacingMd),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.08),
                            borderRadius:
                                AppDesignSystem.borderRadiusSm,
                            border: Border.all(
                              color: AppTheme.primaryColor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount:',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              PriceWidget(
                                price: order.amount,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppTheme.categoryGreen;
      case 'pending':
        return AppTheme.categoryOrange;
      case 'cancelled':
        return AppTheme.categoryRed;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'tour':
        return Icons.explore;
      case 'hotel':
        return Icons.hotel;
      case 'companion':
        return Icons.people;
      default:
        return Icons.shopping_bag;
    }
  }
}

