import 'dart:math';
import 'package:flutter/material.dart';

/// A custom painter that renders a waveform visualization.
/// 
/// The `WaveformPainter` class is useful for visualizing audio data in a waveform
/// format, displaying progress based on a given value and rendering different colors
/// for played and unplayed segments.
class WaveformPainter extends CustomPainter {
  /// The progress of the waveform playback, ranging from [min] to [max].
  final double progress;

  /// The color used to paint the played portion of the waveform.
  final Color playedColor;

  /// The color used to paint the unplayed portion of the waveform.
  final Color unplayedColor;

  /// The color of the progress thumb indicator. If null, defaults to [playedColor].
  final Color? thumbColor;

  /// The maximum value of the progress range.
  final double max;

  /// The minimum value of the progress range.
  final double min;

  /// Constructs a [WaveformPainter].
  /// 
  /// [progress], [playedColor], [unplayedColor], [max], and [min] are required.
  /// [thumbColor] is optional and will default to [playedColor] if not provided.
  WaveformPainter({
    required this.progress,
    required this.playedColor,
    required this.unplayedColor,
    required this.max,
    required this.min,
    this.thumbColor,
  });

  /// Simulated audio data represented as a list of doubles ranging from 0.1 to 0.9.
  /// 
  /// This data is randomly generated and should be replaced by actual audio file analysis.
  final List<double> _audioSamples = List.generate(150, (index) {
    final Random random = Random();
    return 0.1 + random.nextDouble() * 0.8;
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
        ..color = thumbColor ?? playedColor
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
