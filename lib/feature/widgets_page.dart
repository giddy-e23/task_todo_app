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