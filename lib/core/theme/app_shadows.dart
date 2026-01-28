import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Elevation shadows matching the Figma design.
///
/// Usage:
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     color: Colors.white,
///     borderRadius: AppRadius.borderRadiusMD,
///     boxShadow: AppShadows.elevation2(context),
///   ),
/// )
/// ```
abstract class AppShadows {
  // ============== Light Theme Shadows ==============
  /// Subtle shadow for cards and surfaces
  static List<BoxShadow> elevationLight1 = [
    BoxShadow(
      color: const Color(0xFF544A71).withOpacity(0.04),
      blurRadius: 4,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Standard card shadow (from Figma design)
  static List<BoxShadow> elevationLight2 = [
    BoxShadow(
      color: const Color(0xFF544A71).withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Elevated card shadow
  static List<BoxShadow> elevationLight3 = [
    BoxShadow(
      color: const Color(0xFF544A71).withOpacity(0.12),
      blurRadius: 16,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  /// High elevation shadow (modals, FABs)
  static List<BoxShadow> elevationLight4 = [
    BoxShadow(
      color: const Color(0xFF544A71).withOpacity(0.15),
      blurRadius: 30,
      offset: const Offset(0, 12),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: const Color(0xFF544A71).withOpacity(0.06),
      blurRadius: 6,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Cover/hero shadow (from Figma: 60px 40px 50px rgba(84,74,113,0.15))
  static List<BoxShadow> elevationLightHero = [
    BoxShadow(
      color: const Color(0xFF544A71).withOpacity(0.15),
      blurRadius: 50,
      offset: const Offset(60, 40),
      spreadRadius: 0,
    ),
  ];

  /// Primary color glow shadow (for primary buttons, FAB)
  static List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: AppColorPalette.primary.withOpacity(0.35),
      blurRadius: 12,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  /// Success color glow
  static List<BoxShadow> successGlow = [
    BoxShadow(
      color: AppColorPalette.success.withOpacity(0.3),
      blurRadius: 10,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Warning color glow
  static List<BoxShadow> warningGlow = [
    BoxShadow(
      color: AppColorPalette.warning.withOpacity(0.3),
      blurRadius: 10,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  // ============== Dark Theme Shadows ==============
  /// Dark theme shadows are more subtle
  static List<BoxShadow> elevationDark1 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 4,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> elevationDark2 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 8,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> elevationDark3 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.4),
      blurRadius: 16,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> elevationDark4 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      blurRadius: 30,
      offset: const Offset(0, 12),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 6,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Primary glow for dark theme (slightly brighter)
  static List<BoxShadow> primaryGlowDark = [
    BoxShadow(
      color: AppColorPalette.primaryLight.withOpacity(0.4),
      blurRadius: 12,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  // ============== Context-Aware Shadow Getters ==============
  /// Get level 1 shadow based on current theme
  static List<BoxShadow> elevation1(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? elevationDark1
        : elevationLight1;
  }

  /// Get level 2 shadow based on current theme
  static List<BoxShadow> elevation2(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? elevationDark2
        : elevationLight2;
  }

  /// Get level 3 shadow based on current theme
  static List<BoxShadow> elevation3(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? elevationDark3
        : elevationLight3;
  }

  /// Get level 4 shadow based on current theme
  static List<BoxShadow> elevation4(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? elevationDark4
        : elevationLight4;
  }

  /// Get primary glow shadow based on current theme
  static List<BoxShadow> primaryShadow(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? primaryGlowDark
        : primaryGlow;
  }

  // ============== No Shadow ==============
  static const List<BoxShadow> none = [];
}
