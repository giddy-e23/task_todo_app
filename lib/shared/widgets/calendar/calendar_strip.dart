import 'package:flutter/material.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';

class CalendarDayCard extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback? onTap;

  const CalendarDayCard({
    super.key,
    required this.date,
    this.isSelected = false,
    this.onTap,
  });

  String get _monthAbbr {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[date.month - 1];
  }

  String get _dayOfWeek {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? null
              : [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _monthAbbr,
              style: AppTypography.bodySmall.copyWith(
                color: isSelected ? colors.textOnPrimary : colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date.day.toString(),
              style: AppTypography.headlineXSmall.copyWith(
                color: isSelected ? colors.textOnPrimary : colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _dayOfWeek,
              style: AppTypography.bodySmall.copyWith(
                color: isSelected ? colors.textOnPrimary : colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal scrollable calendar strip
class CalendarStrip extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final int daysToShow;

  const CalendarStrip({
    super.key,
    required this.selectedDate,
    this.onDateSelected,
    this.daysToShow = 7,
  });

  List<DateTime> _generateDays() {
    final today = DateTime.now();
    // Start from 2 days before today
    final startDate = today.subtract(const Duration(days: 2));
    return List.generate(
      daysToShow,
      (index) => startDate.add(Duration(days: index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = _generateDays();

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = day.year == selectedDate.year &&
              day.month == selectedDate.month &&
              day.day == selectedDate.day;

          return CalendarDayCard(
            date: day,
            isSelected: isSelected,
            onTap: () => onDateSelected?.call(day),
          );
        },
      ),
    );
  }
}
