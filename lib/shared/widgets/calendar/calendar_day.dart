import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

/// A calendar day selector widget.
///
/// Example usage:
/// ```dart
/// CalendarDayItem(
///   dayNumber: 25,
///   dayName: 'Sun',
///   monthName: 'May',
///   isSelected: true,
///   isToday: true,
///   onTap: () {},
/// )
/// ```
class CalendarDayItem extends StatelessWidget {
  /// Day number (1-31)
  final int dayNumber;

  /// Short day name (e.g., 'Sun', 'Mon')
  final String dayName;

  /// Short month name (optional, e.g., 'May')
  final String? monthName;

  /// Whether this day is selected
  final bool isSelected;

  /// Whether this is today
  final bool isToday;

  /// Callback when tapped
  final VoidCallback? onTap;

  const CalendarDayItem({
    super.key,
    required this.dayNumber,
    required this.dayName,
    this.monthName,
    this.isSelected = false,
    this.isToday = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xs,
          horizontal: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : Colors.transparent,
          borderRadius: AppRadius.borderRadiusMD,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Month name (if provided)
              if (monthName != null) ...[
                Text(
                  monthName!,
                  style: AppTypography.labelSmall.copyWith(
                    color: isSelected
                        ? colors.onPrimary.withOpacity(0.7)
                        : colors.textTertiary,
                  ),
                ),
                const SizedBox(height: 1),
              ],
              // Day number
              Text(
                dayNumber.toString(),
                style: AppTypography.calendarDay.copyWith(
                  color: isSelected ? colors.onPrimary : colors.textPrimary,
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
              const SizedBox(height: 1),
              // Day name
              Text(
                dayName,
                style: AppTypography.calendarWeekday.copyWith(
                  color: isSelected
                      ? colors.onPrimary.withOpacity(0.7)
                      : colors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A horizontal scrollable calendar strip.
///
/// Example usage:
/// ```dart
/// CalendarStrip(
///   days: [...],
///   selectedIndex: 2,
///   onDaySelected: (index) {},
/// )
/// ```
class CalendarStrip extends StatelessWidget {
  /// List of day data
  final List<CalendarDayData> days;

  /// Currently selected day index
  final int selectedIndex;

  /// Callback when a day is selected
  final ValueChanged<int>? onDaySelected;

  const CalendarStrip({
    super.key,
    required this.days,
    this.selectedIndex = 0,
    this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.paddingHorizontalMD,
        itemCount: days.length,
        separatorBuilder: (context, index) => AppSpacing.gapHorizontalSM,
        itemBuilder: (context, index) {
          final day = days[index];
          return CalendarDayItem(
            dayNumber: day.dayNumber,
            dayName: day.dayName,
            monthName: day.monthName,
            isSelected: index == selectedIndex,
            isToday: day.isToday,
            onTap: () => onDaySelected?.call(index),
          );
        },
      ),
    );
  }
}

/// Data class for calendar day information
class CalendarDayData {
  final int dayNumber;
  final String dayName;
  final String? monthName;
  final bool isToday;
  final DateTime date;

  const CalendarDayData({
    required this.dayNumber,
    required this.dayName,
    this.monthName,
    this.isToday = false,
    required this.date,
  });

  /// Create from DateTime
  factory CalendarDayData.fromDate(DateTime date, {bool showMonth = false}) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    return CalendarDayData(
      dayNumber: date.day,
      dayName: weekdays[date.weekday - 1],
      monthName: showMonth ? months[date.month - 1] : null,
      isToday: isToday,
      date: date,
    );
  }

  /// Generate a list of days around today
  static List<CalendarDayData> generateDays({
    int daysBefore = 2,
    int daysAfter = 4,
    bool showMonth = true,
  }) {
    final today = DateTime.now();
    final days = <CalendarDayData>[];

    for (int i = -daysBefore; i <= daysAfter; i++) {
      final date = today.add(Duration(days: i));
      days.add(CalendarDayData.fromDate(date, showMonth: showMonth));
    }

    return days;
  }
}
