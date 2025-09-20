import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// This script generates app icons with a candlestick design
// Run with: flutter run lib/generate_app_icon.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Icon sizes needed for iOS
  final iconSizes = [
    20, 29, 40, 58, 60, 76, 80, 87, 120, 152, 167, 180, 1024
  ];
  
  for (int size in iconSizes) {
    await generateIcon(size);
  }
  
  print('✅ App icons generated successfully!');
  exit(0);
}

Future<void> generateIcon(int size) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(
    recorder,
    Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
  );
  
  // Draw background
  final backgroundPaint = Paint()
    ..shader = ui.Gradient.radial(
      Offset(size / 2, size / 2),
      size / 2,
      [
        const Color(0xFF000000),
        const Color(0xFF0A0A0A),
      ],
    );
  
  canvas.drawRect(
    Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
    backgroundPaint,
  );
  
  // Draw subtle gradient overlay
  final overlayPaint = Paint()
    ..shader = ui.Gradient.linear(
      const Offset(0, 0),
      Offset(size.toDouble(), size.toDouble()),
      [
        const Color(0x1A1E3A8A), // Dark blue with low opacity
        const Color(0x1A6B21A8), // Purple with low opacity
      ],
    );
  
  canvas.drawRect(
    Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
    overlayPaint,
  );
  
  // Draw candlestick
  drawCandlestick(canvas, size.toDouble());
  
  // Convert to image
  final picture = recorder.endRecording();
  final image = await picture.toImage(size, size);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  
  if (byteData != null) {
    final buffer = byteData.buffer.asUint8List();
    await saveIcon(buffer, size);
  }
}

void drawCandlestick(Canvas canvas, double size) {
  final centerX = size / 2;
  final centerY = size / 2;
  
  // Scale factors based on icon size
  final scale = size / 1024.0;
  final wickWidth = 20 * scale;
  final bodyWidth = size * 0.3;
  final bodyHeight = size * 0.25;
  
  // Wick paint with gradient
  final wickPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = wickWidth
    ..strokeCap = StrokeCap.round
    ..shader = ui.Gradient.linear(
      Offset(centerX, size * 0.15),
      Offset(centerX, size * 0.85),
      [
        Colors.green.shade700.withOpacity(0.9),
        Colors.green.withOpacity(0.95),
        Colors.green.shade700.withOpacity(0.9),
      ],
    );
  
  // Draw upper wick
  canvas.drawLine(
    Offset(centerX, size * 0.15),
    Offset(centerX, size * 0.375),
    wickPaint,
  );
  
  // Draw lower wick
  canvas.drawLine(
    Offset(centerX, size * 0.625),
    Offset(centerX, size * 0.85),
    wickPaint,
  );
  
  // Body with gradient
  final bodyRect = RRect.fromRectAndRadius(
    Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: bodyWidth,
      height: bodyHeight,
    ),
    Radius.circular(size * 0.02),
  );
  
  // Body gradient paint
  final bodyPaint = Paint()
    ..shader = ui.Gradient.linear(
      Offset(centerX - bodyWidth / 2, centerY - bodyHeight / 2),
      Offset(centerX + bodyWidth / 2, centerY + bodyHeight / 2),
      [
        Colors.green.withOpacity(0.95),
        Colors.green.shade600.withOpacity(0.9),
        const Color(0xFF6B21A8).withOpacity(0.3), // Purple accent
      ],
    );
  
  canvas.drawRRect(bodyRect, bodyPaint);
  
  // Body border
  final borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2 * scale
    ..shader = ui.Gradient.linear(
      Offset(centerX - bodyWidth / 2, centerY - bodyHeight / 2),
      Offset(centerX + bodyWidth / 2, centerY + bodyHeight / 2),
      [
        Colors.white.withOpacity(0.3),
        const Color(0xFF1E3A8A).withOpacity(0.3), // Blue accent
      ],
    );
  
  canvas.drawRRect(bodyRect, borderPaint);
  
  // Highlight for glass effect
  final highlightPaint = Paint()
    ..shader = ui.Gradient.linear(
      Offset(centerX, centerY - bodyHeight / 2),
      Offset(centerX, centerY),
      [
        Colors.white.withOpacity(0.25),
        Colors.white.withOpacity(0.0),
      ],
    );
  
  final highlightRect = RRect.fromRectAndRadius(
    Rect.fromLTWH(
      centerX - bodyWidth / 2,
      centerY - bodyHeight / 2,
      bodyWidth,
      bodyHeight / 2,
    ),
    Radius.circular(size * 0.02),
  );
  
  canvas.drawRRect(highlightRect, highlightPaint);
}

Future<void> saveIcon(Uint8List bytes, int size) async {
  // Determine the filename based on size
  String filename;
  
  switch (size) {
    case 20:
      filename = 'Icon-App-20x20@1x.png';
      break;
    case 29:
      filename = 'Icon-App-29x29@1x.png';
      break;
    case 40:
      filename = 'Icon-App-40x40@1x.png';
      break;
    case 58:
      filename = 'Icon-App-29x29@2x.png';
      break;
    case 60:
      filename = 'Icon-App-20x20@3x.png';
      break;
    case 76:
      filename = 'Icon-App-76x76@1x.png';
      break;
    case 80:
      filename = 'Icon-App-40x40@2x.png';
      break;
    case 87:
      filename = 'Icon-App-29x29@3x.png';
      break;
    case 120:
      filename = 'Icon-App-60x60@2x.png';
      break;
    case 152:
      filename = 'Icon-App-76x76@2x.png';
      break;
    case 167:
      filename = 'Icon-App-83.5x83.5@2x.png';
      break;
    case 180:
      filename = 'Icon-App-60x60@3x.png';
      break;
    case 1024:
      filename = 'Icon-App-1024x1024@1x.png';
      break;
    default:
      filename = 'Icon-App-${size}x$size.png';
  }
  
  final file = File('ios/Runner/Assets.xcassets/AppIcon.appiconset/$filename');
  await file.writeAsBytes(bytes);
  
  print('Generated: $filename');
}
