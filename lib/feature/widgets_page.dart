import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:task_todo_app/shared/widgets/cards/task_card.dart';
import 'package:task_todo_app/shared/widgets/cards/task_group_card.dart';
import 'package:task_todo_app/shared/widgets/cards/task_overview.dart';
import 'package:task_todo_app/shared/widgets/cards/task_progress_card.dart';

class WidgetsPage extends StatelessWidget {
  const WidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TaskOverview(),
          SizedBox(height: 20),
      
          // Task Progress Cards row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TaskProgressCard(
                backgroundColor: Color(0xFFE3F2FD),
                iconColor: Color(0xFFF478B8),
                icon: IconsaxPlusBold.briefcase,
                category: "Office Project",
                title: "Grocery shopping app design",
                progressPercent: 0.65,
                progressColor: Color(0xFF2196F3),
              ),
              SizedBox(width: 16),
             
            ],
          ),
          SizedBox(height: 20),
      
          TaskGroup(
            iconColor: Color(0xFFF478B8),
            title: "Business",
            taskCount: 12,
            progressPercent: 0.7,
          ),
      
          SizedBox(height: 20),
          //TaskCard(),
        ],
      ),
    );
  }
}
