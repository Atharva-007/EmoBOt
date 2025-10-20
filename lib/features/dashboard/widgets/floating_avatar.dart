import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/animation_utils.dart';

class FloatingAvatar extends StatefulWidget {
  final AnimationController animationController;
  final double size;
  final VoidCallback? onTap;

  const FloatingAvatar({
    super.key,
    required this.animationController,
    this.size = 120,
    this.onTap,
  });

  @override
  State<FloatingAvatar> createState() => _FloatingAvatarState();
}

class _FloatingAvatarState extends State<FloatingAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _localController;
  late Animation<double> _floatAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Color?> _colorAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _localController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _floatAnimation = Tween<double>(
      begin: -8.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _localController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(CurvedAnimation(
      parent: _localController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: AppTheme.primaryColor,
      end: AppTheme.secondaryColor,
    ).animate(CurvedAnimation(
      parent: _localController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _localController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          widget.animationController,
          _localController,
        ]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Transform.scale(
              scale: (_isPressed ? 0.95 : 1.0) * _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: const Alignment(-0.3, -0.3),
                      colors: [
                        (_colorAnimation.value ?? AppTheme.primaryColor)
                            .withOpacity(0.9),
                        (_colorAnimation.value ?? AppTheme.primaryColor)
                            .withOpacity(0.7),
                        AppTheme.primaryColor.withOpacity(0.5),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (_colorAnimation.value ?? AppTheme.primaryColor)
                            .withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(-2, -2),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Animated background particles
                      ...List.generate(6, (index) {
                        return AnimatedBuilder(
                          animation: widget.animationController,
                          builder: (context, child) {
                            final angle = (widget.animationController.value * 2 * math.pi) + 
                                (index * math.pi / 3);
                            final radius = widget.size * 0.25;
                            final x = math.cos(angle) * radius;
                            final y = math.sin(angle) * radius;

                            return Transform.translate(
                              offset: Offset(x, y),
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            );
                          },
                        );
                      }),
                      
                      // Main avatar content
                      _buildAvatarContent(),
                      
                      // Pulsing ring
                      AnimatedBuilder(
                        animation: _localController,
                        builder: (context, child) {
                          return Container(
                            width: widget.size * (0.9 + (_localController.value * 0.1)),
                            height: widget.size * (0.9 + (_localController.value * 0.1)),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3 * (1 - _localController.value)),
                                width: 2,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatarContent() {
    return Container(
      width: widget.size * 0.7,
      height: widget.size * 0.7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Eyes
          Positioned(
            top: widget.size * 0.25,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildEye(true),
                SizedBox(width: widget.size * 0.1),
                _buildEye(false),
              ],
            ),
          ),
          
          // Mouth
          Positioned(
            bottom: widget.size * 0.2,
            child: _buildMouth(),
          ),
          
          // Main icon
          Icon(
            Icons.smart_toy_rounded,
            size: widget.size * 0.4,
            color: Colors.white.withOpacity(0.9),
          ),
        ],
      ),
    );
  }

  Widget _buildEye(bool isLeft) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        // Blinking animation
        final blinkValue = math.sin(widget.animationController.value * 8 * math.pi);
        final eyeHeight = blinkValue > 0.8 ? 2.0 : 6.0;
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 6,
          height: eyeHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      },
    );
  }

  Widget _buildMouth() {
    return AnimatedBuilder(
      animation: _localController,
      builder: (context, child) {
        return Container(
          width: widget.size * 0.15,
          height: widget.size * 0.08,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(widget.size * 0.075),
              bottomRight: Radius.circular(widget.size * 0.075),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedAvatar extends StatefulWidget {
  final double size;
  final String? imageUrl;
  final String? name;
  final VoidCallback? onTap;
  final bool showOnlineIndicator;

  const AnimatedAvatar({
    super.key,
    this.size = 80,
    this.imageUrl,
    this.name,
    this.onTap,
    this.showOnlineIndicator = false,
  });

  @override
  State<AnimatedAvatar> createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends State<AnimatedAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
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
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Main avatar
                  Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: widget.imageUrl == null
                          ? AppTheme.primaryLinearGradient
                          : null,
                      image: widget.imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(widget.imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: widget.imageUrl == null
                        ? Center(
                            child: Text(
                              widget.name?.isNotEmpty == true
                                  ? widget.name![0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                fontSize: widget.size * 0.4,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : null,
                  ),
                  
                  // Online indicator
                  if (widget.showOnlineIndicator)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: widget.size * 0.25,
                        height: widget.size * 0.25,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      )
                          .animate()
                          .scale(duration: const Duration(milliseconds: 300))
                          .then()
                          .shimmer(duration: const Duration(seconds: 2)),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AvatarWithStatus extends StatelessWidget {
  final double size;
  final String? imageUrl;
  final String? name;
  final String status;
  final Color statusColor;
  final VoidCallback? onTap;

  const AvatarWithStatus({
    super.key,
    this.size = 60,
    this.imageUrl,
    this.name,
    required this.status,
    required this.statusColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedAvatar(
            size: size,
            imageUrl: imageUrl,
            name: name,
            showOnlineIndicator: true,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: statusColor.withOpacity(0.3),
              ),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}