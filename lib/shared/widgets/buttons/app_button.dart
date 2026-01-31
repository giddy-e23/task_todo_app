import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import 'slanted_stadium_border.dart';

/// Button variants available in the app
enum AppButtonVariant {
  /// Filled button with primary color background
  primary,

  /// Outlined button with border
  secondary,

  /// Text button without background
  text,
}

/// Button sizes
enum AppButtonSize { small, medium, large }

/// A customizable button widget that follows the app's design system.
///
/// Example usage:
/// ```dart
/// AppButton(
///   label: "Let's Start",
///   onPressed: () {},
///   showArrow: true,
/// )
/// ```
class AppButton extends StatelessWidget {
  /// The button label text
  final String label;

  /// Callback when the button is pressed
  final VoidCallback? onPressed;

  /// Button variant (primary, secondary, text)
  final AppButtonVariant variant;

  /// Button size
  final AppButtonSize size;

  /// Whether to show a trailing arrow icon
  final bool showArrow;

  /// Leading icon (optional)
  final IconData? leadingIcon;

  /// Trailing icon (optional, overridden by showArrow)
  final IconData? trailingIcon;

  /// Whether the button should expand to full width
  final bool fullWidth;

  /// Whether the button is in loading state
  final bool isLoading;

  /// Custom border radius
  final double? borderRadius;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.large,
    this.showArrow = false,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = true,
    this.isLoading = false,
    this.borderRadius,
  });

  /// Creates a primary filled button
  factory AppButton.primary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.large,
    bool showArrow = false,
    IconData? leadingIcon,
    bool fullWidth = true,
    bool isLoading = false,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.primary,
      size: size,
      showArrow: showArrow,
      leadingIcon: leadingIcon,
      fullWidth: fullWidth,
      isLoading: isLoading,
    );
  }

  /// Creates a secondary outlined button
  factory AppButton.secondary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.large,
    bool showArrow = false,
    IconData? leadingIcon,
    bool fullWidth = true,
    bool isLoading = false,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.secondary,
      size: size,
      showArrow: showArrow,
      leadingIcon: leadingIcon,
      fullWidth: fullWidth,
      isLoading: isLoading,
    );
  }

  /// Creates a text button
  factory AppButton.text({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool showArrow = false,
    IconData? leadingIcon,
    bool fullWidth = false,
    bool isLoading = false,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.text,
      size: size,
      showArrow: showArrow,
      leadingIcon: leadingIcon,
      fullWidth: fullWidth,
      isLoading: isLoading,
    );
  }

  double get _height {
    switch (size) {
      case AppButtonSize.small:
        return AppSizes.buttonHeightSM;
      case AppButtonSize.medium:
        return AppSizes.buttonHeightMD;
      case AppButtonSize.large:
        return AppSizes.buttonHeightLG;
    }
  }

  TextStyle get _textStyle {
    switch (size) {
      case AppButtonSize.small:
        return AppTypography.labelMedium;
      case AppButtonSize.medium:
        return AppTypography.labelLarge;
      case AppButtonSize.large:
        return AppTypography.button;
    }
  }

  double get _iconSize {
    switch (size) {
      case AppButtonSize.small:
        return AppSizes.iconXS;
      case AppButtonSize.medium:
        return AppSizes.iconSM;
      case AppButtonSize.large:
        return AppSizes.iconMD;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final effectiveRadius = borderRadius ?? AppRadius.xxl;

    Widget child = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null && !isLoading) ...[
          Icon(leadingIcon, size: _iconSize),
          SizedBox(width: AppSpacing.xs),
        ],
        if (isLoading)
          SizedBox(
            width: _iconSize,
            height: _iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == AppButtonVariant.primary
                    ? colors.onPrimary
                    : colors.primary,
              ),
            ),
          )
        else
          Text(label),
        if ((showArrow || trailingIcon != null) && !isLoading) ...[
          SizedBox(width: AppSpacing.xs),
          Icon(showArrow ? Icons.arrow_forward : trailingIcon, size: _iconSize),
        ],
      ],
    );

    // Button shape parameters
    const double tiltAmount = 0.05; // How much edges bulge outward
    const double cornerRadius = 16.0; // Slightly curved corners

    switch (variant) {
      case AppButtonVariant.primary:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          height: _height,
          child: CustomPaint(
            painter: SlantedStadiumGlowPainter(
              glowColor: colors.primary.withOpacity(0.35),
              blurRadius: 12.0,
              shadowOffset: const Offset(0, 6),
              tiltAmount: tiltAmount,
              cornerRadius: cornerRadius,
              enabled: onPressed != null,
            ),
            child: ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                textStyle: _textStyle,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                shape: const SlantedStadiumBorder(
                  tiltAmount: tiltAmount,
                  cornerRadius: cornerRadius,
                ),
              ),
              child: Center(child: child),
            ),
          ),
        );

      case AppButtonVariant.secondary:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          height: _height,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              textStyle: _textStyle,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              shape: SlantedStadiumBorder(
                tiltAmount: tiltAmount,
                cornerRadius: cornerRadius,
                side: BorderSide(color: colors.primary, width: 1.5),
              ),
            ),
            child: Center(child: child),
          ),
        );

      case AppButtonVariant.text:
        return SizedBox(
          height: _height,
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            style: TextButton.styleFrom(
              textStyle: _textStyle,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(effectiveRadius),
              ),
            ),
            child: child,
          ),
        );
    }
  }
}

/// A small icon button typically used in the app bar
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final effectiveSize = size ?? AppSizes.minTouchTarget;

    return SizedBox(
      width: effectiveSize,
      height: effectiveSize,
      child: Material(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: AppRadius.borderRadiusFull,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadius.borderRadiusFull,
          child: Center(
            child: Icon(
              icon,
              color: iconColor ?? colors.icon,
              size: AppSizes.iconMD,
            ),
          ),
        ),
      ),
    );
  }
}
