import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/app_design_system.dart';
import '../l10n/app_localizations.dart';
import 'price_widget.dart';

/// Sticky bottom action bar for detail screens: favorite + price + book.
/// Keeps price always visible and provides easy actions.
/// Optional [secondaryLabel] / [onSecondaryTap] for a second button (e.g. 聊天).
class DetailBottomBar extends StatelessWidget {
  const DetailBottomBar({
    super.key,
    this.showFavorite = true,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.price,
    this.priceSuffix,
    this.primaryLabel,
    this.onPrimaryTap,
    this.primaryEnabled = true,
    this.secondaryLabel,
    this.onSecondaryTap,
  });

  final bool showFavorite;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final double? price;
  final String? priceSuffix;
  final String? primaryLabel;
  final VoidCallback? onPrimaryTap;
  final bool primaryEnabled;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final effectiveSuffix = priceSuffix ?? l10n.priceFrom;
    final effectivePrimary = primaryLabel ?? l10n.book;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDesignSystem.spacingLg,
            AppDesignSystem.spacingSm,
            AppDesignSystem.spacingLg,
            AppDesignSystem.spacingSm,
          ),
          child: Row(
            children: [
              if (showFavorite) ...[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onFavoriteTap,
                    borderRadius: AppDesignSystem.borderRadiusMd,
                    child: Container(
                      padding: const EdgeInsets.all(AppDesignSystem.spacingMd),
                      decoration: BoxDecoration(
                        color: isFavorite
                            ? AppTheme.categoryPink.withValues(alpha: 0.15)
                            : AppTheme.backgroundColor,
                        borderRadius: AppDesignSystem.borderRadiusMd,
                        border: Border.all(
                          color: isFavorite
                              ? AppTheme.categoryPink
                              : AppTheme.textSecondary.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
                            ? AppTheme.categoryPink
                            : AppTheme.textSecondary,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDesignSystem.spacingMd),
              ],
              if (price != null) ...[
                Expanded(
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.price,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            PriceWidget(
                              price: price!,
                              prefix: '¥',
                              showFrom: false,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.categoryRed,
                              ),
                            ),
                            if (effectiveSuffix.isNotEmpty) ...[
                              const SizedBox(width: 2),
                              Text(
                                effectiveSuffix,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ] else
                const Spacer(),
              if (secondaryLabel != null && onSecondaryTap != null) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: onSecondaryTap,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppDesignSystem.spacingMd),
                      side: BorderSide(color: AppTheme.primaryColor, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppDesignSystem.borderRadiusLg,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.chat, size: 20, color: AppTheme.primaryColor),
                        const SizedBox(width: 6),
                        Text(
                          secondaryLabel!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppDesignSystem.spacingMd),
              ],
              Expanded(
                flex: secondaryLabel != null ? 2 : 2,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: primaryEnabled ? onPrimaryTap : null,
                    borderRadius: AppDesignSystem.borderRadiusLg,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDesignSystem.spacingMd,
                      ),
                      decoration: BoxDecoration(
                        gradient: primaryEnabled
                            ? LinearGradient(
                                colors: AppTheme.primaryGradient,
                              )
                            : null,
                        color: primaryEnabled
                            ? null
                            : AppTheme.textSecondary.withValues(alpha: 0.3),
                        borderRadius: AppDesignSystem.borderRadiusLg,
                        boxShadow: primaryEnabled
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withValues(alpha: 0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.book_online,
                            size: 20,
                            color: primaryEnabled
                                ? Colors.white
                                : Colors.white70,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            effectivePrimary,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryEnabled
                                  ? Colors.white
                                  : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
