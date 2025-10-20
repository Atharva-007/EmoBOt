import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';

class SocialLoginButton extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final BorderRadius? borderRadius;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.height = 56,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? (isDark ? const Color(0xFF1F2937) : Colors.white),
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          border: Border.all(
            color: isDark 
                ? Colors.grey.shade700 
                : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: _buildIcon(),
                ),
                
                const SizedBox(width: 12),
                
                // Text
                Text(
                  text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: textColor ?? (isDark ? Colors.white : Colors.black87),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    // Check if it's a built-in icon or asset
    if (icon.startsWith('assets/')) {
      return Image.asset(
        icon,
        width: 24,
        height: 24,
        errorBuilder: (context, error, stackTrace) {
          return _getDefaultIcon();
        },
      );
    } else {
      return _getDefaultIcon();
    }
  }

  Widget _getDefaultIcon() {
    switch (text.toLowerCase()) {
      case 'google':
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: const LinearGradient(
              colors: [Color(0xFF4285F4), Color(0xFF34A853), Color(0xFFFBBC05), Color(0xFFEA4335)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(
            Icons.g_mobiledata,
            color: Colors.white,
            size: 18,
          ),
        );
      case 'apple':
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.black,
          ),
          child: const Icon(
            Icons.apple,
            color: Colors.white,
            size: 18,
          ),
        );
      case 'facebook':
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color(0xFF1877F2),
          ),
          child: const Icon(
            Icons.facebook,
            color: Colors.white,
            size: 18,
          ),
        );
      case 'twitter':
      case 'x':
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.black,
          ),
          child: const Center(
            child: Text(
              'X',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        );
      case 'github':
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.black,
          ),
          child: const Icon(
            Icons.code,
            color: Colors.white,
            size: 18,
          ),
        );
      default:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey.shade400,
          ),
          child: const Icon(
            Icons.account_circle,
            color: Colors.white,
            size: 18,
          ),
        );
    }
  }
}

class AnimatedSocialButton extends StatefulWidget {
  final String icon;
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Duration animationDuration;
  final Duration delay;

  const AnimatedSocialButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.animationDuration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
  });

  @override
  State<AnimatedSocialButton> createState() => _AnimatedSocialButtonState();
}

class _AnimatedSocialButtonState extends State<AnimatedSocialButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Start animation with delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: SocialLoginButton(
                icon: widget.icon,
                text: widget.text,
                onPressed: widget.onPressed,
                backgroundColor: widget.backgroundColor,
                textColor: widget.textColor,
              ),
            ),
          ),
        );
      },
    );
  }
}

class MinimalSocialButton extends StatelessWidget {
  final String icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final double size;

  const MinimalSocialButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? (isDark ? const Color(0xFF1F2937) : Colors.white),
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark 
                ? Colors.grey.shade700 
                : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: _buildIcon(),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (icon.startsWith('assets/')) {
      return Image.asset(
        icon,
        width: 24,
        height: 24,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.account_circle, size: 24);
        },
      );
    } else {
      return const Icon(Icons.account_circle, size: 24);
    }
  }
}

class GradientSocialButton extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback onPressed;
  final Gradient gradient;
  final double height;

  const GradientSocialButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.gradient,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                child: Image.asset(
                  icon,
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 24,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}