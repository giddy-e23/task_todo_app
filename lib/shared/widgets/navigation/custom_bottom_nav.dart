import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../core/theme/theme.dart';

/// Navigation bar background color matching Figma design
const Color kNavBarColor = Color(0xFFEEE9FF);

/// Custom bottom navigation bar with center notch for FAB.
///
/// This is a custom implementation that matches the Figma design exactly,
/// without relying on external packages.
///
/// **Important:** Set `extendBody: true` on your Scaffold for the glass effect.
///
/// ```dart
/// Scaffold(
///   extendBody: true,
///   body: _pages[_currentIndex],
///   floatingActionButton: AppFab(onTap: () => _addTask()),
///   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
///   bottomNavigationBar: CustomBottomNavBar(
///     currentIndex: _currentIndex,
///     onTap: (index) => setState(() => _currentIndex = index),
///     items: [
///       NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
///       NavItem(icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view, label: 'Tasks'),
///       NavItem(icon: Icons.folder_outlined, activeIcon: Icons.folder, label: 'Projects'),
///       NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
///     ],
///   ),
/// )
/// ```
class CustomBottomNavBar extends StatelessWidget {
  /// Currently selected index
  final int currentIndex;

  /// Navigation items
  final List<NavItem> items;

  /// Callback when item is tapped
  final ValueChanged<int>? onTap;

  /// Height of the navigation bar
  final double height;

  /// Notch width for the FAB
  final double notchWidth;

  /// Notch depth
  final double notchDepth;

  /// Corner radius for top corners
  final double cornerRadius;

  /// Background color
  final Color? backgroundColor;

  /// Active icon color
  final Color? activeColor;

  /// Inactive icon color
  final Color? inactiveColor;

  /// Icon size
  final double iconSize;

  /// Enable blur effect
  final bool enableBlur;

  /// Blur intensity
  final double blurIntensity;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    this.onTap,
    this.height = 56,
    this.notchWidth = 60,
    this.notchDepth = 28,
    this.cornerRadius = 24,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.iconSize = 24,
    this.enableBlur = true,
    this.blurIntensity = 10,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bgColor = backgroundColor ?? kNavBarColor;
    final active = activeColor ?? colors.primary;
    final inactive = inactiveColor ?? colors.textHint;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    Widget navContent = SizedBox(
      height: height + bottomPadding,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background with notch
          Positioned.fill(
            child: CustomPaint(
              painter: _NotchedNavBarPainter(
                color: enableBlur ? bgColor.withValues(alpha: 0.85) : bgColor,
                notchWidth: notchWidth,
                notchDepth: notchDepth,
                cornerRadius: cornerRadius,
              ),
            ),
          ),
          // Navigation items
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: height,
            child: Row(children: _buildItems(active, inactive)),
          ),
        ],
      ),
    );

    // Wrap with blur effect if enabled
    if (enableBlur) {
      navContent = ClipPath(
        clipper: _NotchedNavBarClipper(
          notchWidth: notchWidth,
          notchDepth: notchDepth,
          cornerRadius: cornerRadius,
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurIntensity,
            sigmaY: blurIntensity,
          ),
          child: navContent,
        ),
      );
    }

    return navContent;
  }

  List<Widget> _buildItems(Color active, Color inactive) {
    final List<Widget> widgets = [];
    final middleIndex = items.length ~/ 2;

    for (int i = 0; i < items.length; i++) {
      // Add spacer for notch in the middle
      if (i == middleIndex) {
        widgets.add(SizedBox(width: notchWidth));
      }

      final isActive = i == currentIndex;
      final item = items[i];

      widgets.add(
        Expanded(
          child: _NavItemWidget(
            item: item,
            isActive: isActive,
            activeColor: active,
            inactiveColor: inactive,
            iconSize: iconSize,
            onTap: () => onTap?.call(i),
          ),
        ),
      );
    }

    return widgets;
  }
}

/// Navigation item data
class NavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const NavItem({required this.icon, this.activeIcon, required this.label});
}

