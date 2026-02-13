import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

/// Task status types
enum TaskStatus {
  todo,
  inProgress,
  done,
}

/// A status badge widget showing task status.
///
/// Example usage:
/// ```dart
/// StatusBadge(status: TaskStatus.done)
/// StatusBadge.todo()
/// StatusBadge.inProgress()
/// StatusBadge.done()
/// ```
class StatusBadge extends StatelessWidget {
  final TaskStatus status;
  final String? customLabel;

  const StatusBadge({
    super.key,
    required this.status,
    this.customLabel,
  });

  /// Creates a To-Do status badge
  factory StatusBadge.todo({Key? key, String? label}) {
    return StatusBadge(
      key: key,
      status: TaskStatus.todo,
      customLabel: label,
    );
  }

  /// Creates an In Progress status badge
  factory StatusBadge.inProgress({Key? key, String? label}) {
    return StatusBadge(
      key: key,
      status: TaskStatus.inProgress,
      customLabel: label,
    );
  }

  /// Creates a Done status badge
  factory StatusBadge.done({Key? key, String? label}) {
    return StatusBadge(
      key: key,
      status: TaskStatus.done,
      customLabel: label,
    );
  }

  String get _defaultLabel {
    switch (status) {
      case TaskStatus.todo:
        return 'To-do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.done:
        return 'Done';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    Color backgroundColor;
    Color textColor;

    switch (status) {
      case TaskStatus.todo:
        backgroundColor = colors.statusTodoBackground;
        textColor = colors.statusTodo;
        break;
      case TaskStatus.inProgress:
        backgroundColor = colors.statusInProgressBackground;
        textColor = colors.statusInProgress;
        break;
      case TaskStatus.done:
        backgroundColor = colors.statusDoneBackground;
        textColor = colors.statusDone;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: ShapeDecoration(shape: 
      
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: backgroundColor,
      ),
      child: Text(
        customLabel ?? _defaultLabel,
        style: AppTypography.statusBadge.copyWith(
          color: textColor,
        ),
      ),
    );
  }
}

/// A category indicator dot with color
class CategoryDot extends StatelessWidget {
  final Color color;
  final double size;

  const CategoryDot({
    super.key,
    required this.color,
    this.size = 8,
  });

  /// Orange category dot (Office/Work)
  factory CategoryDot.orange({Key? key, double size = 8}) {
    return CategoryDot(
      key: key,
      color: AppColorPalette.categoryOrange,
      size: size,
    );
  }

  /// Purple category dot (Personal)
  factory CategoryDot.purple({Key? key, double size = 8}) {
    return CategoryDot(
      key: key,
      color: AppColorPalette.categoryPurple,
      size: size,
    );
  }

  /// Green category dot (Daily Study)
  factory CategoryDot.green({Key? key, double size = 8}) {
    return CategoryDot(
      key: key,
      color: AppColorPalette.categoryGreen,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
