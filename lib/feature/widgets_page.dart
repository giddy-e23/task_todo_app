import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';
import 'package:task_todo_app/shared/shared.dart';
import 'package:task_todo_app/shared/widgets/badges/task_icon.dart';
import 'package:task_todo_app/shared/widgets/cards/task_group_card.dart';

class WidgetsPage extends StatelessWidget {
  const WidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          TaskOverview(),
          SizedBox(height: 20,),


          
          TaskGroup(
          iconColor: Color(0xFFF478B8),
          title: "Business",
          taskCount: 12,
          progressPercent: 0.7,
        ),


          SizedBox(height: 20,),
          TaskCard(), 
        
        
        ],
      ),
    );
  }
}


class TaskCard extends StatelessWidget {
  const TaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: Colors.white,
      ),
      
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text( "Design Team Meeting", style: AppTypography.titleMedium.copyWith(
                color: AppColors.of(context).textPrimary,
              ),),
        
              TaskIcon(groupIcon: IconsaxPlusBold.user_octagon, iconColor: Color(0xFF9260F4))
        
        
            ],),
          Row(
            children: [
              Text("Market Research", style: AppTypography.bodyMedium.copyWith(
                color: AppColors.of(context).textSecondary,
              ),)
            ],
          ),

          SizedBox(height: 4,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 4,
                children: [
                Icon(IconlyBold.time_circle, color: Color(0xFFAB94FF), size: 14,),
                Text(DateFormat('h:mm a').format(DateTime.now()), style: AppTypography.bodyMedium.copyWith(
                  color: Color(0xFFAB94FF),
                ),)
              ],),
        
              StatusBadge.done()
            ],
          )
        ],
            ),
      ),);
  }
}


class TaskOverview extends StatelessWidget {
  const TaskOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
        color: AppColors.of(context).chipSelectedBackground),
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
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.light.textOnPrimary,
              ),),
              const SizedBox(height: 8),
              AppButton.secondary(
                size: AppButtonSize.small,
                fullWidth: false,
                label: "View All Tasks", 
                onPressed: () {},
              ),
              AppButton.primary(
                label: "View All Tasks", 
                backgroundColor: AppColors.light.background,
                foregroundColor: AppColors.light.borderFocused,
              onPressed: () {}, 
              fullWidth: false, 
              size: AppButtonSize.small,)
            ],
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularPercentIndicator(
                progressColor: AppColors.of(context).textOnPrimary,
                backgroundColor: AppColors.of(context).primary.withValues(alpha: 0.1),
              radius: 38.0,
              lineWidth: 8.0,
              animation: true,
              animationDuration: 3000,
              percent: 0.85,
              circularStrokeCap: CircularStrokeCap.round,
              animateFromLastPercent: true,
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