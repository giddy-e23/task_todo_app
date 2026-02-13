import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
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

  /// Custom text style for the label
  final TextStyle? textStyle;

  /// Custom button background color (for primary variant)
  final Color? backgroundColor;

  /// Custom button border/text color (for secondary/text variants)
  final Color? foregroundColor;

  /// Custom button width (overrides fullWidth when set)
  final double? width;

  /// Custom button height (overrides size-based height when set)
  final double? height;
  final double tiltAmount;
  final double cornerRadius;

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
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.tiltAmount = 0.05,
    this.cornerRadius = 8.0,
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
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? foregroundColor,
    double? width,
    double? height,
    double tiltAmount = 0.05,
    double cornerRadius = 8.0,
  }) {
    return AppButton(
      tiltAmount: tiltAmount,
      cornerRadius: cornerRadius,
      key: key,
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.primary,
      size: size,
      showArrow: showArrow,
      leadingIcon: leadingIcon,
      fullWidth: fullWidth,
      isLoading: isLoading,
      textStyle: textStyle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      width: width,
      height: height,
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
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? foregroundColor,
    double? width,
    double? height,
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
      textStyle: textStyle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      width: width,
      height: height,
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
    TextStyle? textStyle,
    Color? foregroundColor,
    double? width,
    double? height,
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
      textStyle: textStyle,
      foregroundColor: foregroundColor,
      width: width,
      height: height,
    );
  }

  double get _height {
    if (height != null) return height!;
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
    if (textStyle != null) return textStyle!;
    switch (size) {
      case AppButtonSize.small:
        return AppTypography.labelMedium;
      case AppButtonSize.medium:
        return AppTypography.labelLarge;
      case AppButtonSize.large:
        return AppTypography.button;
    }
  }

  double? get _width {
    if (width != null) return width;
    if (fullWidth) return double.infinity;
    return null;
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
    final effectiveRadius = borderRadius ?? AppRadius.xs;
    final effectiveBgColor = backgroundColor ?? colors.primary;
    final effectiveFgColor = foregroundColor ?? colors.primary;

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
                    : effectiveFgColor,
              ),
            ),
          )
        else
          Text(label),
        if ((showArrow || trailingIcon != null) && !isLoading) ...[
          SizedBox(width: AppSpacing.xs),
          Icon(showArrow ? IconlyBold.arrow_right : trailingIcon, size: _iconSize),
        ],
      ],
    );

    // // Button shape parameters
    // const double tiltAmount = 0.05; // How much edges bulge outward
    // const double cornerRadius = 8.0; // Slightly curved corners

    switch (variant) {
      case AppButtonVariant.primary:
        return SizedBox(
          width: _width,
          height: _height,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: effectiveBgColor,
              foregroundColor: foregroundColor ?? colors.onPrimary,
              textStyle: _textStyle,
              minimumSize: fullWidth ? null : Size.zero,
              tapTargetSize: fullWidth ? null : MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              shape:  SlantedStadiumBorder(
                tiltAmount:tiltAmount,
                cornerRadius: cornerRadius,
              ),
            ),
            child: Center(child: child),
          ),
        );

      case AppButtonVariant.secondary:
        return SizedBox(
          width: _width,
          height: _height,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: effectiveFgColor,
              textStyle: _textStyle,
              minimumSize: fullWidth ? null : Size.zero,
              tapTargetSize: fullWidth ? null : MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              shape: SlantedStadiumBorder(
                tiltAmount: tiltAmount,
                cornerRadius: cornerRadius,
                side: BorderSide(color: effectiveFgColor, width: 1.5),
              ),
            ),
            child: Center(child: child),
          ),
        );

      case AppButtonVariant.text:
        return SizedBox(
          width: _width,
          height: _height,
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            style: TextButton.styleFrom(
              foregroundColor: effectiveFgColor,
              textStyle: _textStyle,
              minimumSize: fullWidth ? null : Size.zero,
              tapTargetSize: fullWidth ? null : MaterialTapTargetSize.shrinkWrap,
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
