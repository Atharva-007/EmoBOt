import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedAvatar3D extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  
  const AnimatedAvatar3D({
    super.key,
    this.size = 120.0,
    this.primaryColor = Colors.blue,
    this.secondaryColor = Colors.cyan,
  });

  @override
  State<AnimatedAvatar3D> createState() => _AnimatedAvatar3DState();
}

class _AnimatedAvatar3DState extends State<AnimatedAvatar3D>
    with TickerProviderStateMixin {
  late AnimationController _blinkController;
  late AnimationController _floatController;
  late AnimationController _headController;
  late AnimationController _eyeController;
  
  late Animation<double> _blinkAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _headRotation;
  late Animation<Offset> _eyeOffset;
  
  bool _isBlinking = false;
  Offset _mousePosition = Offset.zero;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startPeriodicAnimations();
  }
  
  void _initializeAnimations() {
    // Blink animation
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _blinkAnimation = Tween<double>(begin: 1.0, end: 0.1).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );
    
    // Float animation
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _floatAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    
    // Head rotation
    _headController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _headRotation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _headController, curve: Curves.easeInOut),
    );
    
    // Eye movement
    _eyeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _eyeOffset = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
      CurvedAnimation(parent: _eyeController, curve: Curves.easeOut),
    );
  }
  
  void _startPeriodicAnimations() {
    // Start floating animation
    _floatController.repeat(reverse: true);
    
    // Start head rotation
    _headController.repeat(reverse: true);
    
    // Random blinking
    _scheduleRandomBlink();
  }
  
  void _scheduleRandomBlink() {
    Future.delayed(Duration(milliseconds: 2000 + Random().nextInt(3000)), () {
      if (mounted) {
        _blink();
        _scheduleRandomBlink();
      }
    });
  }
  
  void _blink() async {
    if (!_isBlinking) {
      _isBlinking = true;
      await _blinkController.forward();
      await Future.delayed(const Duration(milliseconds: 100));
      await _blinkController.reverse();
      _isBlinking = false;
    }
  }
  
  void _moveEyes(Offset position) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final center = renderBox.size.center(Offset.zero);
      final localPosition = renderBox.globalToLocal(position);
      final distance = (localPosition - center).distance;
      const maxDistance = 50.0;
      
      if (distance < maxDistance * 3) {
        final normalizedOffset = Offset(
          ((localPosition.dx - center.dx) / maxDistance).clamp(-1.0, 1.0),
          ((localPosition.dy - center.dy) / maxDistance).clamp(-1.0, 1.0),
        );
        
        _eyeOffset = Tween<Offset>(
          begin: _eyeOffset.value,
          end: normalizedOffset * 3,
        ).animate(CurvedAnimation(parent: _eyeController, curve: Curves.easeOut));
        
        _eyeController.reset();
        _eyeController.forward();
      }
    }
  }
  
  @override
  void dispose() {
    _blinkController.dispose();
    _floatController.dispose();
    _headController.dispose();
    _eyeController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _blink();
        // Happy expression animation
      },
      child: MouseRegion(
        onHover: (event) {
          _moveEyes(event.position);
        },
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _floatAnimation,
            _headRotation,
            _blinkAnimation,
            _eyeOffset,
          ]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value),
              child: Transform.rotate(
                angle: _headRotation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  child: CustomPaint(
                    painter: Avatar3DPainter(
                      primaryColor: widget.primaryColor,
                      secondaryColor: widget.secondaryColor,
                      blinkProgress: _blinkAnimation.value,
                      eyeOffset: _eyeOffset.value,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 800.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0))
        .shimmer(delay: 1000.ms, duration: 2000.ms);
  }
}

