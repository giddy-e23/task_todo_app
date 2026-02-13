import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';
import 'package:task_todo_app/shared/custom_app_background.dart';
import 'package:task_todo_app/shared/widgets/cards/task_group_card.dart';
import 'package:task_todo_app/shared/widgets/cards/task_overview.dart';
import 'package:task_todo_app/shared/widgets/cards/task_progress_card.dart';
import 'package:task_todo_app/shared/widgets/app_section_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: CustomAppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Header Section
                _buildHeader(colors),

                const SizedBox(height: 24),

                // Task Overview Card
                const TaskOverview(),

                const SizedBox(height: 28),

                // In Progress Section
                AppSectionBar(
                  title: 'In Progress',
                  count: 6,
                ),

                const SizedBox(height: 16),

                // Horizontal scrolling task progress cards
                SizedBox(
                  height: 180,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    children: [
                      TaskProgressCard(
                        backgroundColor: const Color(0xFFE8F4FD),
                        iconColor: const Color(0xFFF478B8),
                        icon: IconsaxPlusBold.briefcase,
                        category: "Office Project",
                        title: "Grocery shopping app design",
                        progressPercent: 0.65,
                        progressColor: const Color(0xFF2196F3),
                      ),
                      const SizedBox(width: 16),
                      TaskProgressCard(
                        backgroundColor: const Color(0xFFFFEBE5),
                        iconColor: const Color(0xFFFF7D53),
                        icon: IconsaxPlusBold.user,
                        category: "Personal Project",
                        title: "Uber Eats redesign challenge",
                        progressPercent: 0.85,
                        progressColor: const Color(0xFFFF7D53),
                      ),
                      const SizedBox(width: 16),
                      TaskProgressCard(
                        backgroundColor: const Color(0xFFE8F9EE),
                        iconColor: const Color(0xFF0ECC5A),
                        icon: IconsaxPlusBold.book_1,
                        category: "Daily Study",
                        title: "Flutter advanced concepts",
                        progressPercent: 0.45,
                        progressColor: const Color(0xFF0ECC5A),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Task Groups Section
                AppSectionBar(
                  title: 'Task Groups',
                  count: 4,
                ),

                const SizedBox(height: 16),

                // Task Group List
                TaskGroup(
                  iconColor: const Color(0xFFF478B8),
                  groupIcon: IconsaxPlusBold.briefcase,
                  title: "Office Project",
                  taskCount: 23,
                  progressPercent: 0.70,
                  progressColor: const Color(0xFFF478B8),
                ),

                const SizedBox(height: 12),

                TaskGroup(
                  iconColor: const Color(0xFF9260F4),
                  groupIcon: IconsaxPlusBold.user,
                  title: "Personal Project",
                  taskCount: 30,
                  progressPercent: 0.52,
                  progressColor: const Color(0xFF9260F4),
                ),

                const SizedBox(height: 12),

                TaskGroup(
                  iconColor: const Color(0xFFFF7D53),
                  groupIcon: IconsaxPlusBold.book_1,
                  title: "Daily Study",
                  taskCount: 30,
                  progressPercent: 0.87,
                  progressColor: const Color(0xFFFF7D53),
                ),

                // Add padding at bottom for nav bar
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppColorsLight colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundImage: const NetworkImage(
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
              ),
              backgroundColor: colors.surfaceVariant,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello!',
                  style: AppTypography.bodyMedium.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                Text(
                  'Livia Vaccaro',
                  style: AppTypography.titleLarge.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
        // Notification Bell
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            IconsaxPlusBold.notification,
            color: colors.textPrimary,
            size: 22,
          ),
        ),
      ],
    );
  }
}