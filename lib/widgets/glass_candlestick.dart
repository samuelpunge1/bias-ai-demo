import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassCandlestick extends StatefulWidget {
  final double size;
  final bool animate;
  
  const GlassCandlestick({
    super.key,
    this.size = 200,
    this.animate = true,
  });

  @override
  State<GlassCandlestick> createState() => _GlassCandlestickState();
}

class _GlassCandlestickState extends State<GlassCandlestick>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _glowController;
  late Animation<double> _floatAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    // Floating animation
    _floatController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));
    
    // Glow pulsing animation
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _floatController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) {
      return _buildCandlestick(0, 1);
    }
    
    return AnimatedBuilder(
      animation: Listenable.merge([_floatAnimation, _glowAnimation]),
      builder: (context, child) {
        return _buildCandlestick(_floatAnimation.value, _glowAnimation.value);
      },
    );
  }

  Widget _buildCandlestick(double floatValue, double glowValue) {
    return Transform.translate(
      offset: Offset(0, floatValue),
      child: Container(
        width: widget.size,
        height: widget.size * 1.5,
        decoration: BoxDecoration(
          boxShadow: [
            // Blue glow
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.3 * glowValue),
              blurRadius: 60,
              spreadRadius: 20,
            ),
            // Purple glow
            BoxShadow(
              color: AppTheme.primaryPurple.withOpacity(0.3 * glowValue),
              blurRadius: 60,
              spreadRadius: 20,
            ),
          ],
        ),
        child: CustomPaint(
          painter: GlassCandlestickPainter(
            glowIntensity: glowValue,
          ),
        ),
      ),
    );
  }
}

class GlassCandlestickPainter extends CustomPainter {
  final double glowIntensity;
  
  GlassCandlestickPainter({
    required this.glowIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Glass wick (thin vertical lines)
    final wickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.2 * glowIntensity),
          Colors.white.withOpacity(0.4 * glowIntensity),
          Colors.white.withOpacity(0.2 * glowIntensity),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    // Draw upper wick
    canvas.drawLine(
      Offset(centerX, size.height * 0.15),
      Offset(centerX, size.height * 0.35),
      wickPaint,
    );
    
    // Draw lower wick
    canvas.drawLine(
      Offset(centerX, size.height * 0.65),
      Offset(centerX, size.height * 0.85),
      wickPaint,
    );
    
    // Glass candle body with blur effect
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.3,
        size.height * 0.35,
        size.width * 0.4,
        size.height * 0.3,
      ),
      const Radius.circular(8),
    );
    
    // Glass body with gradient
    final bodyPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.1 * glowIntensity),
          AppTheme.primaryBlue.withOpacity(0.15 * glowIntensity),
          AppTheme.primaryPurple.withOpacity(0.15 * glowIntensity),
          Colors.white.withOpacity(0.05 * glowIntensity),
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(bodyRect.outerRect);
    
    // Draw glass body
    canvas.drawRRect(bodyRect, bodyPaint);
    
    // Glass border with blue-purple gradient
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.primaryBlue.withOpacity(0.3 * glowIntensity),
          AppTheme.primaryPurple.withOpacity(0.3 * glowIntensity),
        ],
      ).createShader(bodyRect.outerRect);
    
    canvas.drawRRect(bodyRect, borderPaint);
    
    // Glass highlight for depth
    final highlightRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.32,
        size.height * 0.37,
        size.width * 0.15,
        size.height * 0.1,
      ),
      const Radius.circular(6),
    );
    
    final highlightPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.3 * glowIntensity),
          Colors.white.withOpacity(0.1 * glowIntensity),
        ],
      ).createShader(highlightRect.outerRect);
    
    canvas.drawRRect(highlightRect, highlightPaint);
    
    // Inner glow effect
    final innerGlowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
      ..shader = RadialGradient(
        center: const Alignment(0, 0),
        radius: 0.8,
        colors: [
          AppTheme.primaryBlue.withOpacity(0.2 * glowIntensity),
          AppTheme.primaryPurple.withOpacity(0.1 * glowIntensity),
          Colors.transparent,
        ],
      ).createShader(bodyRect.outerRect);
    
    canvas.drawRRect(bodyRect, innerGlowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
