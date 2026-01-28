import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

/// Custom app text field with app styling.
///
/// Example usage:
/// ```dart
/// AppTextField(
///   label: 'Project Name',
///   hint: 'Enter project name',
///   controller: controller,
/// )
/// ```
class AppTextField extends StatelessWidget {
  /// Field label shown above the input
  final String? label;

  /// Hint text inside the input
  final String? hint;

  /// Text editing controller
  final TextEditingController? controller;

  /// Whether the field is read-only
  final bool readOnly;

  /// Whether to obscure text (for passwords)
  final bool obscureText;

  /// Input type
  final TextInputType? keyboardType;

  /// Maximum lines for multiline input
  final int maxLines;

  /// Minimum lines
  final int? minLines;

  /// Prefix icon
  final IconData? prefixIcon;

  /// Suffix icon
  final IconData? suffixIcon;

  /// Callback when suffix icon is tapped
  final VoidCallback? onSuffixTap;

  /// Validation function
  final String? Function(String?)? validator;

  /// Callback when value changes
  final ValueChanged<String>? onChanged;

  /// Callback when field is tapped
  final VoidCallback? onTap;

  /// Focus node
  final FocusNode? focusNode;

  /// Error text to display
  final String? errorText;

  /// Whether the field is enabled
  final bool enabled;

  /// Background color override
  final Color? backgroundColor;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.validator,
    this.onChanged,
    this.onTap,
    this.focusNode,
    this.errorText,
    this.enabled = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.labelMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
          AppSpacing.gapVerticalXS,
        ],
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          minLines: minLines,
          validator: validator,
          onChanged: onChanged,
          onTap: onTap,
          focusNode: focusNode,
          enabled: enabled,
          style: AppTypography.bodyLarge.copyWith(color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            filled: true,
            fillColor: backgroundColor ?? colors.surfaceVariant,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: AppSizes.iconMD)
                : null,
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixTap,
                    child: Icon(suffixIcon, size: AppSizes.iconMD),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

/// A dropdown field with app styling.
///
/// Example usage:
/// ```dart
/// AppDropdownField<String>(
///   label: 'Task Group',
///   value: 'Work',
///   items: [
///     DropdownMenuItem(value: 'Work', child: Text('Work')),
///     DropdownMenuItem(value: 'Personal', child: Text('Personal')),
///   ],
///   onChanged: (value) {},
/// )
/// ```
class AppDropdownField<T> extends StatelessWidget {
  /// Field label
  final String? label;

  /// Hint text
  final String? hint;

  /// Current value
  final T? value;

  /// Dropdown items
  final List<DropdownMenuItem<T>> items;

  /// Callback when value changes
  final ValueChanged<T?>? onChanged;

  /// Prefix icon
  final Widget? prefix;

  /// Whether the field is enabled
  final bool enabled;

  const AppDropdownField({
    super.key,
    this.label,
    this.hint,
    this.value,
    required this.items,
    this.onChanged,
    this.prefix,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.labelMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
          AppSpacing.gapVerticalXS,
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.surfaceVariant,
            borderRadius: AppRadius.borderRadiusMD,
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              if (prefix != null) ...[prefix!, AppSpacing.gapHorizontalSM],
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: value,
                    hint: hint != null
                        ? Text(
                            hint!,
                            style: AppTypography.bodyMedium.copyWith(
                              color: colors.textHint,
                            ),
                          )
                        : null,
                    items: items,
                    onChanged: enabled ? onChanged : null,
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: colors.primary,
                    ),
                    style: AppTypography.bodyLarge.copyWith(
                      color: colors.textPrimary,
                    ),
                    dropdownColor: colors.surface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A date picker field with app styling.
class AppDateField extends StatelessWidget {
  /// Field label
  final String? label;

  /// Hint text
  final String? hint;

  /// Currently selected date
  final DateTime? value;

  /// Callback when date is selected
  final ValueChanged<DateTime>? onDateSelected;

  /// Date format display
  final String Function(DateTime)? dateFormat;

  /// First selectable date
  final DateTime? firstDate;

  /// Last selectable date
  final DateTime? lastDate;

  const AppDateField({
    super.key,
    this.label,
    this.hint,
    this.value,
    this.onDateSelected,
    this.dateFormat,
    this.firstDate,
    this.lastDate,
  });

  String _formatDate(DateTime date) {
    if (dateFormat != null) return dateFormat!(date);
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.labelMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
          AppSpacing.gapVerticalXS,
        ],
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: firstDate ?? DateTime(2020),
              lastDate: lastDate ?? DateTime(2100),
            );
            if (date != null) {
              onDateSelected?.call(date);
            }
          },
          borderRadius: AppRadius.borderRadiusMD,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: AppRadius.borderRadiusMD,
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: AppSizes.iconMD,
                  color: colors.primary,
                ),
                AppSpacing.gapHorizontalSM,
                Expanded(
                  child: Text(
                    value != null
                        ? _formatDate(value!)
                        : (hint ?? 'Select date'),
                    style: AppTypography.bodyLarge.copyWith(
                      color: value != null
                          ? colors.textPrimary
                          : colors.textHint,
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: colors.primary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
