import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';
import 'package:task_todo_app/shared/widgets/badges/status_badge.dart';
import 'package:task_todo_app/shared/widgets/badges/task_icon.dart';

class TaskCard extends StatelessWidget {
  final String projectName;
  final String taskTitle;
  final DateTime time;
  final TaskStatus status;
  final IconData? icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.projectName,
    required this.taskTitle,
    required this.time,
    required this.status,
    this.icon,
    this.iconColor = const Color(0xFF9260F4),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          color: colors.surface,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      projectName,
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                  TaskIcon(
                    groupIcon: icon ?? IconsaxPlusBold.briefcase,
                    iconColor: iconColor,
                  ),
                ],
              ),
              Text(
                taskTitle,
                style: AppTypography.bodyMediumLight.copyWith(
                  color: colors.textPrimary,
                  
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        IconlyBold.time_circle,
                        color: const Color(0xFFAB94FF),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('h:mm a').format(time),
                        style: AppTypography.bodyMedium.copyWith(
                          color: const Color(0xFFAB94FF),
                        ),
                      ),
                    ],
                  ),
                  StatusBadge(status: status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}