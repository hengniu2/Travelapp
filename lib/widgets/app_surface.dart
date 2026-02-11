import 'package:flutter/material.dart';
import '../utils/app_design_system.dart';
import '../utils/app_theme.dart';

/// Card-based surface with design-system radius and elevation.
/// Use instead of flat Container or bare Card for consistent premium look.
class AppSurface extends StatelessWidget {
  const AppSurface({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.color,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? color;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppDesignSystem.borderRadiusLg;
    final effectiveElevation = elevation ?? AppDesignSystem.elevationCard;
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spacingLg,
        vertical: AppDesignSystem.spacingSm,
      ),
      decoration: BoxDecoration(
        color: color ?? AppTheme.cardColor,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: effectiveElevation * 2,
            offset: Offset(0, effectiveElevation),
            spreadRadius: 0,
          ),
        ],
      ),
      clipBehavior: clipBehavior,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppDesignSystem.spacingLg),
        child: child,
      ),
    );
  }
}

/// Compact surface for inline chips/tags or small blocks.
class AppSurfaceCompact extends StatelessWidget {
  const AppSurfaceCompact({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spacingMd,
        vertical: AppDesignSystem.spacingSm,
      ),
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade100,
        borderRadius: borderRadius ?? AppDesignSystem.borderRadiusMd,
      ),
      child: child,
    );
  }
}
