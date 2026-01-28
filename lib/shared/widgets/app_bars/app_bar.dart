import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

/// Custom app bar matching the app design.
///
/// Example usage:
/// ```dart
/// AppTopBar(
///   title: 'My Tasks',
///   showBackButton: true,
///   actions: [
///     AppIconButton(icon: Icons.search, onTap: () {}),
///   ],
/// )
/// ```
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  /// Title text
  final String? title;

  /// Title widget (overrides title text)
  final Widget? titleWidget;

  /// Whether to show the back button
  final bool showBackButton;

  /// Leading widget (overrides back button)
  final Widget? leading;

  /// Action widgets
  final List<Widget>? actions;

  /// Whether the title should be centered
  final bool centerTitle;

  /// Background color
  final Color? backgroundColor;

  /// Elevation
  final double elevation;

  /// Callback when back button is pressed
  final VoidCallback? onBackPressed;

  const AppTopBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBackButton = false,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? colors.surface,
      elevation: elevation,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      leading:
          leading ??
          (showBackButton
              ? IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: colors.surfaceVariant,
                      borderRadius: AppRadius.borderRadiusSM,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: AppSizes.iconSM,
                      color: colors.textPrimary,
                    ),
                  ),
                  onPressed:
                      onBackPressed ?? () => Navigator.of(context).maybePop(),
                )
              : null),
      title:
          titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: AppTypography.titleLarge.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null),
      actions: actions != null
          ? [...actions!, const SizedBox(width: AppSpacing.sm)]
          : null,
    );
  }
}

/// Home screen app bar with user greeting.
///
/// Example usage:
/// ```dart
/// HomeAppBar(
///   userName: 'John',
///   userAvatar: 'https://...',
///   onAvatarTap: () => navigateToProfile(),
///   onNotificationTap: () => showNotifications(),
/// )
/// ```
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// User's display name
  final String userName;

  /// User's avatar URL
  final String? userAvatar;

  /// Callback when avatar is tapped
  final VoidCallback? onAvatarTap;

  /// Callback when notification icon is tapped
  final VoidCallback? onNotificationTap;

  /// Whether there are unread notifications
  final bool hasNotifications;

  /// Custom greeting text (defaults to time-based greeting)
  final String? greeting;

  const HomeAppBar({
    super.key,
    required this.userName,
    this.userAvatar,
    this.onAvatarTap,
    this.onNotificationTap,
    this.hasNotifications = false,
    this.greeting,
  });

  String get _greeting {
    if (greeting != null) return greeting!;
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            // Avatar
            GestureDetector(
              onTap: onAvatarTap,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primaryLight,
                  image: userAvatar != null
                      ? DecorationImage(
                          image: NetworkImage(userAvatar!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: userAvatar == null
                    ? Center(
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                          style: AppTypography.titleMedium.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            AppSpacing.gapHorizontalSM,
            // Greeting
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _greeting,
                    style: AppTypography.labelMedium.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  Text(
                    userName,
                    style: AppTypography.titleMedium.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // Notification button
            _NotificationButton(
              onTap: onNotificationTap,
              hasUnread: hasNotifications,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool hasUnread;

  const _NotificationButton({this.onTap, this.hasUnread = false});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: AppRadius.borderRadiusSM,
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                Icons.notifications_outlined,
                size: AppSizes.iconMD,
                color: colors.textPrimary,
              ),
            ),
            if (hasUnread)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColorPalette.categoryOrange,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.surfaceVariant, width: 1),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Search app bar for search screens.
class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Search controller
  final TextEditingController? controller;

  /// Hint text
  final String hint;

  /// Callback when search text changes
  final ValueChanged<String>? onChanged;

  /// Callback when search is submitted
  final ValueChanged<String>? onSubmitted;

  /// Whether to show the back button
  final bool showBackButton;

  /// Callback when back button is pressed
  final VoidCallback? onBackPressed;

  /// Whether to auto-focus the search field
  final bool autoFocus;

  const SearchAppBar({
    super.key,
    this.controller,
    this.hint = 'Search tasks...',
    this.onChanged,
    this.onSubmitted,
    this.showBackButton = true,
    this.onBackPressed,
    this.autoFocus = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            if (showBackButton) ...[
              GestureDetector(
                onTap: onBackPressed ?? () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    borderRadius: AppRadius.borderRadiusSM,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: AppSizes.iconSM,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              AppSpacing.gapHorizontalSM,
            ],
            Expanded(
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: AppRadius.borderRadiusSM,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: AppSizes.iconMD,
                      color: colors.textHint,
                    ),
                    AppSpacing.gapHorizontalXS,
                    Expanded(
                      child: TextField(
                        controller: controller,
                        autofocus: autoFocus,
                        onChanged: onChanged,
                        onSubmitted: onSubmitted,
                        style: AppTypography.bodyMedium.copyWith(
                          color: colors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: hint,
                          hintStyle: AppTypography.bodyMedium.copyWith(
                            color: colors.textHint,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
