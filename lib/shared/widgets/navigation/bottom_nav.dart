import 'dart:ui';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

/// Glassy navigation bar background color
const Color _kGlassyNavColor = Color(0xFFEEE9FF);

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

/// Animated bottom navigation bar with center notch for FAB and glassy effect.
///
/// Uses `animated_bottom_navigation_bar` package for smooth animations
/// and notched design matching the Figma design.
///
/// **Important:** For the glassy effect to work properly, set `extendBody: true`
/// on your Scaffold:
///
/// ```dart
/// Scaffold(
///   extendBody: true, // Required for glass effect
///   body: _pages[_currentIndex],
///   floatingActionButton: FloatingActionButton(
///     onPressed: () => _addTask(),
///     child: Icon(Icons.add),
///   ),
///   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
///   bottomNavigationBar: AppBottomNavBar(
///     currentIndex: _currentIndex,
///     onTap: (index) => setState(() => _currentIndex = index),
///     icons: [Icons.home, Icons.calendar_today, Icons.folder, Icons.person],
///   ),
/// )
/// ```
class AppBottomNavBar extends StatelessWidget {
  /// Currently selected index
  final int currentIndex;

  /// List of icons for navigation items
  final List<IconData> icons;

  /// Callback when item is tapped
  final Function(int)? onTap;

  /// Gap location for the FAB notch
  final GapLocation gapLocation;

  /// Smoothness of the notch curve
  final NotchSmoothness notchSmoothness;

  /// Left corner radius
  final double leftCornerRadius;

  /// Right corner radius
  final double rightCornerRadius;

  /// Size of icons
  final double iconSize;

  /// Gap width for the notch
  final double? gapWidth;

  /// Height of the navigation bar
  final double? height;

  /// Background color override
  final Color? backgroundColor;

  /// Active icon color override
  final Color? activeColor;

  /// Inactive icon color override
  final Color? inactiveColor;

  /// Shadow for the navigation bar
  final Shadow? shadow;

  /// Whether to hide the bar on scroll
  final bool hideOnScroll;

  /// Scroll controller for hide-on-scroll behavior
  final ScrollController? scrollController;

  /// Enable glassy/frosted effect (requires extendBody: true on Scaffold)
  final bool enableGlassEffect;

  /// Blur intensity for glass effect
  final double blurIntensity;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.icons,
    this.onTap,
    this.gapLocation = GapLocation.center,
    this.notchSmoothness = NotchSmoothness.smoothEdge,
    this.leftCornerRadius = 0,
    this.rightCornerRadius = 0,
    this.iconSize = 24,
    this.gapWidth,
    this.height,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.shadow,
    this.hideOnScroll = false,
    this.scrollController,
    this.enableGlassEffect = true,
    this.blurIntensity = 20,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final navHeight = height ?? 60;

    final navBar = AnimatedBottomNavigationBar(
      icons: icons,
      activeIndex: currentIndex,
      onTap: onTap ?? (_) {},
      gapLocation: gapLocation,
      notchSmoothness: notchSmoothness,
      leftCornerRadius: leftCornerRadius,
      rightCornerRadius: rightCornerRadius,
      iconSize: iconSize,
      gapWidth: gapWidth ?? 72,
      height: navHeight,
      backgroundColor: enableGlassEffect
          ? Colors.transparent
          : (backgroundColor ?? _kGlassyNavColor),
      activeColor: activeColor ?? colors.primary,
      inactiveColor: inactiveColor ?? colors.textHint,
      splashColor: colors.primary.withValues(alpha: 0.1),
      splashSpeedInMilliseconds: 300,
      shadow: enableGlassEffect
          ? const Shadow(color: Colors.transparent)
          : shadow,
      hideAnimationController: scrollController != null
          ? _createHideController(scrollController!)
          : null,
    );

    if (!enableGlassEffect) {
      return navBar;
    }

    // Glass effect wrapper - subtle blur with mostly solid color as per Figma
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(leftCornerRadius),
        topRight: Radius.circular(rightCornerRadius),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurIntensity, sigmaY: blurIntensity),
        child: Container(
          decoration: BoxDecoration(
            // Mostly solid color with slight transparency for glass effect
            color: (backgroundColor ?? _kGlassyNavColor).withValues(
              alpha: 0.92,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(leftCornerRadius),
              topRight: Radius.circular(rightCornerRadius),
            ),
          ),
          child: SafeArea(top: false, child: navBar),
        ),
      ),
    );
  }

  AnimationController? _createHideController(
    ScrollController scrollController,
  ) {
    // This would need to be created in a StatefulWidget
    // For now, return null - users can implement their own if needed
    return null;
  }
}

