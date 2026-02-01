import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class TaskIcon extends StatelessWidget {
  const TaskIcon({
    super.key,
    required this.groupIcon,
    required this.iconColor,
  });

  final IconData? groupIcon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: ShapeDecoration(
        color: iconColor.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Icon(groupIcon ?? IconsaxPlusBold.briefcase, color: iconColor),
    );
  }
}