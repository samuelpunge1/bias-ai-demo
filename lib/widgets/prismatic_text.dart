import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'glass_3d_cube.dart';

class PrismaticText extends StatefulWidget {
  final String text;
  final double fontSize;
  final double letterSpacing;

  const PrismaticText({
    super.key,
    required this.text,
    this.fontSize = 80,
    this.letterSpacing = 2,
  });

  @override
  State<PrismaticText> createState() => _PrismaticTextState();
}

class _PrismaticTextState extends State<PrismaticText>
    with TickerProviderStateMixin {
  late AnimationController _cubeRotationController;
  late AnimationController _distortionController;
  late Animation<double> _cubeRotationAnimation;
  late Animation<double> _distortionAnimation;

  @override
  void initState() {
    super.initState();

    // Cube rotation controller (same as Glass3DCube for synchronization)
    _cubeRotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _cubeRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cubeRotationController,
      curve: Curves.linear,
    ));

    // Distortion controller for glitch effects
    _distortionController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _distortionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _distortionController,
      curve: Curves.easeInOut,
    ));

    // Listen to cube rotation to trigger distortion effects
    _cubeRotationAnimation.addListener(_handleCubeRotation);
  }

  void _handleCubeRotation() {
    // Create distortion effects when cube edges pass over text
    final rotationValue = _cubeRotationAnimation.value;
    final edgePassThreshold = 0.05; // How close to edge transitions

    // Check for edge intersections (simplified logic)
    final isNearEdge = (rotationValue % 0.25 < edgePassThreshold) ||
        ((rotationValue % 0.25) > (0.25 - edgePassThreshold));

    if (isNearEdge && _distortionController.status != AnimationStatus.forward) {
      _distortionController.forward().then((_) {
        _distortionController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _cubeRotationController.dispose();
    _distortionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_cubeRotationAnimation, _distortionAnimation]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Base white text
            _buildBaseText(),

            // Chromatic aberration layers
            _buildChromaticAberration(),

            // Glass cube overlay
            Transform.translate(
              offset: const Offset(0, -10), // Float 10px in front
              child: const Glass3DCube(size: 120),
            ),

            // Distortion overlay when cube edges intersect
            if (_distortionAnimation.value > 0) _buildDistortionEffect(),
          ],
        );
      },
    );
  }

  Widget _buildBaseText() {
    return Text(
      widget.text,
      style: TextStyle(
        fontSize: widget.fontSize,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: widget.letterSpacing,
      ),
    );
  }

  Widget _buildChromaticAberration() {
    final rotation = _cubeRotationAnimation.value * 2 * pi;
    final intensity = _calculateAberrationIntensity();

    if (intensity <= 0) return const SizedBox.shrink();

    return Stack(
      alignment: Alignment.center,
      children: [
        // Blue chromatic aberration (offset left)
        Transform.translate(
          offset: Offset(-2 * sin(rotation) * intensity, 0),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryBlue.withOpacity(0.3 * intensity),
              letterSpacing: widget.letterSpacing,
            ),
          ),
        ),

        // Purple chromatic aberration (offset right)
        Transform.translate(
          offset: Offset(2 * sin(rotation) * intensity, 0),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryPurple.withOpacity(0.3 * intensity),
              letterSpacing: widget.letterSpacing,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDistortionEffect() {
    final random = Random();
    final distortionIntensity = _distortionAnimation.value;

    return Transform.translate(
      offset: Offset(
        (random.nextDouble() * 4 - 2) * distortionIntensity, // -2 to 2 pixel shake
        (random.nextDouble() * 4 - 2) * distortionIntensity,
      ),
      child: Text(
        widget.text,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.w700,
          color: Colors.white.withOpacity(0.5 * distortionIntensity),
          letterSpacing: widget.letterSpacing,
        ),
      ),
    );
  }

  double _calculateAberrationIntensity() {
    // Calculate chromatic aberration intensity based on cube rotation
    final rotationValue = _cubeRotationAnimation.value;
    final rotationX = rotationValue * 2 * pi;
    final rotationY = rotationValue * 1.5 * pi;

    // Create intensity peaks when specific cube faces are visible
    final faceVisibilityX = (sin(rotationX) + 1) / 2; // 0 to 1
    final faceVisibilityY = (sin(rotationY) + 1) / 2; // 0 to 1

    // Combine face visibilities to create prismatic effect
    final combinedIntensity = (faceVisibilityX * faceVisibilityY) * 0.8;

    // Add some randomness for the glitch effect
    final glitchIntensity = _distortionAnimation.value * 0.3;

    return (combinedIntensity + glitchIntensity).clamp(0.0, 1.0);
  }
}