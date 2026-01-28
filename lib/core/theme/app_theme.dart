import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// Main theme configuration for the Task Todo App.
///
/// Based on Figma design: Task Management & To-do List App
/// https://www.figma.com/design/U7sk8wkrbitinE9yzX77KX
///
/// Usage in main.dart:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.lightTheme,
///   darkTheme: AppTheme.darkTheme,
///   themeMode: ThemeMode.system,
/// )
/// ```
class AppTheme {
  AppTheme._();

  // ============================================================
  // LIGHT THEME
  // ============================================================
  static ThemeData get lightTheme {
    const colors = AppColorsLight();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        primaryContainer: colors.primaryContainer,
        onPrimary: colors.onPrimary,
        onPrimaryContainer: colors.onPrimaryContainer,
        secondary: colors.secondary,
        secondaryContainer: colors.secondaryContainer,
        onSecondary: colors.onSecondary,
        onSecondaryContainer: colors.onSecondaryContainer,
        tertiary: colors.accent,
        tertiaryContainer: colors.accentContainer,
        onTertiary: colors.onAccent,
        surface: colors.surface,
        onSurface: colors.textPrimary,
        surfaceContainerHighest: colors.surfaceVariant,
        error: colors.error,
        onError: colors.onError,
        outline: colors.border,
        outlineVariant: colors.borderLight,
        shadow: colors.shadow,
      ),

      // Scaffold
      scaffoldBackgroundColor: colors.scaffoldBackground,

