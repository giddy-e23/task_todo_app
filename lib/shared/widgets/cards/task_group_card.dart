import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';
import 'package:task_todo_app/shared/widgets/badges/task_icon.dart';

class TaskGroup extends StatelessWidget {
  final Color iconColor;
  final String title;
  final int taskCount;
  final double progressPercent;
  final IconData? groupIcon;
  final Color? progressColor;

  
  const TaskGroup({
    super.key,
    required this.iconColor,
    required this.title,
    required this.taskCount,
    required this.progressPercent,
    this.groupIcon,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 12,
              children: [
                TaskIcon(groupIcon: groupIcon, iconColor: iconColor),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleMedium.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w400
                    ),
                    ),
                    Text(
                      taskCount == 1 ? "$taskCount Task" : "$taskCount Tasks",
                      style: AppTypography.bodySmall.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                    ),
                  ],
                ),
              ],
            ),

            CircularPercentIndicator(
              radius: 24.0,
              lineWidth: 5.0,
              animation: true,
              animationDuration: 3000,
              percent: progressPercent,
              animateFromLastPercent: true,
              center: Text(
                "${(progressPercent * 100).toInt()}%",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0, color: AppColors.of(context).textPrimary),
              ),

              circularStrokeCap: CircularStrokeCap.round,
              progressColor: progressColor ?? iconColor,
            ),
          ],
        ),
      ),
    );
  }
}


