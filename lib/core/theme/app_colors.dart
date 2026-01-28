import 'package:flutter/material.dart';

/// App color palette extracted from Figma design system.
///
/// Task Management & To-do List App
/// Design: https://www.figma.com/design/U7sk8wkrbitinE9yzX77KX
///
/// Usage:
/// - Access semantic colors via [AppColors.light] or [AppColors.dark]
/// - Access raw palette colors via [AppColorPalette]
abstract class AppColorPalette {
  // ============== Primary Colors ==============
  /// Main brand purple color
  static const Color primary = Color(0xFF5F33E1);
  static const Color primaryLight = Color(0xFF7B5AE8);
  static const Color primaryDark = Color(0xFF4A28B3);
  static const Color primarySurface = Color(0xFFEDE8FB);
  static const Color primarySurfaceLight = Color(0xFFF4F1FD);

  // ============== Secondary Colors ==============
  static const Color secondary = Color(0xFF6E6A7C);
  static const Color secondaryLight = Color(0xFF9795A3);
  static const Color secondaryDark = Color(0xFF4E4B5C);

  // ============== Accent Colors ==============
  /// Yellow accent for highlights and branding
  static const Color accent = Color(0xFFF6E31A);
  static const Color accentLight = Color(0xFFFFF8C4);
  static const Color accentDark = Color(0xFFD9C817);

  // ============== Neutral/Grayscale Colors ==============
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFFAFAFA);
  static const Color grey50 = Color(0xFFF8F8FA);
  static const Color grey100 = Color(0xFFEFF0F7);
  static const Color grey200 = Color(0xFFEFF0F6);
  static const Color grey300 = Color(0xFFD9DBE9);
  static const Color grey400 = Color(0xFFA0A3BD);
  static const Color grey500 = Color(0xFF6E7191);
  static const Color grey600 = Color(0xFF4E4B59);
  static const Color grey700 = Color(0xFF24252C);
  static const Color grey800 = Color(0xFF1A1A20);
  static const Color grey900 = Color(0xFF14142B);
  static const Color black = Color(0xFF000000);

  // ============== Status/Semantic Colors ==============
  /// Success - Green
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color successDark = Color(0xFF2E7D32);
  static const Color successSurface = Color(0xFFE0F5E1);

  /// Warning - Orange
  static const Color warning = Color(0xFFFF7D53);
  static const Color warningLight = Color(0xFFFFE2D9);
  static const Color warningDark = Color(0xFFE85A2E);
  static const Color warningSurface = Color(0xFFFFF0EB);

  /// Error - Red
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color errorDark = Color(0xFFD32F2F);
  static const Color errorSurface = Color(0xFFFFE5E3);

  /// Info - Blue
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFE3F2FD);
  static const Color infoDark = Color(0xFF1976D2);
  static const Color infoSurface = Color(0xFFE3EEFF);

  // ============== Task Category Colors ==============
  /// Office/Work - Orange
  static const Color categoryOrange = Color(0xFFFF7D53);
  static const Color categoryOrangeSurface = Color(0xFFFFE2D9);

  /// Personal - Purple
  static const Color categoryPurple = Color(0xFF5F33E1);
  static const Color categoryPurpleSurface = Color(0xFFEDE8FB);

  /// Daily Study - Green
  static const Color categoryGreen = Color(0xFF0ECC5A);
  static const Color categoryGreenSurface = Color(0xFFE0F9EA);

  /// Social - Pink
  static const Color categoryPink = Color(0xFFE91E8C);
  static const Color categorySurface = Color(0xFFFDE2F1);

  // ============== Gradient Colors ==============
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8F67E8), Color(0xFF5F33E1)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5F33E1), Color(0xFF7B5AE8)],
  );
}

/// Semantic color assignments for light theme
class AppColorsLight {
  // ============== Background Colors ==============
  final Color background = AppColorPalette.offWhite;
  final Color surface = AppColorPalette.white;
  final Color surfaceVariant = AppColorPalette.grey100;
  final Color scaffoldBackground = AppColorPalette.offWhite;
  final Color cardBackground = AppColorPalette.white;

