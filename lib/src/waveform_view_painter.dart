import 'dart:math';
import 'package:flutter/material.dart';

class WaveformPainter extends CustomPainter {
  final double progress;
  final Color playedColor;
  final Color unplayedColor;
  final Color? thumbColor;
  final double max;
  final double min;

  WaveformPainter({
    required this.progress,
    required this.playedColor,
    required this.unplayedColor,
    required this.max,
    required this.min,
    this.thumbColor,
  });

  // Simulate audio data - in a real app, this would come from audio file analysis
  final List<double> _audioSamples = List.generate(150, (index) {
    final Random random = Random();
    return 0.1 + random.nextDouble() * 0.8; // Random heights between 0.1 and 0.9
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final int sampleCount = _audioSamples.length;
    
    const double barWidth = 4; 
    const double spacing = 2;  
    const double totalBarWidth = barWidth + spacing;

    final int maxBars = (width / totalBarWidth).floor();
    final int displaySampleCount = sampleCount.clamp(0, maxBars);

    double clampedProgress = ((progress - min) / (max - min)).clamp(0.0, 1.0);

    for (int i = 0; i < displaySampleCount; i++) {
      final double barHeight = _audioSamples[i] * height * 0.8;
      final double left = i * totalBarWidth;
      final double top = (height - barHeight) / 2;

      final Paint paint = Paint()
        ..color = i <= (displaySampleCount * clampedProgress).floor() ? playedColor : unplayedColor
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, barWidth, barHeight),
          const Radius.circular(3),
        ),
        paint,
      );
    }

    if (clampedProgress > 0 && clampedProgress < 1) {
      final double progressX = (displaySampleCount * clampedProgress) * totalBarWidth;
      const double progressBarWidth = 6;

      final Paint progressPaint = Paint()
        ..color =thumbColor?? playedColor
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(progressX - (progressBarWidth / 2), 0, progressBarWidth, height),
          const Radius.circular(3),
        ),
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; 
  }


}
