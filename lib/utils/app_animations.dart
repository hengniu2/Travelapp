import 'package:flutter/material.dart';

/// Consistent animation timing and curves across the app.
/// Use for page transitions, micro-interactions, and loaders.
class AppAnimations {
  AppAnimations._();

  /// Short: 200ms — toggles, icons, small feedback
  static const Duration durationShort = Duration(milliseconds: 200);

  /// Medium: 300ms — list items, cards, bottom sheets
  static const Duration durationMedium = Duration(milliseconds: 300);

  /// Long: 400ms — page transitions, hero, modals
  static const Duration durationLong = Duration(milliseconds: 400);

  /// Stagger delay between list items (e.g. skeleton or reveal)
  static const Duration durationStagger = Duration(milliseconds: 50);

  /// Ease-out: fast start, smooth end (buttons, sheets)
  static const Curve curveEaseOut = Curves.easeOutCubic;

  /// Ease-in-out: smooth both ends (page transitions)
  static const Curve curveEaseInOut = Curves.easeInOutCubic;

  /// Ease-out back: slight overshoot (delightful emphasis)
  static const Curve curveEaseOutBack = Curves.easeOutBack;

  /// Standard curve for most UI animations
  static const Curve curveStandard = Curves.easeOutCubic;
}
