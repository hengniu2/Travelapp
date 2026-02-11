import 'package:flutter/material.dart';
import 'app_animations.dart';

/// iOS-style slide-up page transition. Use for detail and secondary screens.
PageRouteBuilder<T> slideUpRoute<T>({
  required Widget page,
  RouteSettings? settings,
  bool fullscreenDialog = false,
}) {
  return PageRouteBuilder<T>(
    settings: settings,
    fullscreenDialog: fullscreenDialog,
    transitionDuration: AppAnimations.durationLong,
    reverseTransitionDuration: AppAnimations.durationMedium,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 0.04);
      const end = Offset.zero;
      const curve = AppAnimations.curveEaseOut;
      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );
      var offsetAnimation = animation.drive(tween);
      var fadeTween = Tween(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: curve),
      );
      var fadeAnimation = animation.drive(fadeTween);
      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: child,
        ),
      );
    },
  );
}

/// Push with slide-up transition (replacement for MaterialPageRoute).
Future<T?> pushSlideUp<T>(BuildContext context, Widget page) {
  return Navigator.push<T>(
    context,
    slideUpRoute<T>(page: page),
  );
}
