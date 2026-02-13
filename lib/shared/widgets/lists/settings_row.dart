import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';

/// A settings menu row with icon, label, optional value, and chevron.
///
/// Example usage:
/// ```dart
/// SettingsRow(
///   icon: IconsaxPlusLinear.user,
///   label: 'Account Settings',
///   onTap: () {},
/// )
/// ```
class SettingsRow extends StatelessWidget {
  /// Leading icon
  final IconData icon;

  /// Row label text
  final String label;

  /// Optional value text shown on the right
  final String? value;

  /// Callback when row is tapped
  final VoidCallback? onTap;

  /// Whether to show the chevron arrow
  final bool showChevron;

  /// Whether this is a destructive action (e.g., logout)
  final bool isDestructive;

  /// Optional icon color override
  final Color? iconColor;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
    this.showChevron = true,
    this.isDestructive = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final effectiveIconColor =
        iconColor ?? (isDestructive ? colors.error : colors.textPrimary);
    final effectiveLabelColor =
        isDestructive ? colors.error : colors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          child: Row(
            children: [
              // Icon badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDestructive
                      ? colors.errorBackground
                      : colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: effectiveIconColor,
                  size: 22,
                ),
              ),

              const SizedBox(width: 14),

              // Label
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.titleMedium.copyWith(
                    color: effectiveLabelColor,
                  ),
                ),
              ),

              // Value (if provided)
              if (value != null) ...[
                Text(
                  value!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
              ],

              // Chevron
              if (showChevron)
                Icon(
                  IconsaxPlusLinear.arrow_right_3,
                  color: colors.textTertiary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A group of settings rows with an optional title header.
///
/// Example usage:
/// ```dart
/// SettingsGroup(
///   title: 'General',
///   children: [
///     SettingsRow(icon: Icons.person, label: 'Profile'),
///     SettingsRow(icon: Icons.notifications, label: 'Notifications'),
///   ],
/// )
/// ```
class SettingsGroup extends StatelessWidget {
  /// Optional group title
  final String? title;

  /// List of settings rows
  final List<Widget> children;

  const SettingsGroup({
    super.key,
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: AppTypography.labelMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ],
    );
  }
}
