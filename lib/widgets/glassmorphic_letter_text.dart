import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassmorphicLetterText extends StatelessWidget {
  final String text;
  final double fontSize;
  final double letterSpacing;
  
  const GlassmorphicLetterText({
    super.key,
    required this.text,
    this.fontSize = 90,
    this.letterSpacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    final letters = text.split('');
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters.map((letter) {
        // Skip rendering for spaces, but keep spacing
        if (letter == ' ') {
          return SizedBox(width: fontSize * 0.3);
        }
        
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: letterSpacing / 2),
          child: GlassmorphicLetter(
            letter: letter,
            fontSize: fontSize,
          ),
        );
      }).toList(),
    );
  }
}

class GlassmorphicLetter extends StatefulWidget {
  final String letter;
  final double fontSize;
  
  const GlassmorphicLetter({
    super.key,
    required this.letter,
    required this.fontSize,
  });

  @override
  State<GlassmorphicLetter> createState() => _GlassmorphicLetterState();
}

class _GlassmorphicLetterState extends State<GlassmorphicLetter>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOutSine,
    ));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.fontSize;
    final containerWidth = size * 0.85;
    final containerHeight = size * 1.1;
    
    return Container(
      width: containerWidth,
      height: containerHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Base glass container with backdrop filter
          ClipRRect(
            borderRadius: BorderRadius.circular(size * 0.15),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: containerWidth,
                height: containerHeight,
                decoration: BoxDecoration(
                  // Semi-transparent white background
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(size * 0.15),
                  // Border with higher opacity
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                  // Multiple shadows for depth
                  boxShadow: [
                    // Outer shadow for depth
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                    // Inner glow at top
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 0,
                      spreadRadius: -containerHeight + 1,
                      offset: const Offset(0, -containerHeight + 1),
                    ),
                    // Inner shadow at bottom
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 0,
                      spreadRadius: -containerHeight + 1,
                      offset: Offset(0, containerHeight - 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Top gradient shine (like ::before in CSS)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.8),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size * 0.15),
                  topRight: Radius.circular(size * 0.15),
                ),
              ),
            ),
          ),
          
          // Left gradient shine (like ::after in CSS)
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.8),
                    Colors.transparent,
                    Colors.white.withOpacity(0.3),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size * 0.15),
                  bottomLeft: Radius.circular(size * 0.15),
                ),
              ),
            ),
          ),
          
          // Inner glow effect
          Container(
            width: containerWidth * 0.9,
            height: containerHeight * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * 0.12),
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.05),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          
          // Animated shimmer effect
          AnimatedBuilder(
            animation: _shimmerAnimation,
            builder: (context, child) {
              return Positioned(
                left: containerWidth * _shimmerAnimation.value,
                child: Container(
                  width: containerWidth * 0.5,
                  height: containerHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          
          // The actual letter with gradient
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  AppTheme.primaryBlue.withOpacity(0.8),
                  AppTheme.primaryPurple.withOpacity(0.8),
                  Colors.white.withOpacity(0.9),
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ).createShader(bounds);
            },
            child: Text(
              widget.letter,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                shadows: [
                  // Blue accent shadow
                  Shadow(
                    blurRadius: 20,
                    color: AppTheme.primaryBlue.withOpacity(0.5),
                    offset: const Offset(2, 2),
                  ),
                  // Purple accent shadow
                  Shadow(
                    blurRadius: 20,
                    color: AppTheme.primaryPurple.withOpacity(0.5),
                    offset: const Offset(-2, -2),
                  ),
                  // White glow for visibility
                  Shadow(
                    blurRadius: 10,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),
          
          // Blue accent on bottom-right corner
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: containerWidth * 0.3,
              height: containerHeight * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(size * 0.15),
                ),
                gradient: RadialGradient(
                  center: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryBlue.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // Purple accent on top-left corner
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: containerWidth * 0.3,
              height: containerHeight * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size * 0.15),
                ),
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  colors: [
                    AppTheme.primaryPurple.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
