import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';

class GradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Gradient gradient;
  final double height;
  final double? width;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Duration animationDuration;

  const GradientButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.gradient,
    this.height = 56,
    this.width,
    this.borderRadius,
    this.boxShadow,
    this.animationDuration = const Duration(milliseconds: 100),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          gradient: onPressed != null ? gradient : 
              LinearGradient(
                colors: [Colors.grey.shade400, Colors.grey.shade500],
              ),
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          boxShadow: boxShadow ?? [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            child: Container(
              alignment: Alignment.center,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class IconGradientButton extends StatelessWidget {
  final Widget icon;
  final Widget text;
  final VoidCallback? onPressed;
  final Gradient gradient;
  final double height;
  final double? width;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const IconGradientButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.gradient,
    this.height = 56,
    this.width,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Container(
        height: height,
        width: width ?? double.infinity,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: onPressed != null ? gradient : 
              LinearGradient(
                colors: [Colors.grey.shade400, Colors.grey.shade500],
              ),
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 12),
                text,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OutlineGradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Gradient gradient;
  final double height;
  final double? width;
  final BorderRadius? borderRadius;
  final double borderWidth;

  const OutlineGradientButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.gradient,
    this.height = 56,
    this.width,
    this.borderRadius,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.transparent],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            border: Border.all(
              width: borderWidth,
              color: Colors.transparent,
            ),
            gradient: gradient,
          ),
          child: Container(
            margin: EdgeInsets.all(borderWidth),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                (borderRadius?.topLeft.x ?? 16) - borderWidth,
              ),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(
                (borderRadius?.topLeft.x ?? 16) - borderWidth,
              ),
              child: Container(
                alignment: Alignment.center,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FloatingGradientButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Gradient gradient;
  final double size;
  final Duration animationDuration;

  const FloatingGradientButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.gradient,
    this.size = 56,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<FloatingGradientButton> createState() => _FloatingGradientButtonState();
}

class _FloatingGradientButtonState extends State<FloatingGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  gradient: widget.gradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.gradient.colors.first.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: widget.onPressed,
                    child: Container(
                      alignment: Alignment.center,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}