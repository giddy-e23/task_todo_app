import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:task_todo_app/core/di/injection.dart';
import 'package:task_todo_app/core/network/api_client.dart';
import 'package:task_todo_app/core/network/dto/dto.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';
import 'package:task_todo_app/feature/auth/bloc/bloc.dart';
import 'package:task_todo_app/shared/custom_app_background.dart';
import 'package:task_todo_app/shared/widgets/cards/task_group_card.dart' as card;
import 'package:task_todo_app/shared/widgets/cards/task_overview.dart';
import 'package:task_todo_app/shared/widgets/cards/task_progress_card.dart';
import 'package:task_todo_app/shared/widgets/app_section_bar.dart';

class HomePage extends StatefulWidget {
  /// Callback when user taps "View Tasks" button
  final VoidCallback? onViewTasks;

  const HomePage({super.key, this.onViewTasks});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TaskGroupDto> _groups = [];
  List<TaskDto> _inProgressTasks = [];
  Map<String, List<TaskDto>> _tasksByGroup = {};
  int _totalTasks = 0;
  int _completedTasks = 0;
  bool _isLoading = true;
  String? _errorMessage;

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
      // Fetch all task groups from API
      final groups = await taskApiService.getAllTaskGroups();
      
      // Fetch tasks for each group
      final Map<String, List<TaskDto>> tasksByGroup = {};
      final List<TaskDto> allTasks = [];
      final List<TaskDto> inProgressTasks = [];
      int completedCount = 0;

      for (final group in groups) {
        try {
          final tasks = await taskApiService.getAllTasksForGroup(group.id);
          tasksByGroup[group.id] = tasks;
          allTasks.addAll(tasks);
          
          // Filter in-progress and completed
          for (final task in tasks) {
            if (task.status.status == 'In Progress') {
              inProgressTasks.add(task);
            } else if (task.status.status == 'Done') {
              completedCount++;
            }
          }
        } catch (e) {
          // If we can't fetch tasks for a group, continue with others
          tasksByGroup[group.id] = [];
        }
      }

      if (mounted) {
        setState(() {
          _groups = groups;
          _tasksByGroup = tasksByGroup;
          _inProgressTasks = inProgressTasks;
          _totalTasks = allTasks.length;
          _completedTasks = completedCount;
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
          _errorMessage = 'Failed to load data. Pull to refresh.';
        });
      }
    }
  }

  int _getTaskCountForGroup(TaskGroupDto group) {
    return _tasksByGroup[group.id]?.length ?? 0;
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

  double _calculateGroupProgress(TaskGroupDto group) {
    return group.completed / 100;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: CustomAppBackground(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
                  ? _buildErrorState(colors)
                  : _buildContent(colors),
        ),
      ),
    );
  }

  Widget _buildErrorState(AppColorsLight colors) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Center(
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
      ),
    );
  }

  Widget _buildContent(AppColorsLight colors) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Header Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _buildHeader(colors),
          ),

          const SizedBox(height: 24),

          // Task Overview Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TaskOverview(
              completedTasks: _completedTasks,
              totalTasks: _totalTasks,
              onViewTasks: widget.onViewTasks,
            ),
          ),

          const SizedBox(height: 28),

          // In Progress Section
          if (_inProgressTasks.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: AppSectionBar(
                title: 'In Progress',
                count: _inProgressTasks.length,
              ),
            ),

            const SizedBox(height: 16),

            // Horizontal scrolling task progress cards
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: _inProgressTasks.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final task = _inProgressTasks[index];
                  final groupColor = _parseHexColor(task.group.hexColor);
                  
                  return TaskProgressCard(
                    backgroundColor: groupColor.withValues(alpha: 0.1),
                    iconColor: groupColor,
                    icon: _getIconForGroup(task.group.icon),
                    category: task.group.name,
                    title: task.taskName,
                    progressPercent: 0.5, // Would calculate based on subtasks
                    progressColor: groupColor,
                  );
                },
              ),
            ),

            const SizedBox(height: 28),
          ],

          // Task Groups Section
          if (_groups.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: AppSectionBar(
                title: 'Task Groups',
                count: _groups.length,
              ),
            ),

            const SizedBox(height: 16),

            // Task Group List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _groups.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final group = _groups[index];
                  final groupColor = _parseHexColor(group.hexColor);
                  
                  return card.TaskGroup(
                    iconColor: groupColor,
                    groupIcon: _getIconForGroup(group.icon),
                    title: group.name,
                    taskCount: _getTaskCountForGroup(group),
                    progressPercent: _calculateGroupProgress(group),
                    progressColor: groupColor,
                  );
                },
              ),
            ),
          ],

          // Empty state
          if (_groups.isEmpty) ...[
            SizedBox(
              height: 200,
              child: Center(
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
                      'No task groups yet',
                      style: AppTypography.bodyLarge.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your first task to get started',
                      style: AppTypography.bodyMedium.copyWith(
                        color: colors.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Add padding at bottom for nav bar
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildHeader(AppColorsLight colors) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String userName = 'Guest User';
        String userInitials = 'GU';
        String? profilePictureUrl;

        if (state is Authenticated) {
          userName = state.user.fullName;
          userInitials = '${state.user.firstName[0]}${state.user.lastName[0]}';
          profilePictureUrl = state.user.profilePictureUrl;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 24,
                  backgroundColor: colors.primary.withValues(alpha: 0.1),
                  child: profilePictureUrl != null
                      ? ClipOval(
                          child: Image.network(
                            profilePictureUrl,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Text(
                              userInitials,
                              style: AppTypography.titleMedium.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      : Text(
                          userInitials,
                          style: AppTypography.titleMedium.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
                      userName,
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
      },
    );
  }
}