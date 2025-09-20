import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CandlestickLogo extends StatefulWidget {
  final double size;
  final bool animate;
  final bool isBullish;
  
  const CandlestickLogo({
    super.key,
    this.size = 60,
    this.animate = true,
    this.isBullish = true,
  });

  @override
  State<CandlestickLogo> createState() => _CandlestickLogoState();
}

class _CandlestickLogoState extends State<CandlestickLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _controller = AnimationController(
        duration: const Duration(seconds: 3),
        vsync: this,
      )..repeat(reverse: true);
      
      _floatAnimation = Tween<double>(
        begin: -5.0,
        end: 5.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      
      _glowAnimation = Tween<double>(
        begin: 0.5,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
    } else {
      _controller = AnimationController(vsync: this);
      _floatAnimation = const AlwaysStoppedAnimation(0.0);
      _glowAnimation = const AlwaysStoppedAnimation(1.0);
    }
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
        return Transform.translate(
          offset: Offset(0, widget.animate ? _floatAnimation.value : 0),
          child: Container(
            width: widget.size,
            height: widget.size * 1.5,
            decoration: BoxDecoration(
              boxShadow: widget.animate ? [
                BoxShadow(
                  color: (widget.isBullish ? Colors.green : Colors.red)
                      .withOpacity(0.3 * _glowAnimation.value),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: AppTheme.primaryPurple
                      .withOpacity(0.2 * _glowAnimation.value),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ] : [],
            ),
            child: CustomPaint(
              painter: CandlestickPainter(
                isBullish: widget.isBullish,
                glowIntensity: widget.animate ? _glowAnimation.value : 1.0,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CandlestickPainter extends CustomPainter {
  final bool isBullish;
  final double glowIntensity;
  
  CandlestickPainter({
    required this.isBullish,
    required this.glowIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;
    
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    // Colors based on bullish or bearish
    final Color primaryColor = isBullish 
        ? Colors.green.withOpacity(0.9)
        : Colors.red.withOpacity(0.9);
    
    final Color secondaryColor = isBullish
        ? Colors.green.shade700
        : Colors.red.shade700;
    
    final Color accentColor = AppTheme.primaryPurple.withOpacity(0.3);
    
    // Wick (thin line)
    final wickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          secondaryColor.withOpacity(glowIntensity),
          primaryColor.withOpacity(glowIntensity),
          secondaryColor.withOpacity(glowIntensity),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    // Draw upper wick
    canvas.drawLine(
      Offset(size.width / 2, size.height * 0.1),
      Offset(size.width / 2, size.height * 0.35),
      wickPaint,
    );
    
    // Draw lower wick
    canvas.drawLine(
      Offset(size.width / 2, size.height * 0.65),
      Offset(size.width / 2, size.height * 0.9),
      wickPaint,
    );
    
    // Body (rectangle with gradient)
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.25,
        size.height * 0.35,
        size.width * 0.5,
        size.height * 0.3,
      ),
      const Radius.circular(4),
    );
    
    // Gradient for body
    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryColor.withOpacity(glowIntensity),
        primaryColor.withOpacity(0.8 * glowIntensity),
        accentColor.withOpacity(glowIntensity),
      ],
    ).createShader(bodyRect.outerRect);
    
    // Draw body
    canvas.drawRRect(bodyRect, paint);
    
    // Draw body border with gradient
    strokePaint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.3 * glowIntensity),
        AppTheme.primaryBlue.withOpacity(0.3 * glowIntensity),
      ],
    ).createShader(bodyRect.outerRect);
    
    canvas.drawRRect(bodyRect, strokePaint);
    
    // Add highlight for glass effect
    final highlightPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.center,
        colors: [
          Colors.white.withOpacity(0.2 * glowIntensity),
          Colors.white.withOpacity(0.0),
        ],
      ).createShader(bodyRect.outerRect);
    
    final highlightRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.25,
        size.height * 0.35,
        size.width * 0.5,
        size.height * 0.15,
      ),
      const Radius.circular(4),
    );
    
    canvas.drawRRect(highlightRect, highlightPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
