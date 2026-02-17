import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../core/theme/theme.dart';
import '../../../../shared/shared.dart';
import '../../bloc/bloc.dart';

/// Registration page with full form
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            RegisterRequested(
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              email: _emailController.text.trim(),
              phoneNumber: _phoneController.text.trim().isEmpty
                  ? null
                  : _phoneController.text.trim(),
              password: _passwordController.text,
              passwordConfirmation: _confirmPasswordController.text,
            ),
          );
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(IconsaxPlusLinear.arrow_left, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final authError = state is AuthError ? state : null;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'Create Account',
                      style: AppTypography.headlineMedium.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Start organizing your tasks today',
                      style: AppTypography.bodyMedium.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // First Name field
                    AppTextField(
                      label: 'First Name',
                      hint: 'Enter your first name',
                      controller: _firstNameController,
                      prefixIcon: IconsaxPlusLinear.user,
                      enabled: !isLoading,
                      errorText: authError?.getFieldError('first_name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Last Name field
                    AppTextField(
                      label: 'Last Name',
                      hint: 'Enter your last name',
                      controller: _lastNameController,
                      prefixIcon: IconsaxPlusLinear.user,
                      enabled: !isLoading,
                      errorText: authError?.getFieldError('last_name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Email field
                    AppTextField(
                      label: 'Email',
                      hint: 'Enter your email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: IconsaxPlusLinear.sms,
                      enabled: !isLoading,
                      errorText: authError?.getFieldError('email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Phone field (optional)
                    AppTextField(
                      label: 'Phone Number (Optional)',
                      hint: 'Enter your phone number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: IconsaxPlusLinear.call,
                      enabled: !isLoading,
                      errorText: authError?.getFieldError('phone_number'),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Password field
                    AppTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      prefixIcon: IconsaxPlusLinear.lock,
                      suffixIcon: _obscurePassword
                          ? IconsaxPlusLinear.eye_slash
                          : IconsaxPlusLinear.eye,
                      onSuffixTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      enabled: !isLoading,
                      errorText: authError?.getFieldError('password'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Password must be at least 8 characters with mixed case, numbers, and symbols',
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Confirm Password field
                    AppTextField(
                      label: 'Confirm Password',
                      hint: 'Confirm your password',
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      prefixIcon: IconsaxPlusLinear.lock,
                      suffixIcon: _obscureConfirmPassword
                          ? IconsaxPlusLinear.eye_slash
                          : IconsaxPlusLinear.eye,
                      onSuffixTap: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      enabled: !isLoading,
                      errorText: authError?.getFieldError('password_confirmation'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Register button
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: 'Create Account',
                        onPressed: isLoading ? null : _onRegister,
                        isLoading: isLoading,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: AppTypography.bodyMedium.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: isLoading ? null : _navigateToLogin,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Sign In',
                            style: AppTypography.bodyMedium.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
