import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimationUtils {
  // Animation durations
  static const Duration ultraFast = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration ultraSlow = Duration(milliseconds: 800);

  // Animation curves
  static const Curve bounceInCurve = Curves.bounceIn;
  static const Curve bounceOutCurve = Curves.bounceOut;
  static const Curve elasticInCurve = Curves.elasticIn;
  static const Curve elasticOutCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeInOutCubic;
  static const Curve accelerate = Curves.easeInQuart;
  static const Curve decelerate = Curves.easeOutQuart;

  // Slide animations
  static Widget slideInFromLeft({
    required Widget child,
    Duration duration = medium,
    Curve curve = smoothCurve,
    double offset = -1.0,
  }) {
    return child
        .animate()
        .slideX(
          begin: offset,
          end: 0,
          duration: duration,
          curve: curve,
        )
        .fadeIn(duration: duration);
  }

  static Widget slideInFromRight({
    required Widget child,
    Duration duration = medium,
    Curve curve = smoothCurve,
    double offset = 1.0,
  }) {
    return child
        .animate()
        .slideX(
          begin: offset,
          end: 0,
          duration: duration,
          curve: curve,
        )
        .fadeIn(duration: duration);
  }

  static Widget slideInFromTop({
    required Widget child,
    Duration duration = medium,
    Curve curve = smoothCurve,
    double offset = -1.0,
  }) {
    return child
        .animate()
        .slideY(
          begin: offset,
          end: 0,
          duration: duration,
          curve: curve,
        )
        .fadeIn(duration: duration);
  }

  static Widget slideInFromBottom({
    required Widget child,
    Duration duration = medium,
    Curve curve = smoothCurve,
    double offset = 1.0,
  }) {
    return child
        .animate()
        .slideY(
          begin: offset,
          end: 0,
          duration: duration,
          curve: curve,
        )
        .fadeIn(duration: duration);
  }

  // Scale animations
  static Widget scaleIn({
    required Widget child,
    Duration duration = medium,
    Curve curve = smoothCurve,
    double begin = 0.0,
    double end = 1.0,
  }) {
    return child
        .animate()
        .scale(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 1.0),
          duration: duration,
          curve: curve,
        )
        .fadeIn(duration: duration);
  }

  static Widget pulseAnimation({
    required Widget child,
    Duration duration = slow,
    double minScale = 0.95,
    double maxScale = 1.05,
  }) {
    return child
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          begin: Offset(minScale, minScale),
          end: Offset(maxScale, maxScale),
          duration: duration,
          curve: Curves.easeInOut,
        );
  }

  // Fade animations
  static Widget fadeIn({
    required Widget child,
    Duration duration = medium,
    Curve curve = smoothCurve,
    double begin = 0.0,
    double end = 1.0,
  }) {
    return child.animate().fadeIn(
      duration: duration,
      curve: curve,
    );
  }

  static Widget fadeInUp({
    required Widget child,
    Duration duration = medium,
    double offset = 50.0,
  }) {
    return child
        .animate()
        .fadeIn(duration: duration)
        .slideY(
          begin: offset,
          end: 0,
          duration: duration,
          curve: smoothCurve,
        );
  }

  static Widget fadeInDown({
    required Widget child,
    Duration duration = medium,
    double offset = -50.0,
  }) {
    return child
        .animate()
        .fadeIn(duration: duration)
        .slideY(
          begin: offset,
          end: 0,
          duration: duration,
          curve: smoothCurve,
        );
  }

  // Rotation animations
  static Widget rotateIn({
    required Widget child,
    Duration duration = medium,
    double begin = 0.0,
    double end = 1.0,
  }) {
    return child
        .animate()
        .rotate(
          begin: begin,
          end: end,
          duration: duration,
          curve: smoothCurve,
        )
        .fadeIn(duration: duration);
  }

  static Widget spinAnimation({
    required Widget child,
    Duration duration = const Duration(seconds: 2),
  }) {
    return child
        .animate(onPlay: (controller) => controller.repeat())
        .rotate(duration: duration);
  }

  // Shimmer animations
  static Widget shimmerEffect({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
    Color baseColor = const Color(0xFFE0E0E0),
    Color highlightColor = const Color(0xFFF5F5F5),
  }) {
    return child
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: duration,
          color: highlightColor,
        );
  }

  // Elastic animations
  static Widget elasticInAnimation({
    required Widget child,
    Duration duration = slow,
  }) {
    return child
        .animate()
        .scale(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 1.0),
          duration: duration,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: duration);
  }

  // Bounce animations
  static Widget bounceInAnimation({
    required Widget child,
    Duration duration = medium,
  }) {
    return child
        .animate()
        .scale(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 1.0),
          duration: duration,
          curve: Curves.bounceOut,
        )
        .fadeIn(duration: duration);
  }

  // Staggered list animations
  static Widget staggeredListAnimation({
    required Widget child,
    required int index,
    Duration duration = medium,
    double offset = 100.0,
  }) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: duration,
      child: SlideAnimation(
        verticalOffset: offset,
        child: FadeInAnimation(child: child),
      ),
    );
  }

  // Page transition animations
  static Widget pageTransitionSlideUp({
    required Widget child,
    Duration duration = medium,
  }) {
    return child
        .animate()
        .slideY(
          begin: 1.0,
          end: 0.0,
          duration: duration,
          curve: smoothCurve,
        )
        .fadeIn(duration: duration);
  }

  static Widget pageTransitionSlideFromRight({
    required Widget child,
    Duration duration = medium,
  }) {
    return child
        .animate()
        .slideX(
          begin: 1.0,
          end: 0.0,
          duration: duration,
          curve: smoothCurve,
        );
  }

  // Custom hero animations
  static Widget heroAnimation({
    required Widget child,
    required String tag,
    Duration duration = medium,
  }) {
    return Hero(
      tag: tag,
      child: Material(
        color: Colors.transparent,
        child: child,
      ),
    );
  }

  // Floating action animations
  static Widget floatingAction({
    required Widget child,
    Duration duration = const Duration(seconds: 3),
    double offset = 10.0,
  }) {
    return child
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          begin: -offset,
          end: offset,
          duration: duration,
          curve: Curves.easeInOut,
        );
  }

  // Success checkmark animation
  static Widget successCheckmark({
    double size = 50.0,
    Color color = Colors.green,
    Duration duration = slow,
  }) {
    return Container(
      width: size,
      height: size,
      child: const Icon(Icons.check_circle, color: Colors.green),
    )
        .animate()
        .scale(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.2, 1.2),
          duration: Duration(milliseconds: 200),
          curve: Curves.elasticOut,
        )
        .then()
        .scale(
          begin: const Offset(1.2, 1.2),
          end: const Offset(1.0, 1.0),
          duration: Duration(milliseconds: 100),
        );
  }

  // Error animation
  static Widget errorShake({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    double offset = 10.0,
  }) {
    return child
        .animate()
        .shakeX(
          duration: duration,
          amount: offset,
          curve: Curves.easeInOut,
        );
  }

  // Attention seeking animations
  static Widget attentionSeeker({
    required Widget child,
    Duration duration = const Duration(seconds: 1),
  }) {
    return child
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.05, 1.05),
          duration: duration,
          curve: Curves.easeInOut,
        )
        .then()
        .shimmer(duration: Duration(milliseconds: 500));
  }
}

