import 'package:flutter/material.dart';

class CustomAppBackground extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  
  const CustomAppBackground({
    super.key,
    required this.child,
    this.padding,
  });

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
            opacity: const AlwaysStoppedAnimation(0.2), // Adjust opacity as needed
          ),
        ),

        // Content overlay
        SafeArea(
          child: padding != null
              ? Padding(
                  padding: padding!,
                  child: child,
                )
              : child,
        ),
      ],
    );
  }
}
