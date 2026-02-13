import 'package:flutter/material.dart';
import 'package:task_todo_app/core/theme/app_spacing.dart';

class CustomAppBackground extends StatelessWidget {
  final Widget child;
  const CustomAppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Full-screen background image
        Positioned.fill(
          child: Image.asset(
            "assets/images/background.png",
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),

        // Content overlay
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: child,
          ),
        ),
      ],
    );
  }
}