// Extension for easy animation application
extension AnimateExtension on Widget {
  Widget fadeInSlideUp({
    Duration duration = const Duration(milliseconds: 300),
    double offset = 50.0,
  }) {
    return AnimationUtils.fadeInUp(
      child: this,
      duration: duration,
      offset: offset,
    );
  }

  Widget slideFromLeft({Duration duration = const Duration(milliseconds: 300)}) {
    return AnimationUtils.slideInFromLeft(child: this, duration: duration);
  }

  Widget slideFromRight({Duration duration = const Duration(milliseconds: 300)}) {
    return AnimationUtils.slideInFromRight(child: this, duration: duration);
  }

  Widget slideFromTop({Duration duration = const Duration(milliseconds: 300)}) {
    return AnimationUtils.slideInFromTop(child: this, duration: duration);
  }

  Widget slideFromBottom({Duration duration = const Duration(milliseconds: 300)}) {
    return AnimationUtils.slideInFromBottom(child: this, duration: duration);
  }

  Widget scaleInAnimation({Duration duration = const Duration(milliseconds: 300)}) {
    return AnimationUtils.scaleIn(child: this, duration: duration);
  }

  Widget bounceInAnimation({Duration duration = const Duration(milliseconds: 300)}) {
    return AnimationUtils.bounceInAnimation(child: this, duration: duration);
  }

  Widget elasticInAnimation({Duration duration = const Duration(milliseconds: 500)}) {
    return AnimationUtils.elasticInAnimation(child: this, duration: duration);
  }

  Widget pulseAnimation({
    Duration duration = const Duration(milliseconds: 500),
    double minScale = 0.95,
    double maxScale = 1.05,
  }) {
    return AnimationUtils.pulseAnimation(
      child: this,
      duration: duration,
      minScale: minScale,
      maxScale: maxScale,
    );
  }
}