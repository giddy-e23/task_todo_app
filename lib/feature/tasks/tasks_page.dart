import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:task_todo_app/core/di/injection.dart';
import 'package:task_todo_app/core/network/api_client.dart';
import 'package:task_todo_app/core/network/dto/dto.dart';
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
  
  List<TaskDto> _allTasks = [];
  List<StatusDto> _statuses = [];
  bool _isLoading = true;
  String? _errorMessage;

  final List<String> _filterTabs = ['All', 'To Do', 'In Progress', 'Done'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Fetch statuses and task groups in parallel
      final statusesFuture = taskApiService.getStatuses();
      final groupsFuture = taskApiService.getAllTaskGroups();
      
      final results = await Future.wait([statusesFuture, groupsFuture]);
      final statuses = results[0] as List<StatusDto>;
      final groups = results[1] as List<TaskGroupDto>;
      
      // Fetch all tasks from all groups
      final List<TaskDto> allTasks = [];
      for (final group in groups) {
        try {
          final tasks = await taskApiService.getAllTasksForGroup(group.id);
          allTasks.addAll(tasks);
        } catch (e) {
          // Continue with other groups if one fails
        }
      }

      if (mounted) {
        setState(() {
          _statuses = statuses;
          _allTasks = allTasks;
          _isLoading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load tasks. Pull to refresh.';
        });
      }
    }
  }

  List<TaskDto> get _tasksForSelectedDate {
    final startOfDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _allTasks.where((task) {
      final taskDate = task.dates.startDate;
      return taskDate.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
             taskDate.isBefore(endOfDay);
    }).toList();
  }

  List<TaskDto> get _filteredTasks {
    final dateTasks = _tasksForSelectedDate;
    
    if (_selectedFilterIndex == 0) return dateTasks;

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

    if (filterStatusName == null) return dateTasks;

    return dateTasks.where((t) => t.status.status == filterStatusName).toList();
  }

  TaskStatus _getTaskStatus(TaskDto task) {
    switch (task.status.status) {
      case 'In Progress':
        return TaskStatus.inProgress;
      case 'Done':
        return TaskStatus.done;
      case 'Canceled':
        return TaskStatus.done; // Using done style for canceled
      default:
        return TaskStatus.todo;
    }
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

  Future<void> _updateTaskStatus(TaskDto task, String statusName) async {
    // Find the status ID by name
    final status = _statuses.firstWhere(
      (s) => s.name == statusName,
      orElse: () => StatusDto(id: '', name: '', hexColor: '', displayOrder: 0),
    );

    if (status.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status "$statusName" not found')),
      );
      return;
    }

    try {
      final request = UpdateTaskStatusRequestDto(
        taskId: task.taskId,
        statusId: status.id,
      );
      await taskApiService.updateTaskStatus(request);
      
      // Reload data to reflect changes
      await _loadData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task marked as $statusName'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteTask(TaskDto task) async {
    // The API doesn't have a delete endpoint
    // Show a message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Delete is not available yet')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: CustomAppBackground(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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

                // Task List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _errorMessage != null
                          ? _buildErrorState(colors)
                          : _filteredTasks.isEmpty
                              ? _buildEmptyState(colors)
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _filteredTasks.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final task = _filteredTasks[index];
                                    final groupColor = _parseHexColor(task.group.hexColor);
                                    
                                    return SwipeableTaskCard(
                                      id: task.taskId,
                                      projectName: task.group.name,
                                      taskTitle: task.taskName,
                                      time: task.dates.startDate,
                                      status: _getTaskStatus(task),
                                      icon: _getIconForGroup(task.group.icon),
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

  Widget _buildErrorState(AppColorsLight colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              IconsaxPlusLinear.warning_2,
              size: 64,
              color: colors.error,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: AppTypography.bodyLarge.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: _loadData,
              icon: const Icon(IconsaxPlusLinear.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
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