      // Typography
      fontFamily: AppTypography.fontFamily,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: colors.textPrimary,
        displayColor: colors.textPrimary,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: colors.scaffoldBackground,
        foregroundColor: colors.textPrimary,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: colors.textPrimary,
        ),
        iconTheme: IconThemeData(color: colors.icon, size: AppSizes.iconMD),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          disabledBackgroundColor: colors.border,
          disabledForegroundColor: colors.textDisabled,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeightLG),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMD),
          textStyle: AppTypography.button,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: colors.primary,
          disabledForegroundColor: colors.textDisabled,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeightLG),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMD),
          side: BorderSide(color: colors.primary, width: 1.5),
          textStyle: AppTypography.button,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          disabledForegroundColor: colors.textDisabled,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusSM),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMD,
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMD,
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMD,
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMD,
          borderSide: BorderSide(color: colors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMD,
          borderSide: BorderSide(color: colors.error, width: 2),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(color: colors.textHint),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: colors.textSecondary,
        ),
        errorStyle: AppTypography.bodySmall.copyWith(color: colors.error),
        prefixIconColor: colors.iconSecondary,
        suffixIconColor: colors.iconSecondary,
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: 0,
        color: colors.cardBackground,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMD),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: AppSizes.dividerThickness,
        space: AppSizes.dividerThickness,
      ),

      // Icon
      iconTheme: IconThemeData(color: colors.icon, size: AppSizes.iconMD),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.bottomNavBackground,
        selectedItemColor: colors.bottomNavSelected,
        unselectedItemColor: colors.bottomNavUnselected,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: AppTypography.labelSmall,
        unselectedLabelStyle: AppTypography.labelSmall,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),

      // Navigation Bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.bottomNavBackground,
        indicatorColor: colors.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colors.primary, size: AppSizes.iconMD);
          }
          return IconThemeData(
            color: colors.bottomNavUnselected,
            size: AppSizes.iconMD,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelSmall.copyWith(color: colors.primary);
          }
          return AppTypography.labelSmall.copyWith(
            color: colors.bottomNavUnselected,
          );
        }),
        height: AppSizes.bottomNavHeight,
        elevation: 0,
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        highlightElevation: 0,
        shape: const CircleBorder(),
        sizeConstraints: const BoxConstraints.tightFor(
          width: AppSizes.fabSize,
          height: AppSizes.fabSize,
        ),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(colors.onPrimary),
        side: BorderSide(color: colors.border, width: 2),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusXS),
      ),

      // Radio
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return colors.border;
        }),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return colors.iconSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primaryContainer;
          }
          return colors.surfaceVariant;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: colors.chipBackground,
        selectedColor: colors.chipSelectedBackground,
        disabledColor: colors.chipBackground,
        labelStyle: AppTypography.labelMedium.copyWith(
          color: colors.textSecondary,
        ),
        secondaryLabelStyle: AppTypography.labelMedium.copyWith(
          color: colors.onPrimary,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusFull),
        side: BorderSide.none,
      ),

      // Tab Bar
      tabBarTheme: TabBarThemeData(
        indicator: BoxDecoration(
          color: colors.tabSelectedBackground,
          borderRadius: AppRadius.borderRadiusFull,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: colors.onPrimary,
        unselectedLabelColor: colors.textSecondary,
        labelStyle: AppTypography.labelMedium,
        unselectedLabelStyle: AppTypography.labelMedium,
        dividerColor: Colors.transparent,
      ),

      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: colors.surface,
        modalBarrierColor: colors.overlay,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxxl),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: colors.border,
        dragHandleSize: const Size(40, 4),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusXL),
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: colors.textPrimary,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: colors.textSecondary,
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.textPrimary,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: colors.surface,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMD),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      // Progress Indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        linearTrackColor: colors.progressBackground,
        circularTrackColor: colors.progressBackground,
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMD),
        titleTextStyle: AppTypography.titleMedium.copyWith(
          color: colors.textPrimary,
        ),
        subtitleTextStyle: AppTypography.bodySmall.copyWith(
          color: colors.textSecondary,
        ),
        iconColor: colors.icon,
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: colors.primary,
        inactiveTrackColor: colors.progressBackground,
        thumbColor: colors.primary,
        overlayColor: colors.primary.withOpacity(0.12),
      ),

      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colors.textPrimary,
          borderRadius: AppRadius.borderRadiusSM,
        ),
        textStyle: AppTypography.bodySmall.copyWith(color: colors.surface),
      ),

      // Date Picker
      datePickerTheme: DatePickerThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: colors.primary,
        headerForegroundColor: colors.onPrimary,
        dayStyle: AppTypography.bodyMedium,
        weekdayStyle: AppTypography.labelSmall.copyWith(
          color: colors.textSecondary,
        ),
        todayBackgroundColor: WidgetStateProperty.all(colors.primaryContainer),
        todayForegroundColor: WidgetStateProperty.all(colors.primary),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return Colors.transparent;
        }),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.onPrimary;
          }
          return colors.textPrimary;
        }),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusLG),
      ),

      // Time Picker
      timePickerTheme: TimePickerThemeData(
        backgroundColor: colors.surface,
        hourMinuteColor: colors.surfaceVariant,
        hourMinuteTextColor: colors.textPrimary,
        dayPeriodColor: colors.surfaceVariant,
        dayPeriodTextColor: colors.textPrimary,
        dialBackgroundColor: colors.surfaceVariant,
        dialHandColor: colors.primary,
        dialTextColor: colors.textPrimary,
        entryModeIconColor: colors.icon,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusLG),
      ),

      // Page Transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),

      // Visual Density
      visualDensity: VisualDensity.standard,

      // Splash
      splashColor: colors.primary.withOpacity(0.08),
      highlightColor: colors.primary.withOpacity(0.04),
      splashFactory: InkRipple.splashFactory,
    );
  }

  // ============================================================
  // DARK THEME
  // ============================================================
  static ThemeData get darkTheme {
    const colors = AppColorsDark();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: ColorScheme.dark(
        primary: colors.primary,
        primaryContainer: colors.primaryContainer,
        onPrimary: colors.onPrimary,
        onPrimaryContainer: colors.onPrimaryContainer,
        secondary: colors.secondary,
        secondaryContainer: colors.secondaryContainer,
        onSecondary: colors.onSecondary,
        onSecondaryContainer: colors.onSecondaryContainer,
        tertiary: colors.accent,
        tertiaryContainer: colors.accentContainer,
        onTertiary: colors.onAccent,
        surface: colors.surface,
        onSurface: colors.textPrimary,
        surfaceContainerHighest: colors.surfaceVariant,
        error: colors.error,
        onError: colors.onError,
        outline: colors.border,
        outlineVariant: colors.borderLight,
        shadow: colors.shadow,
      ),

      // Scaffold
      scaffoldBackgroundColor: colors.scaffoldBackground,

      // Typography
      fontFamily: AppTypography.fontFamily,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: colors.textPrimary,
        displayColor: colors.textPrimary,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: colors.scaffoldBackground,
        foregroundColor: colors.textPrimary,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: colors.textPrimary,
        ),
        iconTheme: IconThemeData(color: colors.icon, size: AppSizes.iconMD),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          disabledBackgroundColor: colors.border,
          disabledForegroundColor: colors.textDisabled,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeightLG),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMD),
          textStyle: AppTypography.button,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: colors.primary,
          disabledForegroundColor: colors.textDisabled,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeightLG),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMD),
          side: BorderSide(color: colors.primary, width: 1.5),
          textStyle: AppTypography.button,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          disabledForegroundColor: colors.textDisabled,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusSM),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMD,
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMD,
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMD,
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMD,
          borderSide: BorderSide(color: colors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMD,
          borderSide: BorderSide(color: colors.error, width: 2),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(color: colors.textHint),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: colors.textSecondary,
        ),
        errorStyle: AppTypography.bodySmall.copyWith(color: colors.error),
        prefixIconColor: colors.iconSecondary,
        suffixIconColor: colors.iconSecondary,
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: 0,
        color: colors.cardBackground,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMD),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: AppSizes.dividerThickness,
        space: AppSizes.dividerThickness,
      ),

      // Icon
      iconTheme: IconThemeData(color: colors.icon, size: AppSizes.iconMD),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.bottomNavBackground,
        selectedItemColor: colors.bottomNavSelected,
        unselectedItemColor: colors.bottomNavUnselected,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: AppTypography.labelSmall,
        unselectedLabelStyle: AppTypography.labelSmall,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),

      // Navigation Bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.bottomNavBackground,
        indicatorColor: colors.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colors.primary, size: AppSizes.iconMD);
          }
          return IconThemeData(
            color: colors.bottomNavUnselected,
            size: AppSizes.iconMD,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelSmall.copyWith(color: colors.primary);
          }
          return AppTypography.labelSmall.copyWith(
            color: colors.bottomNavUnselected,
          );
        }),
        height: AppSizes.bottomNavHeight,
        elevation: 0,
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        highlightElevation: 0,
        shape: const CircleBorder(),
        sizeConstraints: const BoxConstraints.tightFor(
          width: AppSizes.fabSize,
          height: AppSizes.fabSize,
        ),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(colors.onPrimary),
        side: BorderSide(color: colors.border, width: 2),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusXS),
      ),

      // Radio
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return colors.border;
        }),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return colors.iconSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primaryContainer;
          }
          return colors.surfaceVariant;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: colors.chipBackground,
        selectedColor: colors.chipSelectedBackground,
        disabledColor: colors.chipBackground,
        labelStyle: AppTypography.labelMedium.copyWith(
          color: colors.textSecondary,
        ),
        secondaryLabelStyle: AppTypography.labelMedium.copyWith(
          color: colors.onPrimary,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusFull),
        side: BorderSide.none,
      ),

      // Tab Bar
      tabBarTheme: TabBarThemeData(
        indicator: BoxDecoration(
          color: colors.tabSelectedBackground,
          borderRadius: AppRadius.borderRadiusFull,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: colors.onPrimary,
        unselectedLabelColor: colors.textSecondary,
        labelStyle: AppTypography.labelMedium,
        unselectedLabelStyle: AppTypography.labelMedium,
        dividerColor: Colors.transparent,
      ),

      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: colors.surface,
        modalBarrierColor: colors.overlay,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxxl),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: colors.border,
        dragHandleSize: const Size(40, 4),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusXL),
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: colors.textPrimary,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: colors.textSecondary,
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.surface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: colors.textPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMD),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      // Progress Indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        linearTrackColor: colors.progressBackground,
        circularTrackColor: colors.progressBackground,
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMD),
        titleTextStyle: AppTypography.titleMedium.copyWith(
          color: colors.textPrimary,
        ),
        subtitleTextStyle: AppTypography.bodySmall.copyWith(
          color: colors.textSecondary,
        ),
        iconColor: colors.icon,
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: colors.primary,
        inactiveTrackColor: colors.progressBackground,
        thumbColor: colors.primary,
        overlayColor: colors.primary.withOpacity(0.12),
      ),

      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: AppRadius.borderRadiusSM,
        ),
        textStyle: AppTypography.bodySmall.copyWith(color: colors.textPrimary),
      ),

      // Date Picker
      datePickerTheme: DatePickerThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: colors.primary,
        headerForegroundColor: colors.onPrimary,
        dayStyle: AppTypography.bodyMedium,
        weekdayStyle: AppTypography.labelSmall.copyWith(
          color: colors.textSecondary,
        ),
        todayBackgroundColor: WidgetStateProperty.all(colors.primaryContainer),
        todayForegroundColor: WidgetStateProperty.all(colors.primary),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return Colors.transparent;
        }),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.onPrimary;
          }
          return colors.textPrimary;
        }),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusLG),
      ),

      // Time Picker
      timePickerTheme: TimePickerThemeData(
        backgroundColor: colors.surface,
        hourMinuteColor: colors.surfaceVariant,
        hourMinuteTextColor: colors.textPrimary,
        dayPeriodColor: colors.surfaceVariant,
        dayPeriodTextColor: colors.textPrimary,
        dialBackgroundColor: colors.surfaceVariant,
        dialHandColor: colors.primary,
        dialTextColor: colors.textPrimary,
        entryModeIconColor: colors.icon,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusLG),
      ),

      // Page Transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),

      // Visual Density
      visualDensity: VisualDensity.standard,

      // Splash
      splashColor: colors.primary.withOpacity(0.12),
      highlightColor: colors.primary.withOpacity(0.08),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
