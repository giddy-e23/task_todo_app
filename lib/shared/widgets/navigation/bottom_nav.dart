import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

/// Bottom navigation item data.
class BottomNavItem {
  /// Icon when not selected
  final IconData icon;

  /// Icon when selected (optional, uses filled variant)
  final IconData? activeIcon;

  /// Item label
  final String label;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

/// Custom bottom navigation bar matching app design.
///
/// Example usage:
/// ```dart
/// AppBottomNavBar(
///   currentIndex: _currentIndex,
///   onTap: (index) => setState(() => _currentIndex = index),
///   items: const [
///     BottomNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
///     BottomNavItem(icon: Icons.calendar_outlined, activeIcon: Icons.calendar_today, label: 'Calendar'),
///     BottomNavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
///   ],
/// )
/// ```
class AppBottomNavBar extends StatelessWidget {
  /// Currently selected index
  final int currentIndex;

  /// Navigation items
  final List<BottomNavItem> items;

  /// Callback when item is tapped
  final ValueChanged<int>? onTap;

  /// Whether to show labels
  final bool showLabels;

  /// Floating action button in center (optional)
  final Widget? centerButton;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    this.onTap,
    this.showLabels = false,
    this.centerButton,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...List.generate(items.length, (index) {
                // Insert center button after first half
                final isCenter =
                    centerButton != null && index == items.length ~/ 2;

                return [
                  if (isCenter) centerButton!,
                  _NavItem(
                    item: items[index],
                    isSelected: currentIndex == index,
                    onTap: () => onTap?.call(index),
                    showLabel: showLabels,
                    selectedColor: colors.primary,
                    unselectedColor: colors.textHint,
                  ),
                ];
              }).expand((x) => x),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final BottomNavItem item;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showLabel;
  final Color selectedColor;
  final Color unselectedColor;

  const _NavItem({
    required this.item,
    required this.isSelected,
    this.onTap,
    required this.showLabel,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? selectedColor : unselectedColor;
    final icon = isSelected ? (item.activeIcon ?? item.icon) : item.icon;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppSizes.iconLG, color: color),
            if (showLabel) ...[
              AppSpacing.gapVerticalXXS,
              Text(
                item.label,
                style: AppTypography.labelSmall.copyWith(
                  color: color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Floating add button typically shown in the center of bottom nav.
///
/// Example usage:
/// ```dart
/// AppBottomNavBar(
///   currentIndex: 0,
///   items: items,
///   centerButton: AddFloatingButton(onTap: () => _showAddTask()),
/// )
/// ```
class AddFloatingButton extends StatelessWidget {
  /// Callback when button is tapped
  final VoidCallback? onTap;

  /// Button size
  final double size;

  /// Icon inside the button
  final IconData icon;

  const AddFloatingButton({
    super.key,
    this.onTap,
    this.size = 56,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.primary, colors.primary.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: AppColorPalette.white, size: AppSizes.iconLG),
      ),
    );
  }
}

/// Simple scaffold with app-styled bottom navigation.
class AppNavScaffold extends StatelessWidget {
  /// Body content
  final Widget body;

  /// Currently selected index
  final int currentIndex;

  /// Navigation items
  final List<BottomNavItem> items;

  /// Callback when nav item is tapped
  final ValueChanged<int>? onNavTap;

  /// Floating action button
  final Widget? floatingActionButton;

  /// Whether to show the center add button
  final bool showCenterButton;

  /// Callback when center button is tapped
  final VoidCallback? onCenterTap;

  /// App bar (optional)
  final PreferredSizeWidget? appBar;

  const AppNavScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.items,
    this.onNavTap,
    this.floatingActionButton,
    this.showCenterButton = true,
    this.onCenterTap,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        items: items,
        onTap: onNavTap,
        centerButton: showCenterButton
            ? AddFloatingButton(onTap: onCenterTap)
            : null,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