/// Builder version of the animated bottom navigation bar for custom tab views.
///
/// Example usage:
/// ```dart
/// AppBottomNavBarBuilder(
///   currentIndex: _currentIndex,
///   itemCount: 4,
///   tabBuilder: (index, isActive) {
///     return Column(
///       mainAxisSize: MainAxisSize.min,
///       children: [
///         Icon(icons[index], color: isActive ? colors.primary : colors.grey),
///         Text(labels[index], style: TextStyle(fontSize: 10)),
///       ],
///     );
///   },
///   onTap: (index) => setState(() => _currentIndex = index),
/// )
/// ```
class AppBottomNavBarBuilder extends StatelessWidget {
  /// Currently selected index
  final int currentIndex;

  /// Number of items
  final int itemCount;

  /// Builder for each tab
  final Widget Function(int index, bool isActive) tabBuilder;

  /// Callback when item is tapped
  final Function(int)? onTap;

  /// Gap location for the FAB notch
  final GapLocation gapLocation;

  /// Smoothness of the notch curve
  final NotchSmoothness notchSmoothness;

  /// Left corner radius
  final double leftCornerRadius;

  /// Right corner radius
  final double rightCornerRadius;

  /// Gap width for the notch
  final double? gapWidth;

  /// Height of the navigation bar
  final double? height;

  /// Background color override
  final Color? backgroundColor;

  const AppBottomNavBarBuilder({
    super.key,
    required this.currentIndex,
    required this.itemCount,
    required this.tabBuilder,
    this.onTap,
    this.gapLocation = GapLocation.center,
    this.notchSmoothness = NotchSmoothness.smoothEdge,
    this.leftCornerRadius = 0,
    this.rightCornerRadius = 0,
    this.gapWidth,
    this.height,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final navHeight = height ?? 60;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AnimatedBottomNavigationBar.builder(
          itemCount: itemCount,
          tabBuilder: tabBuilder,
          activeIndex: currentIndex,
          onTap: onTap ?? (_) {},
          gapLocation: gapLocation,
          notchSmoothness: notchSmoothness,
          leftCornerRadius: leftCornerRadius,
          rightCornerRadius: rightCornerRadius,
          gapWidth: gapWidth ?? 72,
          height: navHeight,
          backgroundColor:
              backgroundColor ?? _kGlassyNavColor.withValues(alpha: 0.85),
          splashColor: colors.primary.withValues(alpha: 0.1),
          splashSpeedInMilliseconds: 300,
          shadow: const Shadow(
            color: Color(0x1A5F33E1),
            blurRadius: 24,
            offset: Offset(0, -4),
          ),
        ),
      ),
    );
  }
}

/// Floating add button typically shown in the center of bottom nav.
///
/// Example usage:
/// ```dart
/// Scaffold(
///   floatingActionButton: AddFloatingButton(onTap: () => _showAddTask()),
///   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
///   bottomNavigationBar: AppBottomNavBar(...),
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

/// Simple scaffold with animated bottom navigation.
///
/// Example usage:
/// ```dart
/// AppNavScaffold(
///   body: _pages[_currentIndex],
///   currentIndex: _currentIndex,
///   icons: [Icons.home, Icons.calendar_today, Icons.folder, Icons.person],
///   onNavTap: (index) => setState(() => _currentIndex = index),
///   onFabTap: () => _addTask(),
/// )
/// ```
class AppNavScaffold extends StatelessWidget {
  /// Body content
  final Widget body;

  /// Currently selected index
  final int currentIndex;

  /// List of icons for navigation
  final List<IconData> icons;

  /// Callback when nav item is tapped
  final ValueChanged<int>? onNavTap;

  /// Callback when FAB is tapped
  final VoidCallback? onFabTap;

  /// App bar (optional)
  final PreferredSizeWidget? appBar;

  /// Gap location for the FAB notch
  final GapLocation gapLocation;

  /// Notch smoothness
  final NotchSmoothness notchSmoothness;

  /// Left corner radius
  final double leftCornerRadius;

  /// Right corner radius
  final double rightCornerRadius;

  const AppNavScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.icons,
    this.onNavTap,
    this.onFabTap,
    this.appBar,
    this.gapLocation = GapLocation.center,
    this.notchSmoothness = NotchSmoothness.smoothEdge,
    this.leftCornerRadius = 0,
    this.rightCornerRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: AddFloatingButton(onTap: onFabTap),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        icons: icons,
        onTap: onNavTap,
        gapLocation: gapLocation,
        notchSmoothness: notchSmoothness,
        leftCornerRadius: leftCornerRadius,
        rightCornerRadius: rightCornerRadius,
      ),
    );
  }
}