class Avatar3DPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final double blinkProgress;
  final Offset eyeOffset;
  
  Avatar3DPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.blinkProgress,
    required this.eyeOffset,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Draw face shadow (3D effect)
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    
    canvas.drawCircle(
      center + const Offset(3, 3),
      radius,
      shadowPaint,
    );
    
    // Draw face gradient
    final facePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withOpacity(0.9),
          primaryColor,
          primaryColor.withOpacity(0.8),
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    canvas.drawCircle(center, radius, facePaint);
    
    // Draw face highlight (3D effect)
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    
    canvas.drawCircle(
      center - Offset(radius * 0.3, radius * 0.3),
      radius * 0.4,
      highlightPaint,
    );
    
    // Draw eyes
    _drawEyes(canvas, center, radius);
    
    // Draw mouth
    _drawMouth(canvas, center, radius);
    
    // Draw cheeks
    _drawCheeks(canvas, center, radius);
  }
  
  void _drawEyes(Canvas canvas, Offset center, double radius) {
    final eyeRadius = radius * 0.12;
    final eyeY = center.dy - radius * 0.2;
    final eyeSpacing = radius * 0.3;
    
    // Eye positions with offset for looking around
    final leftEyeCenter = Offset(
      center.dx - eyeSpacing + eyeOffset.dx,
      eyeY + eyeOffset.dy,
    );
    final rightEyeCenter = Offset(
      center.dx + eyeSpacing + eyeOffset.dx,
      eyeY + eyeOffset.dy,
    );
    
    // Eye whites
    final eyeWhitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(leftEyeCenter, eyeRadius, eyeWhitePaint);
    canvas.drawCircle(rightEyeCenter, eyeRadius, eyeWhitePaint);
    
    // Eye pupils
    final pupilRadius = eyeRadius * 0.6;
    final pupilPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(leftEyeCenter, pupilRadius, pupilPaint);
    canvas.drawCircle(rightEyeCenter, pupilRadius, pupilPaint);
    
    // Eye shine
    final shinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final shineRadius = pupilRadius * 0.3;
    canvas.drawCircle(
      leftEyeCenter - Offset(pupilRadius * 0.3, pupilRadius * 0.3),
      shineRadius,
      shinePaint,
    );
    canvas.drawCircle(
      rightEyeCenter - Offset(pupilRadius * 0.3, pupilRadius * 0.3),
      shineRadius,
      shinePaint,
    );
    
    // Eyelids for blinking
    if (blinkProgress < 1.0) {
      final lidPaint = Paint()
        ..color = primaryColor
        ..style = PaintingStyle.fill;
      
      final lidHeight = eyeRadius * 2 * (1 - blinkProgress);
      
      canvas.drawRect(
        Rect.fromCenter(
          center: leftEyeCenter,
          width: eyeRadius * 2.2,
          height: lidHeight,
        ),
        lidPaint,
      );
      
      canvas.drawRect(
        Rect.fromCenter(
          center: rightEyeCenter,
          width: eyeRadius * 2.2,
          height: lidHeight,
        ),
        lidPaint,
      );
    }
  }
  
  void _drawMouth(Canvas canvas, Offset center, double radius) {
    final mouthPaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    final mouthPath = Path();
    final mouthY = center.dy + radius * 0.2;
    final mouthWidth = radius * 0.4;
    
    mouthPath.moveTo(center.dx - mouthWidth, mouthY);
    mouthPath.quadraticBezierTo(
      center.dx, mouthY + radius * 0.1,
      center.dx + mouthWidth, mouthY,
    );
    
    canvas.drawPath(mouthPath, mouthPaint);
  }
  
  void _drawCheeks(Canvas canvas, Offset center, double radius) {
    final cheekPaint = Paint()
      ..color = secondaryColor.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    
    final cheekRadius = radius * 0.15;
    final cheekY = center.dy + radius * 0.05;
    
    canvas.drawCircle(
      Offset(center.dx - radius * 0.4, cheekY),
      cheekRadius,
      cheekPaint,
    );
    
    canvas.drawCircle(
      Offset(center.dx + radius * 0.4, cheekY),
      cheekRadius,
      cheekPaint,
    );
  }
  
  @override
  bool shouldRepaint(Avatar3DPainter oldDelegate) {
    return oldDelegate.blinkProgress != blinkProgress ||
           oldDelegate.eyeOffset != eyeOffset ||
           oldDelegate.primaryColor != primaryColor ||
           oldDelegate.secondaryColor != secondaryColor;
  }
}