import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';
import 'package:task_todo_app/shared/widgets/buttons/app_button.dart';

class TaskOverview extends StatelessWidget {
  final int completedTasks;
  final int totalTasks;
  final VoidCallback? onViewTasks;

  const TaskOverview({
    super.key,
    this.completedTasks = 0,
    this.totalTasks = 0,
    this.onViewTasks,
  });

  double get _progressPercent {
    if (totalTasks == 0) return 0.0;
    return (completedTasks / totalTasks).clamp(0.0, 1.0);
  }

  String get _statusMessage {
    if (totalTasks == 0) return "No tasks yet!\nAdd your first task";
    if (_progressPercent >= 1.0) return "Amazing work!\nAll tasks done!";
    if (_progressPercent >= 0.7) return "Your today's task\nalmost done!";
    if (_progressPercent >= 0.3) return "Keep going!\nYou're on track";
    return "Let's get started!\n$totalTasks tasks waiting";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
        color: AppColors.of(context).chipSelectedBackground,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _statusMessage, 
                softWrap: true,
                maxLines: 2,
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColors.light.textOnPrimary,
                ),
              ),
              const SizedBox(height: 16),
             
              AppButton.primary(
                label: "View Task", 
                backgroundColor: AppColors.light.background,
                foregroundColor: AppColors.light.borderFocused,
                onPressed: onViewTasks ?? () {}, 
                fullWidth: false, 
                size: AppButtonSize.small,
              )
            ],
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularPercentIndicator(
                progressColor: AppColors.of(context).textOnPrimary,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                radius: 38.0,
                lineWidth: 8.0,
                animation: true,
                animationDuration: 1500,
                percent: _progressPercent,
                circularStrokeCap: CircularStrokeCap.round,
                animateFromLastPercent: false,
                reverse: true,
                center: Text(
                  "${(_progressPercent * 100).toInt()}%",
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 14.0, 
                    color: AppColors.light.textOnPrimary,
                  ),
                ),
              ),
            ],
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(IconsaxPlusBold.more, color: AppColors.light.background,)
            ],
          )
        ],
      ),
    );
  }
}