  // ============== Primary Colors ==============
  final Color primary = AppColorPalette.primary;
  final Color primaryContainer = AppColorPalette.primarySurface;
  final Color onPrimary = AppColorPalette.white;
  final Color onPrimaryContainer = AppColorPalette.primary;

  // ============== Secondary Colors ==============
  final Color secondary = AppColorPalette.secondary;
  final Color secondaryContainer = AppColorPalette.grey200;
  final Color onSecondary = AppColorPalette.white;
  final Color onSecondaryContainer = AppColorPalette.grey700;

  // ============== Accent Colors ==============
  final Color accent = AppColorPalette.accent;
  final Color accentContainer = AppColorPalette.accentLight;
  final Color onAccent = AppColorPalette.grey900;

  // ============== Text Colors ==============
  final Color textPrimary = AppColorPalette.grey900;
  final Color textSecondary = AppColorPalette.grey500;
  final Color textTertiary = AppColorPalette.grey400;
  final Color textDisabled = AppColorPalette.grey300;
  final Color textOnPrimary = AppColorPalette.white;
  final Color textHint = AppColorPalette.grey400;

  // ============== Border Colors ==============
  final Color border = AppColorPalette.grey200;
  final Color borderLight = AppColorPalette.grey100;
  final Color borderFocused = AppColorPalette.primary;
  final Color divider = AppColorPalette.grey200;

  // ============== Icon Colors ==============
  final Color icon = AppColorPalette.grey700;
  final Color iconSecondary = AppColorPalette.grey500;
  final Color iconDisabled = AppColorPalette.grey400;
  final Color iconOnPrimary = AppColorPalette.white;

  // ============== Status Colors ==============
  final Color success = AppColorPalette.success;
  final Color successBackground = AppColorPalette.successSurface;
  final Color onSuccess = AppColorPalette.white;

  final Color warning = AppColorPalette.warning;
  final Color warningBackground = AppColorPalette.warningSurface;
  final Color onWarning = AppColorPalette.white;

  final Color error = AppColorPalette.error;
  final Color errorBackground = AppColorPalette.errorSurface;
  final Color onError = AppColorPalette.white;

  final Color info = AppColorPalette.info;
  final Color infoBackground = AppColorPalette.infoSurface;
  final Color onInfo = AppColorPalette.white;

  // ============== Task Status Colors ==============
  final Color statusTodo = AppColorPalette.categoryOrange;
  final Color statusTodoBackground = AppColorPalette.categoryOrangeSurface;
  final Color statusInProgress = AppColorPalette.categoryPurple;
  final Color statusInProgressBackground =
      AppColorPalette.categoryPurpleSurface;
  final Color statusDone = AppColorPalette.categoryGreen;
  final Color statusDoneBackground = AppColorPalette.categoryGreenSurface;

  // ============== Component Specific ==============
  final Color chipBackground = AppColorPalette.grey100;
  final Color chipSelectedBackground = AppColorPalette.primary;
  final Color tabBackground = AppColorPalette.grey100;
  final Color tabSelectedBackground = AppColorPalette.primary;
  final Color progressBackground = AppColorPalette.grey200;
  final Color progressFill = AppColorPalette.primary;

  // ============== Bottom Navigation ==============
  final Color bottomNavBackground = AppColorPalette.white;
  final Color bottomNavSelected = AppColorPalette.primary;
  final Color bottomNavUnselected = AppColorPalette.grey400;

  // ============== Overlay & Shadows ==============
  final Color overlay = const Color(0x52000000);
  final Color shadow = const Color(0x1F544A71); // rgba(84,74,113,0.12)
  final Color shadowLight = const Color(0x0F544A71);

  const AppColorsLight();
}

/// Semantic color assignments for dark theme
class AppColorsDark {
  // ============== Background Colors ==============
  final Color background = const Color(0xFF121217);
  final Color surface = const Color(0xFF1E1E26);
  final Color surfaceVariant = const Color(0xFF2A2A35);
  final Color scaffoldBackground = const Color(0xFF121217);
  final Color cardBackground = const Color(0xFF1E1E26);

  // ============== Primary Colors ==============
  final Color primary = AppColorPalette.primaryLight;
  final Color primaryContainer = const Color(0xFF2D2647);
  final Color onPrimary = AppColorPalette.white;
  final Color onPrimaryContainer = AppColorPalette.primaryLight;

