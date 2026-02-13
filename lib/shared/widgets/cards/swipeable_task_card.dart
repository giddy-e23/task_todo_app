import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';
import 'package:task_todo_app/shared/widgets/badges/status_badge.dart';
import 'package:task_todo_app/shared/widgets/cards/task_card.dart';

/// A TaskCard wrapper that adds swipe actions for status changes
/// - Swipe right: Mark as Done (green background)
/// - Swipe left: Show options menu (In Progress, Canceled, Delete)
class SwipeableTaskCard extends StatelessWidget {
  final String id;
  final String projectName;
  final String taskTitle;
  final DateTime time;
  final TaskStatus status;
  final IconData? icon;
  final Color iconColor;
  final VoidCallback? onTap;
  final VoidCallback? onMarkDone;
  final VoidCallback? onMarkInProgress;
  final VoidCallback? onMarkTodo;
  final VoidCallback? onMarkCanceled;
  final VoidCallback? onDelete;

  const SwipeableTaskCard({
    super.key,
    required this.id,
    required this.projectName,
    required this.taskTitle,
    required this.time,
    required this.status,
    this.icon,
    this.iconColor = const Color(0xFF9260F4),
    this.onTap,
    this.onMarkDone,
    this.onMarkInProgress,
    this.onMarkTodo,
    this.onMarkCanceled,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Dismissible(
      key: Key(id),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Swipe right → Mark as Done
          if (status != TaskStatus.done) {
            onMarkDone?.call();
          }
          return false; // Don't remove the item, just update status
        } else {
          // Swipe left → Show options bottom sheet
          await _showOptionsSheet(context, colors);
          return false;
        }
      },
      background: _buildSwipeBackground(
        color: const Color(0xFF10B981),
        icon: IconsaxPlusBold.tick_circle,
        label: 'Done',
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _buildSwipeBackground(
        color: const Color(0xFFF59E0B),
        icon: IconsaxPlusBold.more,
        label: 'Options',
        alignment: Alignment.centerRight,
      ),
      child: TaskCard(
        projectName: projectName,
        taskTitle: taskTitle,
        time: time,
        status: status,
        icon: icon,
        iconColor: iconColor,
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwipeBackground({
    required Color color,
    required IconData icon,
    required String label,
    required Alignment alignment,
  }) {
    final isLeft = alignment == Alignment.centerLeft;
    
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: alignment,
      padding: EdgeInsets.only(
        left: isLeft ? 20 : 0,
        right: isLeft ? 0 : 20,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: isLeft
            ? [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: AppTypography.labelMedium.copyWith(color: Colors.white),
                ),
              ]
            : [
                Text(
                  label,
                  style: AppTypography.labelMedium.copyWith(color: Colors.white),
                ),
                const SizedBox(width: 8),
                Icon(icon, color: Colors.white, size: 24),
              ],
      ),
    );
  }

  Future<void> _showOptionsSheet(BuildContext context, AppColorsLight colors) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Title
              Text(
                'Update Status',
                style: AppTypography.titleMedium.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              
              // Status options
              if (status != TaskStatus.todo)
                _buildOptionTile(
                  context: context,
                  icon: IconsaxPlusBold.document,
                  label: 'To Do',
                  color: const Color(0xFF6B7280),
                  onTap: () {
                    Navigator.pop(context);
                    onMarkTodo?.call();
                  },
                ),
              
              if (status != TaskStatus.inProgress)
                _buildOptionTile(
                  context: context,
                  icon: IconsaxPlusBold.timer_1,
                  label: 'In Progress',
                  color: const Color(0xFFF59E0B),
                  onTap: () {
                    Navigator.pop(context);
                    onMarkInProgress?.call();
                  },
                ),
              
              if (status != TaskStatus.done)
                _buildOptionTile(
                  context: context,
                  icon: IconsaxPlusBold.tick_circle,
                  label: 'Done',
                  color: const Color(0xFF10B981),
                  onTap: () {
                    Navigator.pop(context);
                    onMarkDone?.call();
                  },
                ),
              
              _buildOptionTile(
                context: context,
                icon: IconsaxPlusBold.close_circle,
                label: 'Canceled',
                color: const Color(0xFFEF4444),
                onTap: () {
                  Navigator.pop(context);
                  onMarkCanceled?.call();
                },
              ),
              
              const Divider(height: 24),
              
              // Delete option
              _buildOptionTile(
                context: context,
                icon: IconsaxPlusBold.trash,
                label: 'Delete Task',
                color: const Color(0xFFEF4444),
                isDestructive: true,
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, colors);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final colors = AppColors.of(context);
    
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(
          color: isDestructive ? color : colors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context, AppColorsLight colors) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Task',
          style: AppTypography.titleMedium.copyWith(color: colors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete "$taskTitle"? This action cannot be undone.',
          style: AppTypography.bodyMedium.copyWith(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: AppTypography.labelMedium.copyWith(color: colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: AppTypography.labelMedium.copyWith(color: const Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onDelete?.call();
    }
  }
}
