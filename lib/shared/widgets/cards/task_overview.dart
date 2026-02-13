import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';
import 'package:task_todo_app/shared/widgets/buttons/app_button.dart';

class TaskOverview extends StatelessWidget {
  const TaskOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
        color: AppColors.of(context).chipSelectedBackground
        //color: Colors.black
        
        ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your today's task\nalmost done!", 
              softWrap: true,
              maxLines: 2,
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.light.textOnPrimary,
                
              ),),
              const SizedBox(height: 16),
             
              AppButton.primary(
                label: "View Task", 
                backgroundColor: AppColors.light.background,
                foregroundColor: AppColors.light.borderFocused,
              onPressed: () {}, 
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
              animationDuration: 3000,
              percent: 0.85,
              circularStrokeCap: CircularStrokeCap.round,
              animateFromLastPercent: false,
              reverse: true,
              center: Text(
                "${(0.85 * 100).toInt()}%",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0, color: AppColors.light.textOnPrimary),
              ),
          )],
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