import 'dart:math';
import 'package:flutter/material.dart';

class Glass3DCube extends StatelessWidget {
  final double size = 140;

  const Glass3DCube({super.key});

  Widget buildCubeFace() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02), // Keep subtle
        border: Border.all(
          color: Colors.white.withOpacity(0.25), // Increase from 0.15 to 0.25
          width: 1.0, // Increase from 0.5 to 1.0
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // FRONT face - translate forward on Z axis
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..translate(0.0, 0.0, size/2),
            child: buildCubeFace(),
          ),
          // BACK face - translate back and rotate 180°
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..translate(0.0, 0.0, -size/2)
              ..rotateY(pi),
            child: buildCubeFace(),
          ),
          // RIGHT face - translate right and rotate 90° on Y
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..translate(size/2, 0.0, 0.0)
              ..rotateY(pi/2),
            child: buildCubeFace(),
          ),
          // LEFT face - translate left and rotate -90° on Y
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..translate(-size/2, 0.0, 0.0)
              ..rotateY(-pi/2),
            child: buildCubeFace(),
          ),
          // TOP face - translate up and rotate -90° on X
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..translate(0.0, -size/2, 0.0)
              ..rotateX(pi/2),
            child: buildCubeFace(),
          ),
          // BOTTOM face - translate down and rotate 90° on X
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..translate(0.0, size/2, 0.0)
              ..rotateX(-pi/2),
            child: buildCubeFace(),
          ),
        ],
      ),
    );
  }
}