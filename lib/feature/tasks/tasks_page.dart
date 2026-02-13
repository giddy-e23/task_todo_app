import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:task_todo_app/core/database/database.dart';
import 'package:task_todo_app/core/di/injection.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';
import 'package:task_todo_app/shared/custom_app_background.dart';
import 'package:task_todo_app/shared/widgets/badges/status_badge.dart';
import 'package:task_todo_app/shared/widgets/buttons/filter_tab_bar.dart';
import 'package:task_todo_app/shared/widgets/calendar/calendar_strip.dart';
import 'package:task_todo_app/shared/widgets/cards/swipeable_task_card.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  DateTime _selectedDate = DateTime.now();
  int _selectedFilterIndex = 0;
  
  User? _currentUser;
  List<Statuse> _statuses = [];
  List<Task> _tasks = [];
  List<TaskGroup> _groups = [];
  bool _isLoading = true;

  final List<String> _filterTabs = ['All', 'To Do', 'In Progress', 'Done'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await userRepository.getCurrentUser();
    if (user == null) return;

    final statuses = await statusRepository.getAll();
    final tasks = await taskRepository.getTodayTasks(user.serverId);
    final groups = await taskGroupRepository.getAllForUser(user.serverId);

    if (mounted) {
      setState(() {
        _currentUser = user;
        _statuses = statuses;
        _tasks = tasks;
        _groups = groups;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadTasksForDate(DateTime date) async {
    if (_currentUser == null) return;

    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final tasks = await taskRepository.getByDateRange(
      _currentUser!.serverId,
      startOfDay,
      endOfDay,
    );

    if (mounted) {
      setState(() {
        _tasks = tasks;
      });
    }
  }

  List<Task> get _filteredTasks {
    if (_selectedFilterIndex == 0) return _tasks;

    String? filterStatusName;
    switch (_selectedFilterIndex) {
      case 1:
        filterStatusName = 'To Do';
        break;
      case 2:
        filterStatusName = 'In Progress';
        break;
      case 3:
        filterStatusName = 'Done';
        break;
    }

    if (filterStatusName == null) return _tasks;

    final status = _statuses.where((s) => s.name == filterStatusName).firstOrNull;
    if (status == null) return _tasks;

    return _tasks.where((t) => t.statusServerId == status.serverId).toList();
  }

  TaskStatus _getTaskStatus(Task task) {
    final status = _statuses.where((s) => s.serverId == task.statusServerId).firstOrNull;
    if (status == null) return TaskStatus.todo;
    
    switch (status.name) {
      case 'In Progress':
        return TaskStatus.inProgress;
      case 'Done':
        return TaskStatus.done;
      default:
        return TaskStatus.todo;
    }
  }

  TaskGroup? _getTaskGroup(Task task) {
    return _groups.where((g) => g.serverId == task.groupServerId).firstOrNull;
  }

  Color _parseHexColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  IconData _getIconForGroup(String? iconName) {
    switch (iconName) {
      case 'briefcase':
        return IconsaxPlusBold.briefcase;
      case 'user':
        return IconsaxPlusBold.user;
      case 'palette':
        return IconsaxPlusBold.paintbucket;
      case 'book':
        return IconsaxPlusBold.book_1;
      default:
        return IconsaxPlusBold.task_square;
    }
  }

  Future<void> _updateTaskStatus(Task task, String statusName) async {
    final status = _statuses.where((s) => s.name == statusName).firstOrNull;
    if (status == null) return;

    final markCompleted = statusName == 'Done';
    await taskRepository.updateStatus(task, status.serverId, markCompleted: markCompleted);
    await _loadTasksForDate(_selectedDate);
  }

  Future<void> _deleteTask(Task task) async {
    await taskRepository.delete(task.id);
    await _loadTasksForDate(_selectedDate);
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
                  _loadTasksForDate(date);
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

              // Task List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredTasks.isEmpty
                        ? _buildEmptyState(colors)
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _filteredTasks.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final task = _filteredTasks[index];
                              final group = _getTaskGroup(task);
                              final groupColor = group != null 
                                  ? _parseHexColor(group.hexColor) 
                                  : const Color(0xFF9260F4);
                              
                              return SwipeableTaskCard(
                                id: task.serverId,
                                projectName: group?.name ?? 'Uncategorized',
                                taskTitle: task.title,
                                time: task.startDate,
                                status: _getTaskStatus(task),
                                icon: _getIconForGroup(group?.icon),
                                iconColor: groupColor,
                                onMarkDone: () => _updateTaskStatus(task, 'Done'),
                                onMarkInProgress: () => _updateTaskStatus(task, 'In Progress'),
                                onMarkTodo: () => _updateTaskStatus(task, 'To Do'),
                                onMarkCanceled: () => _updateTaskStatus(task, 'Canceled'),
                                onDelete: () => _deleteTask(task),
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

  Widget _buildEmptyState(AppColorsLight colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              IconsaxPlusLinear.task_square,
              size: 64,
              color: colors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks for this day',
              style: AppTypography.titleMedium.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to add a new task',
              style: AppTypography.bodyMedium.copyWith(
                color: colors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
