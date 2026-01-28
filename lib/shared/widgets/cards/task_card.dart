import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../badges/status_badge.dart';
import '../progress/circular_progress.dart';

/// A task card widget displaying task information.
///
/// Example usage:
/// ```dart
/// TaskCard(
///   category: 'Grocery shopping app design',
///   title: 'Market Research',
///   time: '10:00 AM',
///   status: TaskStatus.done,
///   onTap: () {},
/// )
/// ```
class TaskCard extends StatelessWidget {
  /// Task category/project name
  final String category;

  /// Task title
  final String title;

  /// Time string (e.g., "10:00 AM")
  final String? time;

  /// Task status
  final TaskStatus status;

  /// Category color
  final Color? categoryColor;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Trailing widget (defaults to colored dot)
  final Widget? trailing;

  const TaskCard({
    super.key,
    required this.category,
    required this.title,
    this.time,
    required this.status,
    this.categoryColor,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Material(
      color: colors.cardBackground,
      borderRadius: AppRadius.borderRadiusMD,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderRadiusMD,
        child: Container(
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            borderRadius: AppRadius.borderRadiusMD,
            boxShadow: AppShadows.elevationLight1,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    Text(
                      category,
                      style: AppTypography.categoryLabel.copyWith(
                        color: colors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.gapVerticalXS,
                    // Title
                    Text(
                      title,
                      style: AppTypography.taskTitle.copyWith(
                        color: colors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.gapVerticalSM,
                    // Time and Status
                    Row(
                      children: [
                        if (time != null) ...[
                          Icon(
                            Icons.access_time,
                            size: AppSizes.iconXS,
                            color: colors.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            time!,
                            style: AppTypography.timestamp.copyWith(
                              color: colors.textTertiary,
                            ),
                          ),
                          const Spacer(),
                        ],
                        StatusBadge(status: status),
                      ],
                    ),
                  ],
                ),
              ),
              // Trailing dot
              if (trailing != null) ...[
                AppSpacing.gapHorizontalSM,
                trailing!,
              ] else ...[
                AppSpacing.gapHorizontalSM,
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: categoryColor ?? colors.statusInProgressBackground,
                    borderRadius: AppRadius.borderRadiusSM,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A task group card showing project info with progress.
///
/// Example usage:
/// ```dart
/// TaskGroupCard(
///   icon: Icons.work,
///   iconColor: AppColorPalette.categoryOrange,
///   title: 'Office Project',
///   taskCount: 23,
///   progress: 0.70,
///   onTap: () {},
/// )
/// ```
class TaskGroupCard extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Icon background color
  final Color iconColor;

  /// Group/Project title
  final String title;

  /// Number of tasks
  final int taskCount;

  /// Progress value (0.0 - 1.0)
  final double progress;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  const TaskGroupCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.taskCount,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Material(
      color: colors.cardBackground,
      borderRadius: AppRadius.borderRadiusMD,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderRadiusMD,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: AppRadius.borderRadiusMD,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: AppSizes.iconMD,
                ),
              ),
              AppSpacing.gapHorizontalMD,
              // Title and count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleMedium.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '$taskCount Tasks',
                      style: AppTypography.taskCount.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              // Progress
              MiniProgressIndicator(
                progress: progress,
                size: 44,
                color: iconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A compact task card for "In Progress" section
class InProgressCard extends StatelessWidget {
  /// Project name
  final String projectName;

  /// Task title
  final String title;

  /// Card background color
  final Color? backgroundColor;

  /// Text color
  final Color? textColor;

  /// Callback when tapped
  final VoidCallback? onTap;

  const InProgressCard({
    super.key,
    required this.projectName,
    required this.title,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final effectiveBackground = backgroundColor ?? colors.cardBackground;
    final effectiveTextColor = textColor ?? colors.textPrimary;

    return Material(
      color: effectiveBackground,
      borderRadius: AppRadius.borderRadiusMD,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderRadiusMD,
        child: Container(
          width: 160,
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                projectName,
                style: AppTypography.categoryLabel.copyWith(
                  color: effectiveTextColor.withOpacity(0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              AppSpacing.gapVerticalXS,
              Text(
                title,
                style: AppTypography.titleSmall.copyWith(
                  color: effectiveTextColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
