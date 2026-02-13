import 'package:flutter/material.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';
import 'package:task_todo_app/shared/widgets/buttons/app_button.dart';

class FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const FilterChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    if (isSelected) {
      // Selected: Purple background, white text
      return AppButton.primary(
        label: label,
        onPressed: onTap,
        textStyle: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w400),
        size: AppButtonSize.small,
        fullWidth: false,
      );
    }

    // Unselected: Light purple background, purple text
    return AppButton.primary(
      label: label,
      textStyle: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w400),
      onPressed: onTap,
      size: AppButtonSize.small,
      fullWidth: false,
      backgroundColor: colors.primary.withValues(alpha: 0.1),
      foregroundColor: colors.primary,
    );
  }
}

class FilterTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int>? onTabSelected;

  const FilterTabBar({
    super.key,
    required this.tabs,
    this.selectedIndex = 0,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6), // Space for bulge
      child: SizedBox(
        height: 36, // Button height only
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none, // Allow bulge to render outside bounds
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: tabs.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            return FilterChip(
              label: tabs[index],
              isSelected: index == selectedIndex,
              onTap: () => onTabSelected?.call(index),
            );

          
          },
        ),
      ),
    );
  }
}
