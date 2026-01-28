import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

/// A filter/tab chip widget for filtering content.
///
/// Example usage:
/// ```dart
/// FilterChip(
///   label: 'All',
///   isSelected: true,
///   onTap: () {},
/// )
/// ```
class AppFilterChip extends StatelessWidget {
  /// Chip label text
  final String label;

  /// Whether the chip is selected
  final bool isSelected;

  /// Callback when chip is tapped
  final VoidCallback? onTap;

  const AppFilterChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Material(
      color: isSelected ? colors.primary : colors.chipBackground,
      borderRadius: AppRadius.borderRadiusFull,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderRadiusFull,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: isSelected ? colors.onPrimary : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

/// A horizontal scrollable list of filter chips.
///
/// Example usage:
/// ```dart
/// FilterChipRow(
///   filters: ['All', 'To do', 'In Progress', 'Completed'],
///   selectedIndex: 0,
///   onFilterSelected: (index) {},
/// )
/// ```
class FilterChipRow extends StatelessWidget {
  /// List of filter labels
  final List<String> filters;

  /// Currently selected filter index
  final int selectedIndex;

  /// Callback when a filter is selected
  final ValueChanged<int>? onFilterSelected;

  const FilterChipRow({
    super.key,
    required this.filters,
    this.selectedIndex = 0,
    this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.chipBackground,
        borderRadius: AppRadius.borderRadiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          filters.length,
          (index) => Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 4,
            ),
            child: AppFilterChip(
              label: filters[index],
              isSelected: index == selectedIndex,
              onTap: () => onFilterSelected?.call(index),
            ),
          ),
        ),
      ),
    );
  }
}

/// A single-select chip group that wraps to multiple lines.
class ChipGroup extends StatelessWidget {
  /// List of chip labels
  final List<String> chips;

  /// Currently selected chip index
  final int selectedIndex;

  /// Callback when a chip is selected
  final ValueChanged<int>? onChipSelected;

  /// Spacing between chips
  final double spacing;

  /// Run spacing between rows
  final double runSpacing;

  const ChipGroup({
    super.key,
    required this.chips,
    this.selectedIndex = 0,
    this.onChipSelected,
    this.spacing = 8,
    this.runSpacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: List.generate(
        chips.length,
        (index) => AppFilterChip(
          label: chips[index],
          isSelected: index == selectedIndex,
          onTap: () => onChipSelected?.call(index),
        ),
      ),
    );
  }
}
