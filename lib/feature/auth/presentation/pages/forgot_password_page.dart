import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/dto/auth_dto.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/shared.dart';

/// Forgot password page with OTP verification
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailFormKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _otpSent = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  Map<String, List<String>>? _validationErrors;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _getFieldError(String field) {
    return _validationErrors?[field]?.firstOrNull;
  }

  Future<void> _sendOtp() async {
    if (!(_emailFormKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _validationErrors = null;
    });

    try {
      final request = ForgotPasswordRequestDto(
        email: _emailController.text.trim(),
      );
      await authApiService.forgotPassword(request);

      if (mounted) {
        setState(() {
          _otpSent = true;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent to your email'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _validationErrors = e.validationErrors;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _resetPassword() async {
    if (!(_resetFormKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _validationErrors = null;
    });

    try {
      final request = ResetPasswordRequestDto(
        email: _emailController.text.trim(),
        otp: _otpController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );
      await authApiService.verifyAndResetPassword(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Go back to login
        Navigator.of(context).pop();
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _validationErrors = e.validationErrors;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                _otpSent ? 'Reset Password' : 'Forgot Password',
                style: AppTypography.headlineMedium.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _otpSent
                    ? 'Enter the OTP sent to your email and your new password'
                    : 'Enter your email to receive a password reset OTP',
                style: AppTypography.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Error message
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                  child: Row(
                    children: [
                      Icon(IconsaxPlusLinear.warning_2, color: colors.error),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: AppTypography.bodySmall.copyWith(
                            color: colors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Email form (step 1)
              if (!_otpSent) ...[
                Form(
                  key: _emailFormKey,
                  child: Column(
                    children: [
                      AppTextField(
                        label: 'Email',
                        hint: 'Enter your email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: IconsaxPlusLinear.sms,
                        enabled: !_isLoading,
                        errorText: _getFieldError('email'),
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
                      const SizedBox(height: AppSpacing.xxl),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          label: 'Send OTP',
                          onPressed: _isLoading ? null : _sendOtp,
                          isLoading: _isLoading,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Reset form (step 2)
              if (_otpSent) ...[
                Form(
                  key: _resetFormKey,
                  child: Column(
                    children: [
                      // Email (read-only)
                      AppTextField(
                        label: 'Email',
                        controller: _emailController,
                        prefixIcon: IconsaxPlusLinear.sms,
                        readOnly: true,
                        enabled: false,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // OTP field
                      AppTextField(
                        label: 'OTP Code',
                        hint: 'Enter 6-digit OTP',
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        prefixIcon: IconsaxPlusLinear.shield_tick,
                        enabled: !_isLoading,
                        errorText: _getFieldError('otp'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the OTP';
                          }
                          if (value.length != 6) {
                            return 'OTP must be 6 digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // New password
                      AppTextField(
                        label: 'New Password',
                        hint: 'Enter new password',
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
                        enabled: !_isLoading,
                        errorText: _getFieldError('password'),
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
                      const SizedBox(height: AppSpacing.lg),

                      // Confirm password
                      AppTextField(
                        label: 'Confirm Password',
                        hint: 'Confirm new password',
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
                        enabled: !_isLoading,
                        errorText: _getFieldError('password_confirmation'),
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

                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          label: 'Reset Password',
                          onPressed: _isLoading ? null : _resetPassword,
                          isLoading: _isLoading,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Resend OTP
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                setState(() {
                                  _otpSent = false;
                                  _otpController.clear();
                                  _passwordController.clear();
                                  _confirmPasswordController.clear();
                                });
                              },
                        child: Text(
                          'Resend OTP',
                          style: AppTypography.bodyMedium.copyWith(
                            color: colors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
