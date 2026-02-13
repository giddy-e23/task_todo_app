import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';
import 'package:task_todo_app/shared/custom_app_background.dart';
import 'package:task_todo_app/shared/widgets/avatars/avatar.dart';
import 'package:task_todo_app/shared/widgets/buttons/app_button.dart';
import 'package:task_todo_app/shared/widgets/cards/stat_card.dart';
import 'package:task_todo_app/shared/widgets/lists/settings_row.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Sample user data
  static const String _userName = 'Alex Johnson';
  static const String _userEmail = 'alex.johnson@email.com';
  static const String? _userAvatar = null; // Uses initials if null

  // Sample stats
  static const int _totalProjects = 12;
  static const int _completedTasks = 48;
  static const int _inProgressTasks = 7;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: CustomAppBackground(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildHeader(colors),
              ),

              const SizedBox(height: 32),

              // User profile section
              _buildProfileSection(context, colors),

              const SizedBox(height: 28),

              // Statistics row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildStatsRow(colors),
              ),

              const SizedBox(height: 28),

              // Settings menu
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildSettingsMenu(context, colors),
              ),

              const SizedBox(height: 24),

              // Logout button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildLogoutButton(context, colors),
              ),

              const SizedBox(height: 100), // Bottom padding for nav bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppColorsLight colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Profile',
          style: AppTypography.headlineLarge.copyWith(
            color: colors.textPrimary,
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              IconsaxPlusLinear.setting_2,
              color: colors.textPrimary,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(BuildContext context, AppColorsLight colors) {
    return Center(
      child: Column(
        children: [
          // Avatar
          AppAvatar(
            imageUrl: _userAvatar,
            name: _userName,
            size: AvatarSize.xxl,
            borderColor: colors.primary,
            borderWidth: 3,
          ),

          const SizedBox(height: 16),

          // User name
          Text(
            _userName,
            style: AppTypography.headlineSmall.copyWith(
              color: colors.textPrimary,
            ),
          ),

          const SizedBox(height: 4),

          // User email
          Text(
            _userEmail,
            style: AppTypography.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),

          const SizedBox(height: 16),

          // Edit profile button
          AppButton.secondary(
            label: 'Edit Profile',
            size: AppButtonSize.small,
            leadingIcon: IconsaxPlusLinear.edit_2,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(AppColorsLight colors) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: IconsaxPlusBold.folder_2,
            iconColor: colors.primary,
            count: _totalProjects,
            label: 'Projects',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            icon: IconsaxPlusBold.tick_circle,
            iconColor: colors.success,
            count: _completedTasks,
            label: 'Completed',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            icon: IconsaxPlusBold.clock,
            iconColor: colors.warning,
            count: _inProgressTasks,
            label: 'In Progress',
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsMenu(BuildContext context, AppColorsLight colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SettingsRow(
            icon: IconsaxPlusLinear.user,
            label: 'Account Settings',
            onTap: () {},
          ),
          _buildDivider(colors),
          SettingsRow(
            icon: IconsaxPlusLinear.notification,
            label: 'Notifications',
            onTap: () {},
          ),
          _buildDivider(colors),
          SettingsRow(
            icon: IconsaxPlusLinear.brush_1,
            label: 'Appearance',
            value: 'Light',
            onTap: () {},
          ),
          _buildDivider(colors),
          SettingsRow(
            icon: IconsaxPlusLinear.message_question,
            label: 'Help & Support',
            onTap: () {},
          ),
          _buildDivider(colors),
          SettingsRow(
            icon: IconsaxPlusLinear.info_circle,
            label: 'About',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(AppColorsLight colors) {
    return Divider(
      height: 1,
      thickness: 1,
      color: colors.divider,
      indent: 58,
    );
  }

  Widget _buildLogoutButton(BuildContext context, AppColorsLight colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SettingsRow(
        icon: IconsaxPlusLinear.logout,
        label: 'Log Out',
        isDestructive: true,
        showChevron: false,
        onTap: () {
          _showLogoutDialog(context, colors);
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppColorsLight colors) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Log Out',
          style: AppTypography.titleLarge.copyWith(
            color: colors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: AppTypography.bodyMedium.copyWith(
            color: colors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTypography.labelLarge.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout logic here
            },
            child: Text(
              'Log Out',
              style: AppTypography.labelLarge.copyWith(
                color: colors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
