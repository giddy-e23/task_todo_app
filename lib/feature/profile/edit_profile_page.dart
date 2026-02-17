import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';
import 'package:task_todo_app/feature/auth/bloc/bloc.dart';
import 'package:task_todo_app/shared/custom_app_background.dart';
import 'package:task_todo_app/shared/widgets/avatars/avatar.dart';
import 'package:task_todo_app/shared/widgets/buttons/app_button.dart';
import 'package:task_todo_app/shared/widgets/inputs/app_text_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final state = context.read<AuthBloc>().state;
    if (state is Authenticated) {
      _firstNameController.text = state.user.firstName;
      _lastNameController.text = state.user.lastName;
      _phoneController.text = state.user.phoneNumber ?? '';
    }

    // Listen for changes
    _firstNameController.addListener(_onFieldChanged);
    _lastNameController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final state = context.read<AuthBloc>().state;
    if (state is Authenticated) {
      final hasChanges = _firstNameController.text != state.user.firstName ||
          _lastNameController.text != state.user.lastName ||
          _phoneController.text != (state.user.phoneNumber ?? '');

      if (hasChanges != _hasChanges) {
        setState(() => _hasChanges = hasChanges);
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_hasChanges) return;

    setState(() => _isLoading = true);

    final state = context.read<AuthBloc>().state;
    if (state is! Authenticated) return;

    // Only send changed fields
    String? firstName;
    String? lastName;
    String? phoneNumber;

    if (_firstNameController.text != state.user.firstName) {
      firstName = _firstNameController.text;
    }
    if (_lastNameController.text != state.user.lastName) {
      lastName = _lastNameController.text;
    }
    if (_phoneController.text != (state.user.phoneNumber ?? '')) {
      phoneNumber = _phoneController.text.isEmpty ? null : _phoneController.text;
    }

    context.read<AuthBloc>().add(UpdateProfileRequested(
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated && _isLoading) {
          setState(() {
            _isLoading = false;
            _hasChanges = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile updated successfully'),
              backgroundColor: colors.success,
            ),
          );
          Navigator.pop(context);
        } else if (state is AuthError && _isLoading) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: colors.error,
            ),
          );
        }
      },
      child: Scaffold(
        body: CustomAppBackground(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Header with back button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildHeader(colors),
                ),

                const SizedBox(height: 32),

                // Avatar section
                _buildAvatarSection(colors),

                const SizedBox(height: 32),

                // Form fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildForm(colors),
                ),

                const SizedBox(height: 32),

                // Save button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildSaveButton(colors),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppColorsLight colors) {
    return Row(
      children: [
        // Back button
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              IconsaxPlusLinear.arrow_left,
              color: colors.textPrimary,
              size: 22,
            ),
          ),
        ),

        const SizedBox(width: 16),

        Text(
          'Edit Profile',
          style: AppTypography.headlineLarge.copyWith(
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarSection(AppColorsLight colors) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String userName = 'Guest User';
        String? userAvatar;

        if (state is Authenticated) {
          userName = state.user.fullName;
          userAvatar = state.user.profilePictureUrl;
        }

        return Center(
          child: Stack(
            children: [
              AppAvatar(
                imageUrl: userAvatar,
                name: userName,
                size: AvatarSize.xxl,
                borderColor: colors.primary,
                borderWidth: 3,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.surface,
                      width: 3,
                    ),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Photo upload coming soon'),
                        ),
                      );
                    },
                    icon: Icon(
                      IconsaxPlusBold.camera,
                      color: colors.onPrimary,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildForm(AppColorsLight colors) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            label: 'First Name',
            hint: 'Enter your first name',
            controller: _firstNameController,
            prefixIcon: IconsaxPlusLinear.user,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'First name is required';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          AppTextField(
            label: 'Last Name',
            hint: 'Enter your last name',
            controller: _lastNameController,
            prefixIcon: IconsaxPlusLinear.user,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Last name is required';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Email (read-only)
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              String email = '';
              if (state is Authenticated) {
                email = state.user.email;
              }
              return AppTextField(
                label: 'Email',
                hint: 'Your email address',
                controller: TextEditingController(text: email),
                prefixIcon: IconsaxPlusLinear.sms,
                readOnly: true,
                enabled: false,
              );
            },
          ),

          const SizedBox(height: 20),

          AppTextField(
            label: 'Phone Number',
            hint: 'Enter your phone number (optional)',
            controller: _phoneController,
            prefixIcon: IconsaxPlusLinear.call,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(AppColorsLight colors) {
    return AppButton(
      label: _isLoading ? 'Saving...' : 'Save Changes',
      isLoading: _isLoading,
      onPressed: _hasChanges && !_isLoading ? _saveProfile : null,
    );
  }
}