  // ============== Secondary Colors ==============
  final Color secondary = AppColorPalette.grey400;
  final Color secondaryContainer = const Color(0xFF3A3A48);
  final Color onSecondary = AppColorPalette.grey900;
  final Color onSecondaryContainer = AppColorPalette.grey300;

  // ============== Accent Colors ==============
  final Color accent = AppColorPalette.accent;
  final Color accentContainer = const Color(0xFF3D3A1A);
  final Color onAccent = AppColorPalette.grey900;

  // ============== Text Colors ==============
  final Color textPrimary = AppColorPalette.offWhite;
  final Color textSecondary = AppColorPalette.grey400;
  final Color textTertiary = AppColorPalette.grey500;
  final Color textDisabled = AppColorPalette.grey600;
  final Color textOnPrimary = AppColorPalette.white;
  final Color textHint = AppColorPalette.grey500;

  // ============== Border Colors ==============
  final Color border = const Color(0xFF3A3A48);
  final Color borderLight = const Color(0xFF2A2A35);
  final Color borderFocused = AppColorPalette.primaryLight;
  final Color divider = const Color(0xFF2A2A35);

  // ============== Icon Colors ==============
  final Color icon = AppColorPalette.grey300;
  final Color iconSecondary = AppColorPalette.grey500;
  final Color iconDisabled = AppColorPalette.grey600;
  final Color iconOnPrimary = AppColorPalette.white;

  // ============== Status Colors ==============
  final Color success = AppColorPalette.success;
  final Color successBackground = const Color(0xFF1B3D1F);
  final Color onSuccess = AppColorPalette.white;

  final Color warning = AppColorPalette.warning;
  final Color warningBackground = const Color(0xFF3D2514);
  final Color onWarning = AppColorPalette.white;

  final Color error = AppColorPalette.error;
  final Color errorBackground = const Color(0xFF3D1A1A);
  final Color onError = AppColorPalette.white;

  final Color info = AppColorPalette.info;
  final Color infoBackground = const Color(0xFF14293D);
  final Color onInfo = AppColorPalette.white;

  // ============== Task Status Colors ==============
  final Color statusTodo = AppColorPalette.categoryOrange;
  final Color statusTodoBackground = const Color(0xFF3D2514);
  final Color statusInProgress = AppColorPalette.primaryLight;
  final Color statusInProgressBackground = const Color(0xFF2D2647);
  final Color statusDone = AppColorPalette.categoryGreen;
  final Color statusDoneBackground = const Color(0xFF1B3D1F);

  // ============== Component Specific ==============
  final Color chipBackground = const Color(0xFF2A2A35);
  final Color chipSelectedBackground = AppColorPalette.primaryLight;
  final Color tabBackground = const Color(0xFF2A2A35);
  final Color tabSelectedBackground = AppColorPalette.primaryLight;
  final Color progressBackground = const Color(0xFF3A3A48);
  final Color progressFill = AppColorPalette.primaryLight;

  // ============== Bottom Navigation ==============
  final Color bottomNavBackground = const Color(0xFF1E1E26);
  final Color bottomNavSelected = AppColorPalette.primaryLight;
  final Color bottomNavUnselected = AppColorPalette.grey500;

  // ============== Overlay & Shadows ==============
  final Color overlay = const Color(0x99000000);
  final Color shadow = const Color(0x40000000);
  final Color shadowLight = const Color(0x20000000);

  const AppColorsDark();
}

/// Main access point for app colors.
///
/// Example usage:
/// ```dart
/// // Using context-aware colors (recommended)
/// Container(
///   color: AppColors.of(context).primary,
/// )
///
/// // Direct access to light/dark colors
/// Container(
///   color: AppColors.light.primary,
/// )
///
/// // Access raw palette colors
/// Container(
///   color: AppColorPalette.primary,
/// )
/// ```
class AppColors {
  static const AppColorsLight light = AppColorsLight();
  static const AppColorsDark dark = AppColorsDark();

  /// Get colors based on current theme brightness.
  ///
  /// Returns [AppColorsLight] for light theme, [AppColorsDark] for dark theme.
  static dynamic of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? dark : light;
  }

  /// Check if current theme is dark mode
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
