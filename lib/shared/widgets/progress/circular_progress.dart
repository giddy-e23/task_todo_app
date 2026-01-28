import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

/// A circular progress indicator widget.
///
/// Example usage:
/// ```dart
/// CircularProgressWidget(
///   progress: 0.85,
///   size: 60,
/// )
/// ```
class CircularProgressWidget extends StatelessWidget {
  /// Progress value between 0.0 and 1.0
  final double progress;

  /// Size of the progress circle
  final double size;

  /// Stroke width of the progress arc
  final double strokeWidth;

  /// Color of the progress arc (defaults to primary)
  final Color? progressColor;

  /// Color of the background track
  final Color? trackColor;

  /// Whether to show the percentage text in the center
  final bool showPercentage;

  /// Custom child widget in the center (overrides percentage)
  final Widget? child;

  const CircularProgressWidget({
    super.key,
    required this.progress,
    this.size = 60,
    this.strokeWidth = 6,
    this.progressColor,
    this.trackColor,
    this.showPercentage = true,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final effectiveProgressColor = progressColor ?? colors.primary;
    final effectiveTrackColor = trackColor ?? colors.progressBackground;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background track
          CustomPaint(
            size: Size(size, size),
            painter: _CircularProgressPainter(
              progress: 1.0,
              color: effectiveTrackColor,
              strokeWidth: strokeWidth,
            ),
          ),
          // Progress arc
          CustomPaint(
            size: Size(size, size),
            painter: _CircularProgressPainter(
              progress: progress.clamp(0.0, 1.0),
              color: effectiveProgressColor,
              strokeWidth: strokeWidth,
            ),
          ),
          // Center content
          if (child != null)
            child!
          else if (showPercentage)
            Text(
              '${(progress * 100).round()}%',
              style: AppTypography.percentage.copyWith(
                color: colors.textPrimary,
                fontSize: size * 0.2,
              ),
            ),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Start from top (-90 degrees)
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// A small circular progress indicator for list items
class MiniProgressIndicator extends StatelessWidget {
  final double progress;
  final double size;
  final Color? color;

  const MiniProgressIndicator({
    super.key,
    required this.progress,
    this.size = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressWidget(
      progress: progress,
      size: size,
      strokeWidth: 4,
      progressColor: color,
      showPercentage: true,
    );
  }
}
