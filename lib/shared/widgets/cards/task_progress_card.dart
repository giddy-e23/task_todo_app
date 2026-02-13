import 'package:flutter/material.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';
import 'package:task_todo_app/shared/widgets/badges/task_icon.dart';

class TaskProgressCard extends StatefulWidget {
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final String category;
  final String title;
  final double progressPercent;
  final Color progressColor;
  final Duration animationDuration;

  const TaskProgressCard({
    super.key,
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
    required this.category,
    required this.title,
    required this.progressPercent,
    required this.progressColor,
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<TaskProgressCard> createState() => _TaskProgressCardState();
}

class _TaskProgressCardState extends State<TaskProgressCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progressPercent,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(TaskProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progressPercent != widget.progressPercent) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.progressPercent,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 160, maxWidth: 200),
      decoration: ShapeDecoration(
        color: widget.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header row with category label and icon
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.category,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.of(context).textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TaskIcon(
                    groupIcon: widget.icon,
                    iconColor: widget.iconColor,
                  ),
                ],
              ),

            const SizedBox(height: 16),

            // Title
            Text(
              widget.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.titleSmall.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 20),

            // Animated Progress bar
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: LinearProgressIndicator(
                    value: _animation.value,
                    minHeight: 6,
                    backgroundColor: widget.progressColor.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(widget.progressColor),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
