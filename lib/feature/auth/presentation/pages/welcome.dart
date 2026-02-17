import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/shared.dart';
import 'login_page.dart';
import 'register_page.dart';

/// Welcome/onboarding page with full-screen hero illustration.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen background image
          Positioned.fill(
            child: Image.asset(
              "assets/images/let's_start.png",
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          // Content overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Push content to bottom
                  // const Spacer(),

                  // Headline
                  Text(
                    'Task Management &\nTo-Do List',
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineSmall.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Subtitle
                  Text(
                    'Organize, prioritize, and accomplish your\ntasks with ease. Start your productive journey.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      color: colors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Get Started button
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      showArrow: true,
                      label: "Let's Start",
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LoginPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Create account link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTypography.bodyMedium.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Sign Up',
                          style: AppTypography.bodyMedium.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

