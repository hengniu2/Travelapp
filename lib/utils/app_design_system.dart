import 'package:flutter/material.dart';

/// Global design system: spacing, border radius, elevation, and UI rules.
/// Use these constants across the app for a consistent, premium look.
/// Rules: light tinted backgrounds, no plain white screens, no sharp corners,
/// card-based surfaces, no default unstyled widgets.
///
/// Overflow prevention: When a [Column] or [Row] is inside a fixed-height/width
/// parent, ensure content can't overflow: use [Expanded]/[Flexible],
/// [FittedBox](fit: BoxFit.scaleDown), or [SingleChildScrollView].
class AppDesignSystem {
  AppDesignSystem._();

  // ─── Spacing (8 / 12 / 16 / 20) ─────────────────────────────────────────
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 12;
  static const double spacingLg = 16;
  static const double spacingXl = 20;
  static const double spacingXxl = 24;

  static const EdgeInsets paddingSm = EdgeInsets.all(spacingSm);
  static const EdgeInsets paddingMd = EdgeInsets.all(spacingLg);
  static const EdgeInsets paddingLg = EdgeInsets.all(spacingXl);
  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(horizontal: spacingLg);
  static const EdgeInsets paddingVertical = EdgeInsets.symmetric(vertical: spacingLg);
  static const EdgeInsets paddingAllLg = EdgeInsets.symmetric(horizontal: spacingXl, vertical: spacingLg);

  // ─── Border radius — nearly rectangle (small rounding) ───────────────────
  /// Small radius for images and cards.
  static const double radiusImage = 4;
  static const double radiusSm = 6;
  static const double radiusMd = 8;
  static const double radiusLg = 8;
  static const double radiusXl = 10;
  static const double radiusXxl = 12;

  static BorderRadius get borderRadiusImage => BorderRadius.circular(radiusImage);
  static BorderRadius get borderRadiusSm => BorderRadius.circular(radiusSm);
  static BorderRadius get borderRadiusMd => BorderRadius.circular(radiusMd);
  static BorderRadius get borderRadiusLg => BorderRadius.circular(radiusLg);
  static BorderRadius get borderRadiusXl => BorderRadius.circular(radiusXl);
  static BorderRadius get borderRadiusXxl => BorderRadius.circular(radiusXxl);

  /// Top-only large radius for bottom sheets and modals.
  static BorderRadius get borderRadiusTopSheet =>
      const BorderRadius.vertical(top: Radius.circular(radiusXxl));

  // ─── Elevation levels (card-based surfaces, subtle depth) ─────────────────
  static const double elevationNone = 0;
  static const double elevationLow = 1;
  static const double elevationCard = 2;
  static const double elevationRaised = 4;
  static const double elevationNavBar = 6;
  static const double elevationModal = 8;

  /// Standard shadow color for cards and surfaces (subtle, not harsh).
  static Color shadowColor(BuildContext context) =>
      Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08);

  static Color shadowColorStrong(BuildContext context) =>
      Theme.of(context).colorScheme.shadow.withValues(alpha: 0.12);
}