/// Individual navigation item widget with shadow effect
class _NavItemWidget extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final double iconSize;
  final VoidCallback? onTap;

  const _NavItemWidget({
    required this.item,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.iconSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : inactiveColor;
    final icon = isActive ? (item.activeIcon ?? item.icon) : item.icon;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Container(
              key: ValueKey(isActive),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: iconSize),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the notched navigation bar background
class _NotchedNavBarPainter extends CustomPainter {
  final Color color;
  final double notchWidth;
  final double notchDepth;
  final double cornerRadius;

  _NotchedNavBarPainter({
    required this.color,
    required this.notchWidth,
    required this.notchDepth,
    required this.cornerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final centerX = size.width / 2;
    final notchRadius = notchWidth / 2;

    // Start from top-left corner
    path.moveTo(0, cornerRadius);

    // Top-left corner
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    // Line to notch start
    path.lineTo(centerX - notchRadius - 10, 0);

    // Notch curve (smooth bezier curves)
    // Entry curve into notch
    path.quadraticBezierTo(
      centerX - notchRadius,
      0,
      centerX - notchRadius + 8,
      notchDepth * 0.5,
    );

    // Bottom of notch (circular arc)
    path.quadraticBezierTo(
      centerX - notchRadius + 16,
      notchDepth,
      centerX,
      notchDepth,
    );

    path.quadraticBezierTo(
      centerX + notchRadius - 16,
      notchDepth,
      centerX + notchRadius - 8,
      notchDepth * 0.5,
    );

    // Exit curve from notch
    path.quadraticBezierTo(
      centerX + notchRadius,
      0,
      centerX + notchRadius + 10,
      0,
    );

    // Line to top-right corner
    path.lineTo(size.width - cornerRadius, 0);

    // Top-right corner
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    // Right edge
    path.lineTo(size.width, size.height);

    // Bottom edge
    path.lineTo(0, size.height);

    // Left edge back to start
    path.lineTo(0, cornerRadius);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NotchedNavBarPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.notchWidth != notchWidth ||
        oldDelegate.notchDepth != notchDepth ||
        oldDelegate.cornerRadius != cornerRadius;
  }
}

/// Custom clipper for the notched navigation bar (for blur effect)
class _NotchedNavBarClipper extends CustomClipper<Path> {
  final double notchWidth;
  final double notchDepth;
  final double cornerRadius;

  _NotchedNavBarClipper({
    required this.notchWidth,
    required this.notchDepth,
    required this.cornerRadius,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final centerX = size.width / 2;
    final notchRadius = notchWidth / 2;

    // Start from top-left corner
    path.moveTo(0, cornerRadius);

    // Top-left corner
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    // Line to notch start
    path.lineTo(centerX - notchRadius - 10, 0);

    // Notch curve (smooth bezier curves)
    path.quadraticBezierTo(
      centerX - notchRadius,
      0,
      centerX - notchRadius + 8,
      notchDepth * 0.5,
    );

    path.quadraticBezierTo(
      centerX - notchRadius + 16,
      notchDepth,
      centerX,
      notchDepth,
    );

    path.quadraticBezierTo(
      centerX + notchRadius - 16,
      notchDepth,
      centerX + notchRadius - 8,
      notchDepth * 0.5,
    );

    path.quadraticBezierTo(
      centerX + notchRadius,
      0,
      centerX + notchRadius + 10,
      0,
    );

    // Line to top-right corner
    path.lineTo(size.width - cornerRadius, 0);

    // Top-right corner
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    // Right edge
    path.lineTo(size.width, size.height);

    // Bottom edge
    path.lineTo(0, size.height);

    // Left edge back to start
    path.lineTo(0, cornerRadius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _NotchedNavBarClipper oldClipper) {
    return oldClipper.notchWidth != notchWidth ||
        oldClipper.notchDepth != notchDepth ||
        oldClipper.cornerRadius != cornerRadius;
  }
}

/// Floating action button for the center of the bottom nav
class AppFab extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;

  const AppFab({
    super.key,
    this.onTap,
    this.size = 44,
    this.icon = IconsaxPlusLinear.add,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bgColor = backgroundColor ?? colors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: bgColor.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor ?? Colors.white, size: 28),
      ),
    );
  }
}

/// Complete scaffold with custom bottom nav
class CustomNavScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final List<NavItem> items;
  final ValueChanged<int>? onNavTap;
  final VoidCallback? onFabTap;
  final PreferredSizeWidget? appBar;
  final double navHeight;
  final double cornerRadius;

  const CustomNavScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.items,
    this.onNavTap,
    this.onFabTap,
    this.appBar,
    this.navHeight = 70,
    this.cornerRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: appBar,
      body: body,
      floatingActionButton: AppFab(onTap: onFabTap),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        items: items,
        onTap: onNavTap,
        height: navHeight,
        cornerRadius: cornerRadius,
      ),
    );
  }
}
