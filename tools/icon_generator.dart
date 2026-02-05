import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Generate app icons with PicPic three-circle design
  await generateIcon(1024, 'Icon-1024.png');
  await generateIcon(512, 'Icon-512.png');
  await generateIcon(192, 'Icon-192.png');
  await generateIcon(180, 'Icon-180.png');
  await generateIcon(152, 'Icon-152.png');
  await generateIcon(144, 'Icon-144.png');
  await generateIcon(120, 'Icon-120.png');
  await generateIcon(114, 'Icon-114.png');
  await generateIcon(76, 'Icon-76.png');
  await generateIcon(72, 'Icon-72.png');
  await generateIcon(60, 'Icon-60.png');
  await generateIcon(57, 'Icon-57.png');
  await generateIcon(48, 'Icon-48.png');
  await generateIcon(36, 'Icon-36.png');
  await generateIcon(32, 'Icon-32.png');
  
  print('App icons generated successfully!');
}

Future<void> generateIcon(int size, String filename) async {
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);
  
  // Background gradient matching the app theme
  final backgroundGradient = LinearGradient(
    colors: [
      const Color(0xFF4A5568), // Misty gray-blue
      const Color(0xFF2D3748), // Darker misty gray
      const Color(0xFF1A202C), // Very dark misty gray
    ],
    begin: const Alignment(-1, -1),
    end: const Alignment(1, 1),
  );
  
  final backgroundPaint = Paint()
    ..shader = backgroundGradient.createShader(
      Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
    );
  
  canvas.drawRect(
    Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
    backgroundPaint,
  );
  
  // Draw three circles with different sizes (matching the logo design)
  final centerOffset = size * 0.5;
  final topCircleRadius = size * 0.15; // Largest: 30% of size
  final leftCircleRadius = size * 0.125; // Medium: 25% of size
  final rightCircleRadius = size * 0.10; // Smallest: 20% of size
  
  // Shadow paint for circles
  final shadowPaint = Paint()
    ..color = Colors.black.withOpacity(0.3);
  
  final borderPaint = Paint()
    ..color = Colors.white.withOpacity(0.95)
    ..style = PaintingStyle.stroke
    ..strokeWidth = size * 0.02;
  
  // Top circle (largest)
  final topCircleCenter = Offset(centerOffset, size * 0.2);
  canvas.drawCircle(topCircleCenter, topCircleRadius, shadowPaint);
  canvas.drawCircle(topCircleCenter, topCircleRadius, borderPaint);
  
  // Bottom left circle (medium)
  final leftCircleCenter = Offset(centerOffset - size * 0.15, centerOffset + size * 0.15);
  canvas.drawCircle(leftCircleCenter, leftCircleRadius, shadowPaint);
  canvas.drawCircle(leftCircleCenter, leftCircleRadius, borderPaint);
  
  // Bottom right circle (smallest)
  final rightCircleCenter = Offset(centerOffset + size * 0.15, centerOffset + size * 0.15);
  canvas.drawCircle(rightCircleCenter, rightCircleRadius, shadowPaint);
  canvas.drawCircle(rightCircleCenter, rightCircleRadius, borderPaint);
  
  // Convert to image
  final picture = recorder.endRecording();
  final image = picture.toImageSync(size, size);
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  
  // Save to file
  final file = File(filename);
  await file.writeAsBytes(byteData!.buffer.asUint8List());
}
