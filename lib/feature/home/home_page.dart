import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:task_todo_app/core/database/database.dart';
import 'package:task_todo_app/core/di/injection.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';
import 'package:task_todo_app/shared/custom_app_background.dart';
import 'package:task_todo_app/shared/widgets/cards/task_group_card.dart' as card;
import 'package:task_todo_app/shared/widgets/cards/task_overview.dart';
import 'package:task_todo_app/shared/widgets/cards/task_progress_card.dart';
import 'package:task_todo_app/shared/widgets/app_section_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? _currentUser;
  List<TaskGroup> _groups = [];
  List<Task> _inProgressTasks = [];
  List<Task> _allTasks = [];
  List<Statuse> _statuses = [];
  int _totalTasks = 0;
  int _completedTasks = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await userRepository.getCurrentUser();
    if (user == null) return;

    final statuses = await statusRepository.getAll();
    final groups = await taskGroupRepository.getAllForUser(user.serverId);
    final allTasks = await taskRepository.getAllForUser(user.serverId);
    
    // Get in-progress status
    final inProgressStatus = statuses.where((s) => s.name == 'In Progress').firstOrNull;
    final inProgressTasks = inProgressStatus != null
        ? allTasks.where((t) => t.statusServerId == inProgressStatus.serverId).toList()
        : <Task>[];

    // Count completed tasks
    final doneStatus = statuses.where((s) => s.name == 'Done').firstOrNull;
    final completedCount = doneStatus != null
        ? allTasks.where((t) => t.statusServerId == doneStatus.serverId).length
        : 0;

    if (mounted) {
      setState(() {
        _currentUser = user;
        _statuses = statuses;
        _groups = groups;
        _allTasks = allTasks;
        _inProgressTasks = inProgressTasks;
        _totalTasks = allTasks.length;
        _completedTasks = completedCount;
        _isLoading = false;
      });
    }
  }

  int _getTaskCountForGroup(TaskGroup group) {
    return _allTasks.where((t) => t.groupServerId == group.serverId).length;
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

  double _calculateGroupProgress(TaskGroup group) {
    // This would need tasks loaded per group for accurate calculation
    // For now, use the stored completed value or return 0
    return (group.completed ?? 0) / 100;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: CustomAppBackground(
        child: SingleChildScrollView(
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
                      final group = _groups.where((g) => g.serverId == task.groupServerId).firstOrNull;
                      final groupColor = group != null 
                          ? _parseHexColor(group.hexColor)
                          : const Color(0xFF9260F4);
                      
                      return TaskProgressCard(
                        backgroundColor: groupColor.withValues(alpha: 0.1),
                        iconColor: groupColor,
                        icon: _getIconForGroup(group?.icon),
                        category: group?.name ?? 'Uncategorized',
                        title: task.title,
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

              // Add padding at bottom for nav bar
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppColorsLight colors) {
    final userName = _currentUser != null
        ? '${_currentUser!.firstName} ${_currentUser!.lastName}'
        : 'Guest User';
    final userInitials = _currentUser != null
        ? '${_currentUser!.firstName[0]}${_currentUser!.lastName[0]}'
        : 'GU';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: colors.primary.withValues(alpha: 0.1),
              child: _currentUser?.profilePictureUrl != null
                  ? ClipOval(
                      child: Image.network(
                        _currentUser!.profilePictureUrl!,
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
  }
}