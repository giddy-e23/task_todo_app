import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';
import 'package:task_todo_app/shared/custom_app_background.dart';
import 'package:task_todo_app/shared/widgets/badges/status_badge.dart';
import 'package:task_todo_app/shared/widgets/buttons/app_button.dart';
import 'package:task_todo_app/shared/widgets/buttons/filter_tab_bar.dart';
import 'package:task_todo_app/shared/widgets/calendar/calendar_strip.dart';
import 'package:task_todo_app/shared/widgets/cards/task_card.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  DateTime _selectedDate = DateTime.now();
  int _selectedFilterIndex = 0;

  final List<String> _filterTabs = ['All', 'To do', 'In Progress', 'Completed'];

  // Sample task data
  final List<Map<String, dynamic>> _tasks = [
    {
      'projectName': 'Grocery shopping app design',
      'taskTitle': 'Market Research',
      'time': DateTime.now().copyWith(hour: 10, minute: 0),
      'status': TaskStatus.done,
      'icon': IconsaxPlusBold.briefcase,
      'iconColor': const Color(0xFFF478B8),
    },
    {
      'projectName': 'Grocery shopping app design',
      'taskTitle': 'Competitive Analysis',
      'time': DateTime.now().copyWith(hour: 12, minute: 0),
      'status': TaskStatus.inProgress,
      'icon': IconsaxPlusBold.briefcase,
      'iconColor': const Color(0xFFF478B8),
    },
    {
      'projectName': 'Uber Eats redesign challenge',
      'taskTitle': 'Create Low-fidelity Wireframe',
      'time': DateTime.now().copyWith(hour: 19, minute: 0),
      'status': TaskStatus.todo,
      'icon': IconsaxPlusBold.user,
      'iconColor': const Color(0xFF9260F4),
    },
    {
      'projectName': 'About design sprint',
      'taskTitle': 'How to pitch a Design Sprint',
      'time': DateTime.now().copyWith(hour: 21, minute: 0),
      'status': TaskStatus.todo,
      'icon': IconsaxPlusBold.book_1,
      'iconColor': const Color(0xFFFF7D53),
    },
  ];

  List<Map<String, dynamic>> get _filteredTasks {
    if (_selectedFilterIndex == 0) return _tasks;

    TaskStatus? filterStatus;
    switch (_selectedFilterIndex) {
      case 1:
        filterStatus = TaskStatus.todo;
        break;
      case 2:
        filterStatus = TaskStatus.inProgress;
        break;
      case 3:
        filterStatus = TaskStatus.done;
        break;
    }

    return _tasks.where((task) => task['status'] == filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: CustomAppBackground(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildHeader(colors),
              ),

              const SizedBox(height: 24),

              // Calendar Strip
              CalendarStrip(
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() => _selectedDate = date);
                },
              ),

              const SizedBox(height: 24),

              // Filter Tabs
              FilterTabBar(
                tabs: _filterTabs,
                selectedIndex: _selectedFilterIndex,
                onTabSelected: (index) {
                  setState(() => _selectedFilterIndex = index);
                },
              ),

              // const SizedBox(height: 24),
              

              // Task List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredTasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final task = _filteredTasks[index];
                    return TaskCard(
                      projectName: task['projectName'],
                      taskTitle: task['taskTitle'],
                      time: task['time'],
                      status: task['status'],
                      icon: task['icon'],
                      iconColor: task['iconColor'],
                    );
                  },
                ),
              ),

              // Bottom padding for nav bar
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppColorsLight colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button
        GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              IconsaxPlusLinear.arrow_left,
              color: colors.textPrimary,
              size: 24,
            ),
          ),
        ),

        // Title
        Text(
          "Today's Tasks",
          style: AppTypography.headlineSmall.copyWith(
            color: colors.textPrimary,
          ),
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
          child: Stack(
            children: [
              Icon(
                IconsaxPlusBold.notification,
                color: colors.textPrimary,
                size: 22,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
