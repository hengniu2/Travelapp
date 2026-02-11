import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/app_design_system.dart';

/// Tappable image-first card: rounded corners, soft shadow, clear spacing, tap feedback.
/// Use for all list/grid items that should feel tappable and match the design system.
class ImageFirstCard extends StatelessWidget {
  const ImageFirstCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
    this.borderRadius,
    this.elevation,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppDesignSystem.borderRadiusImage;
    final effectiveElevation = elevation ?? AppDesignSystem.elevationCard;
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: AppDesignSystem.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: effectiveElevation * 4,
            offset: Offset(0, effectiveElevation),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          splashColor: AppTheme.primaryColor.withValues(alpha: 0.12),
          highlightColor: AppTheme.primaryColor.withValues(alpha: 0.08),
          child: ClipRRect(
            borderRadius: radius,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Small pill badge for cards: TOP, 热门, 真纯玩, etc.
class CardBadge extends StatelessWidget {
  const CardBadge({
    super.key,
    required this.label,
    this.color,
    this.icon,
  });

  final String label;
  final Color? color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.primaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spacingSm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.95),
        borderRadius: AppDesignSystem.borderRadiusSm,
        boxShadow: [
          BoxShadow(
            color: c.withValues(alpha: 0.35),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: Colors.white),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
