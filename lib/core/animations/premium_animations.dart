import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PremiumAnimations {
  // Industry-standard animation durations
  static const Duration ultraFast = Duration(milliseconds: 150);
  static const Duration fast = Duration(milliseconds: 250);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 750);

  // Premium animation curves from top apps
  static const Curve elasticOut = Curves.elasticOut;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve fastEaseOut = Curves.easeOutCubic;
  static const Curve smoothEaseInOut = Curves.easeInOutQuart;
  static const Curve sharpEaseOut = Curves.easeOutExpo;

  // Page transition animations (GitHub/YouTube style)
  static Widget slideFromRight(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: fastEaseOut,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  static Widget slideFromBottom(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: smoothEaseInOut,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  // Navigation animations
  static PageRouteBuilder premiumPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: normal,
      reverseTransitionDuration: fast,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return slideFromRight(child, animation);
      },
    );
  }

  static PageRouteBuilder modalPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: normal,
      reverseTransitionDuration: fast,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return slideFromBottom(child, animation);
      },
    );
  }

  // Entrance animations for lists
  static Widget staggeredListItem({
    required Widget child,
    required int index,
    Duration delay = const Duration(milliseconds: 50),
  }) {
    return child
        .animate()
        .fadeIn(
          duration: normal,
          delay: Duration(milliseconds: index * delay.inMilliseconds),
        )
        .slideY(
          begin: 0.2,
          end: 0.0,
          duration: normal,
          delay: Duration(milliseconds: index * delay.inMilliseconds),
          curve: fastEaseOut,
        );
  }

  // Card entrance animations
  static Widget cardEntrance(Widget card, {int index = 0}) {
    return card
        .animate()
        .fadeIn(
          duration: normal,
          delay: Duration(milliseconds: index * 100),
        )
        .slideY(
          begin: 0.3,
          end: 0.0,
          duration: slow,
          delay: Duration(milliseconds: index * 100),
          curve: sharpEaseOut,
        )
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: slow,
          delay: Duration(milliseconds: index * 100),
          curve: elasticOut,
        );
  }
}