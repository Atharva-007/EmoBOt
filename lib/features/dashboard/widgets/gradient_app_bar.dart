import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

import '../../../core/theme/app_theme.dart';

class GradientAppBar extends StatelessWidget {
  final double scrollOffset;
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;

  const GradientAppBar({
    super.key,
    required this.scrollOffset,
    this.title,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Calculate opacity based on scroll
    final opacity = (scrollOffset / 200).clamp(0.0, 1.0);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color(0xFF1A1A2E).withOpacity(0.9 + opacity * 0.1),
                  Color(0xFF16213E).withOpacity(0.9 + opacity * 0.1),
                ]
              : [
                  Color(0xFFF8FAFF).withOpacity(0.9 + opacity * 0.1),
                  Color(0xFFE8F4FD).withOpacity(0.9 + opacity * 0.1),
                ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // Leading
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 16),
              ],
              
              // Title section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: 1.0 - (opacity * 0.5),
                      child: Text(
                        'EmuBot',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                          background: Paint()
                            ..shader = AppTheme.primaryLinearGradient.createShader(
                              const Rect.fromLTWH(0, 0, 200, 50),
                            ),
                        ),
                      ),
                    ),
                    
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: 1.0 - opacity,
                      child: Text(
                        'Your AI Assistant',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Actions
              if (actions != null)
                Row(children: actions!)
              else
                _buildDefaultActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultActions(BuildContext context) {
    return Row(
      children: [
        // Notification bell
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // TODO: Show notifications
              },
              borderRadius: BorderRadius.circular(12),
              child: Icon(
                Icons.notifications_outlined,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
                size: 22,
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Settings
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // TODO: Show settings
              },
              borderRadius: BorderRadius.circular(12),
              child: Icon(
                Icons.settings_outlined,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
                size: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedGradientAppBar extends StatefulWidget {
  final double scrollOffset;
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;

  const AnimatedGradientAppBar({
    super.key,
    required this.scrollOffset,
    this.title,
    this.actions,
    this.leading,
  });

  @override
  State<AnimatedGradientAppBar> createState() => _AnimatedGradientAppBarState();
}

class _AnimatedGradientAppBarState extends State<AnimatedGradientAppBar>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _particles = List.generate(5, (index) => Particle(index));
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated background particles
        AnimatedBuilder(
          animation: _particleController,
          builder: (context, child) {
            return CustomPaint(
              size: Size.infinite,
              painter: ParticlePainter(_particles, _particleController.value),
            );
          },
        ),
        
        // Main app bar content
        GradientAppBar(
          scrollOffset: widget.scrollOffset,
          title: widget.title,
          actions: widget.actions,
          leading: widget.leading,
        ),
      ],
    );
  }
}

class Particle {
  final int index;
  late double x;
  late double y;
  late double size;
  late Color color;
  late double speed;

  Particle(this.index) {
    _reset();
  }

  void _reset() {
    x = math.Random().nextDouble();
    y = math.Random().nextDouble();
    size = 2 + math.Random().nextDouble() * 6;
    speed = 0.02 + math.Random().nextDouble() * 0.03;
    
    final colors = [
      AppTheme.primaryColor.withOpacity(0.3),
      AppTheme.secondaryColor.withOpacity(0.3),
      AppTheme.accentColor.withOpacity(0.3),
    ];
    color = colors[math.Random().nextInt(colors.length)];
  }

  void update(double animationValue) {
    x += speed;
    if (x > 1.1) {
      x = -0.1;
      y = math.Random().nextDouble();
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      particle.update(animationValue);
      
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(
          particle.x * size.width,
          particle.y * size.height,
        ),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GlassMorphicAppBar extends StatelessWidget {
  final double scrollOffset;
  final String title;
  final List<Widget>? actions;

  const GlassMorphicAppBar({
    super.key,
    required this.scrollOffset,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = (scrollOffset / 100).clamp(0.0, 0.9);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity * 0.1),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(opacity * 0.2),
            width: 1,
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.transparent,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (actions != null) ...actions!,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}