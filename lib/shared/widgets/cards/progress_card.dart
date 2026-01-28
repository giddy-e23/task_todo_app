import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../progress/circular_progress.dart';

/// A summary card showing task completion progress.
///
/// Example usage:
/// ```dart
/// ProgressSummaryCard(
///   title: 'Your today\'s task\nalmost done!',
///   progress: 0.85,
///   buttonLabel: 'View Task',
///   onButtonPressed: () {},
/// )
/// ```
class ProgressSummaryCard extends StatelessWidget {
  /// Card title text
  final String title;

  /// Progress value (0.0 - 1.0)
  final double progress;

  /// Button label
  final String buttonLabel;

  /// Callback when button is pressed
  final VoidCallback? onButtonPressed;

  /// Optional trailing widget (like a menu icon)
  final Widget? trailing;

  const ProgressSummaryCard({
    super.key,
    required this.title,
    required this.progress,
    this.buttonLabel = 'View Task',
    this.onButtonPressed,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppColorPalette.primaryGradient,
        borderRadius: AppRadius.borderRadiusLG,
        boxShadow: AppShadows.primaryGlow,
      ),
      child: Row(
        children: [
          // Left content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                AppSpacing.gapVerticalMD,
                // Button
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: onButtonPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: colors.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.borderRadiusSM,
                      ),
                      textStyle: AppTypography.labelMedium,
                    ),
                    child: Text(buttonLabel),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapHorizontalMD,
          // Progress circle
          Stack(
            alignment: Alignment.topRight,
            children: [
              CircularProgressWidget(
                progress: progress,
                size: AppSizes.progressCircleLarge,
                strokeWidth: 8,
                progressColor: Colors.white,
                trackColor: Colors.white.withOpacity(0.3),
                showPercentage: true,
                child: Text(
                  '${(progress * 100).round()}%',
                  style: AppTypography.percentage.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              if (trailing != null)
                Positioned(
                  top: -8,
                  right: -8,
                  child: trailing!,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
