import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:task_todo_app/core/di/injection.dart';
import 'package:task_todo_app/core/network/api_client.dart';
import 'package:task_todo_app/core/network/dto/auth_dto.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';
import 'package:task_todo_app/feature/auth/bloc/bloc.dart';
import 'package:task_todo_app/feature/profile/edit_profile_page.dart';
import 'package:task_todo_app/shared/custom_app_background.dart';
import 'package:task_todo_app/shared/widgets/avatars/avatar.dart';
import 'package:task_todo_app/shared/widgets/buttons/app_button.dart';
import 'package:task_todo_app/shared/widgets/cards/stat_card.dart';
import 'package:task_todo_app/shared/widgets/inputs/app_text_field.dart';
import 'package:task_todo_app/shared/widgets/lists/settings_row.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _totalProjects = 0;
  int _completedTasks = 0;
  int _inProgressTasks = 0;
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoadingStats = true);

    try {
      // Fetch all task groups
      final groups = await taskApiService.getAllTaskGroups();
      
      // Fetch tasks for each group
      int totalCompleted = 0;
      int totalInProgress = 0;
      
      for (final group in groups) {
        try {
          final tasks = await taskApiService.getAllTasksForGroup(group.id);
          for (final task in tasks) {
            if (task.status.status == 'Done') {
              totalCompleted++;
            } else if (task.status.status == 'In Progress') {
              totalInProgress++;
            }
          }
        } catch (_) {
          // Continue with other groups
        }
      }

      if (mounted) {
        setState(() {
          _totalProjects = groups.length;
          _completedTasks = totalCompleted;
          _inProgressTasks = totalInProgress;
          _isLoadingStats = false;
        });
      }
    } on ApiException catch (_) {
      if (mounted) {
        setState(() => _isLoadingStats = false);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingStats = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: CustomAppBackground(
        child: RefreshIndicator(
          onRefresh: _loadStats,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String userName = 'Guest User';
        String userEmail = 'guest@example.com';
        String? userAvatar;

        if (state is Authenticated) {
          userName = state.user.fullName;
          userEmail = state.user.email;
          userAvatar = state.user.profilePictureUrl;
        }

        return Center(
          child: Column(
            children: [
              // Avatar
              AppAvatar(
                imageUrl: userAvatar,
                name: userName,
                size: AvatarSize.xxl,
                borderColor: colors.primary,
                borderWidth: 3,
              ),

              const SizedBox(height: 16),

              // User name
              Text(
                userName,
                style: AppTypography.headlineSmall.copyWith(
                  color: colors.textPrimary,
                ),
              ),

              const SizedBox(height: 4),

              // User email
              Text(
                userEmail,
                style: AppTypography.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
              ),

              const SizedBox(height: 16),

              // Edit profile button
              AppButton.secondary(
                label: 'Edit Profile',
                size: AppButtonSize.small,
                fullWidth: false,
                leadingIcon: IconsaxPlusLinear.edit_2,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsRow(AppColorsLight colors) {
    if (_isLoadingStats) {
      return Row(
        children: [
          Expanded(child: _buildStatSkeleton(colors)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatSkeleton(colors)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatSkeleton(colors)),
        ],
      );
    }

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

  Widget _buildStatSkeleton(AppColorsLight colors) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colors.primary,
          ),
        ),
      ),
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
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account settings coming soon')),
              );
            },
          ),
          _buildDivider(colors),
          SettingsRow(
            icon: IconsaxPlusLinear.lock,
            label: 'Change Password',
            onTap: () => _showChangePasswordDialog(context, colors),
          ),
          _buildDivider(colors),
          SettingsRow(
            icon: IconsaxPlusLinear.notification,
            label: 'Notifications',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications settings coming soon')),
              );
            },
          ),
          _buildDivider(colors),
          SettingsRow(
            icon: IconsaxPlusLinear.brush_1,
            label: 'Appearance',
            value: 'Light',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme switcher coming soon')),
              );
            },
          ),
          _buildDivider(colors),
          SettingsRow(
            icon: IconsaxPlusLinear.message_question,
            label: 'Help & Support',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help & Support coming soon')),
              );
            },
          ),
          _buildDivider(colors),
          SettingsRow(
            icon: IconsaxPlusLinear.info_circle,
            label: 'About',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Task Todo App',
                applicationVersion: '1.0.0',
                applicationIcon: Icon(
                  IconsaxPlusBold.task_square,
                  size: 48,
                  color: colors.primary,
                ),
                children: [
                  const Text('A beautiful task management app built with Flutter.'),
                ],
              );
            },
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
      builder: (dialogContext) => AlertDialog(
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
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: AppTypography.labelLarge.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Dispatch logout event
              context.read<AuthBloc>().add(const LogoutRequested());
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

  void _showChangePasswordDialog(BuildContext context, AppColorsLight colors) {
    final formKey = GlobalKey<FormState>();
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isLoading = false;
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Change Password',
            style: AppTypography.titleLarge.copyWith(
              color: colors.textPrimary,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    label: 'Current Password',
                    hint: 'Enter current password',
                    controller: currentPasswordController,
                    obscureText: obscureCurrent,
                    prefixIcon: IconsaxPlusLinear.lock,
                    suffixIcon: obscureCurrent
                        ? IconsaxPlusLinear.eye_slash
                        : IconsaxPlusLinear.eye,
                    onSuffixTap: () {
                      setDialogState(() => obscureCurrent = !obscureCurrent);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Current password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'New Password',
                    hint: 'Enter new password',
                    controller: newPasswordController,
                    obscureText: obscureNew,
                    prefixIcon: IconsaxPlusLinear.lock_1,
                    suffixIcon: obscureNew
                        ? IconsaxPlusLinear.eye_slash
                        : IconsaxPlusLinear.eye,
                    onSuffixTap: () {
                      setDialogState(() => obscureNew = !obscureNew);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'New password is required';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Confirm Password',
                    hint: 'Confirm new password',
                    controller: confirmPasswordController,
                    obscureText: obscureConfirm,
                    prefixIcon: IconsaxPlusLinear.lock_1,
                    suffixIcon: obscureConfirm
                        ? IconsaxPlusLinear.eye_slash
                        : IconsaxPlusLinear.eye,
                    onSuffixTap: () {
                      setDialogState(() => obscureConfirm = !obscureConfirm);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Password must contain at least 8 characters, including uppercase, lowercase, numbers, and symbols.',
                    style: AppTypography.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: AppTypography.labelLarge.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;

                      setDialogState(() => isLoading = true);

                      try {
                        final request = ChangePasswordRequestDto(
                          currentPassword: currentPasswordController.text,
                          newPassword: newPasswordController.text,
                          newPasswordConfirmation: confirmPasswordController.text,
                        );

                        await authApiService.changePassword(request);

                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Password changed successfully'),
                              backgroundColor: colors.success,
                            ),
                          );
                        }
                      } on ApiException catch (e) {
                        setDialogState(() => isLoading = false);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.message),
                              backgroundColor: colors.error,
                            ),
                          );
                        }
                      } catch (e) {
                        setDialogState(() => isLoading = false);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to change password: $e'),
                              backgroundColor: colors.error,
                            ),
                          );
                        }
                      }
                    },
              child: isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.primary,
                      ),
                    )
                  : Text(
                      'Change',
                      style: AppTypography.labelLarge.copyWith(
                        color: colors.primary,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
