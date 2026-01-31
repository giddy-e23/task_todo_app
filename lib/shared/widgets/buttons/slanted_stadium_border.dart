import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A rectangular button shape with rounded corners and angled edges that bulge outward.
///
/// The shape has rounded corners with top and bottom edges split at the midpoint.
/// Each half-edge angles outward, creating a subtle bow-tie/double-V effect.
///
/// [tiltAmount] controls how much the half-edges bulge outward (ratio of height).
/// [cornerRadius] controls the corner rounding (default 16.0 for subtle curves).
///
/// Example usage:
/// ```dart
/// ElevatedButton(
///   style: ElevatedButton.styleFrom(
///     shape: const SlantedStadiumBorder(tiltAmount: 0.08, cornerRadius: 16),
///   ),
///   onPressed: () {},
///   child: Text('Button'),
/// )
/// ```
class SlantedStadiumBorder extends OutlinedBorder {
  /// How much the half-edges bulge outward (ratio of height).
  /// 0.0 = no tilt (straight edges)
  /// 0.05-0.12 = subtle tilt (recommended)
  final double tiltAmount;

  /// Corner radius for the rounded corners.
  /// Default is 16.0 for slightly curved corners.
  final double cornerRadius;

  const SlantedStadiumBorder({
    this.tiltAmount = 0.08,
    this.cornerRadius = 16.0,
    super.side,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _buildPath(rect);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _buildPath(rect.deflate(side.width));
  }

  Path _buildPath(Rect rect) {
    final path = Path();
    final height = rect.height;
    // Use cornerRadius, but cap it at half the height to avoid overlap
    final radius = math.min(cornerRadius, height / 2);

    // Calculate vertical offset for the tilt at center points
    final tiltOffset = height * tiltAmount;

    // Key points
    final left = rect.left;
    final right = rect.right;
    final top = rect.top;
    final bottom = rect.bottom;
    final centerX = rect.center.dx;

    // Center points of top and bottom edges (bulging outward)
    final topCenterPoint = Offset(centerX, top - tiltOffset);
    final bottomCenterPoint = Offset(centerX, bottom + tiltOffset);

    // Start from bottom-left corner (after the corner arc)
    path.moveTo(left + radius, bottom);

    // Bottom-left half: angles DOWN to center (bulge out)
    path.lineTo(bottomCenterPoint.dx, bottomCenterPoint.dy);

    // Bottom-right half: angles UP from center to bottom-right corner
    path.lineTo(right - radius, bottom);

    // Bottom-right corner arc
    path.arcTo(
      Rect.fromLTWH(
        right - radius * 2,
        bottom - radius * 2,
        radius * 2,
        radius * 2,
      ),
      math.pi / 2, // Start from bottom
      -math.pi / 2, // Sweep 90 degrees to right
      false,
    );

    // Right edge (straight up)
    path.lineTo(right, top + radius);

    // Top-right corner arc
    path.arcTo(
      Rect.fromLTWH(right - radius * 2, top, radius * 2, radius * 2),
      0, // Start from right
      -math.pi / 2, // Sweep 90 degrees to top
      false,
    );

    // Top-right half: angles UP to center (bulge out)
    path.lineTo(topCenterPoint.dx, topCenterPoint.dy);

    // Top-left half: angles DOWN from center to top-left corner
    path.lineTo(left + radius, top);

    // Top-left corner arc
    path.arcTo(
      Rect.fromLTWH(left, top, radius * 2, radius * 2),
      -math.pi / 2, // Start from top
      -math.pi / 2, // Sweep 90 degrees to left
      false,
    );

    // Left edge (straight down)
    path.lineTo(left, bottom - radius);

    // Bottom-left corner arc
    path.arcTo(
      Rect.fromLTWH(left, bottom - radius * 2, radius * 2, radius * 2),
      math.pi, // Start from left
      -math.pi / 2, // Sweep 90 degrees to bottom
      false,
    );

    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style != BorderStyle.none) {
      final paint = side.toPaint();
      canvas.drawPath(getOuterPath(rect), paint);
    }
  }

  @override
  ShapeBorder scale(double t) {
    return SlantedStadiumBorder(
      tiltAmount: tiltAmount,
      cornerRadius: cornerRadius * t,
      side: side.scale(t),
    );
  }

  @override
  OutlinedBorder copyWith({BorderSide? side}) {
    return SlantedStadiumBorder(
      tiltAmount: tiltAmount,
      cornerRadius: cornerRadius,
      side: side ?? this.side,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is SlantedStadiumBorder &&
        other.tiltAmount == tiltAmount &&
        other.cornerRadius == cornerRadius &&
        other.side == side;
  }

  @override
  int get hashCode => Object.hash(tiltAmount, cornerRadius, side);

  @override
  String toString() {
    return 'SlantedStadiumBorder(tiltAmount: $tiltAmount, cornerRadius: $cornerRadius, side: $side)';
  }
}

/// Custom painter for drawing the tilted button shape with a glow shadow.
class SlantedStadiumGlowPainter extends CustomPainter {
  final Color glowColor;
  final double blurRadius;
  final Offset shadowOffset;
  final double tiltAmount;
  final double cornerRadius;
  final bool enabled;

  const SlantedStadiumGlowPainter({
    required this.glowColor,
    this.blurRadius = 12.0,
    this.shadowOffset = const Offset(0, 6),
    this.tiltAmount = 0.08,
    this.cornerRadius = 16.0,
    this.enabled = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!enabled) return;

    final rect = Offset.zero & size;
    final path = _buildPath(rect);

    final paint = Paint()
      ..color = glowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);

    canvas.save();
    canvas.translate(shadowOffset.dx, shadowOffset.dy);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  Path _buildPath(Rect rect) {
    final path = Path();
    final height = rect.height;
    final radius = math.min(cornerRadius, height / 2);
    final tiltOffset = height * tiltAmount;

    final left = rect.left;
    final right = rect.right;
    final top = rect.top;
    final bottom = rect.bottom;
    final centerX = rect.center.dx;

    final topCenterPoint = Offset(centerX, top - tiltOffset);
    final bottomCenterPoint = Offset(centerX, bottom + tiltOffset);

    path.moveTo(left + radius, bottom);
    path.lineTo(bottomCenterPoint.dx, bottomCenterPoint.dy);
    path.lineTo(right - radius, bottom);

    path.arcTo(
      Rect.fromLTWH(
        right - radius * 2,
        bottom - radius * 2,
        radius * 2,
        radius * 2,
      ),
      math.pi / 2,
      -math.pi / 2,
      false,
    );

    path.lineTo(right, top + radius);

    path.arcTo(
      Rect.fromLTWH(right - radius * 2, top, radius * 2, radius * 2),
      0,
      -math.pi / 2,
      false,
    );

    path.lineTo(topCenterPoint.dx, topCenterPoint.dy);
    path.lineTo(left + radius, top);

    path.arcTo(
      Rect.fromLTWH(left, top, radius * 2, radius * 2),
      -math.pi / 2,
      -math.pi / 2,
      false,
    );

    path.lineTo(left, bottom - radius);

    path.arcTo(
      Rect.fromLTWH(left, bottom - radius * 2, radius * 2, radius * 2),
      math.pi,
      -math.pi / 2,
      false,
    );

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(SlantedStadiumGlowPainter oldDelegate) {
    return oldDelegate.glowColor != glowColor ||
        oldDelegate.blurRadius != blurRadius ||
        oldDelegate.shadowOffset != shadowOffset ||
        oldDelegate.tiltAmount != tiltAmount ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.enabled != enabled;
  }
}
