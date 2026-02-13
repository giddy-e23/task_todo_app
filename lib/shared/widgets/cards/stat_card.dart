import 'package:flutter/material.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';

/// A small statistics card showing an icon, count, and label.
///
/// Example usage:
/// ```dart
/// StatCard(
///   icon: IconsaxPlusBold.task_square,
///   iconColor: AppColors.of(context).primary,
///   count: 12,
///   label: 'Projects',
/// )
/// ```
class StatCard extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Icon color
  final Color iconColor;

  /// Count/number to display
  final int count;

  /// Label text below the count
  final String label;

  /// Optional background color for the icon badge
  final Color? iconBackgroundColor;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.count,
    required this.label,
    this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
        children: [
          // Icon badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBackgroundColor ?? iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),

          const SizedBox(height: 12),

          // Count
          Text(
            count.toString(),
            style: AppTypography.headlineSmall.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          // Label
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
