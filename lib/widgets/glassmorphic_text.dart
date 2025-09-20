import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassmorphicText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final double blurAmount;
  final List<Color> gradientColors;
  
  const GlassmorphicText({
    super.key,
    required this.text,
    this.textStyle,
    this.blurAmount = 10.0,
    this.gradientColors = const [],
  });

  @override
  Widget build(BuildContext context) {
    final style = textStyle ??
        const TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.w700,
          letterSpacing: -2,
        );
    
    final colors = gradientColors.isNotEmpty
        ? gradientColors
        : [
            AppTheme.primaryBlue.withOpacity(0.8),
            AppTheme.primaryPurple.withOpacity(0.8),
          ];

    return Stack(
      children: [
        // Blurred background layer for depth
        Positioned(
          top: 2,
          left: 2,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
            child: Text(
              text,
              style: style.copyWith(
                foreground: Paint()
                  ..color = Colors.black.withOpacity(0.3),
              ),
            ),
          ),
        ),
        
        // Glass effect layer
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
                stops: const [0.0, 0.5, 1.0],
              ).createShader(bounds);
            },
            child: Text(
              text,
              style: style.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ),
        
        // Main text with gradient and glass effect
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.9),
                    colors[0].withOpacity(0.8),
                    colors[1].withOpacity(0.8),
                    Colors.white.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ).createShader(bounds);
              },
              child: Text(
                text,
                style: style.copyWith(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: colors[0].withOpacity(0.5),
                      offset: const Offset(0, 0),
                    ),
                    Shadow(
                      blurRadius: 20,
                      color: colors[1].withOpacity(0.5),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Highlight layer for glass effect
        ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.3),
                Colors.transparent,
                Colors.transparent,
                Colors.white.withOpacity(0.1),
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ).createShader(bounds);
          },
          child: Text(
            text,
            style: style.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
