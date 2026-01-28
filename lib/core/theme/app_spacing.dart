import 'package:flutter/material.dart';

/// Consistent spacing values based on 4px grid system.
///
/// Usage:
/// ```dart
/// Padding(
///   padding: AppSpacing.paddingMD,
///   child: ...
/// )
///
/// SizedBox(height: AppSpacing.md)
///
/// // Or use gap widgets
/// Column(
///   children: [
///     Text('First'),
///     AppSpacing.gapVerticalMD,
///     Text('Second'),
///   ],
/// )
/// ```
abstract class AppSpacing {
  // Base unit (4px grid)
  static const double unit = 4.0;

  // ============== Spacing Values ==============
  static const double xxs = unit; // 4
  static const double xs = unit * 2; // 8
  static const double sm = unit * 3; // 12
  static const double md = unit * 4; // 16
  static const double lg = unit * 5; // 20
  static const double xl = unit * 6; // 24
  static const double xxl = unit * 8; // 32
  static const double xxxl = unit * 10; // 40
  static const double huge = unit * 12; // 48
  static const double massive = unit * 16; // 64

  // ============== Common Padding Presets ==============
  static const EdgeInsets paddingXXS = EdgeInsets.all(xxs);
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);

  // ============== Horizontal Padding ==============
  static const EdgeInsets paddingHorizontalXS = EdgeInsets.symmetric(
    horizontal: xs,
  );
  static const EdgeInsets paddingHorizontalSM = EdgeInsets.symmetric(
    horizontal: sm,
  );
  static const EdgeInsets paddingHorizontalMD = EdgeInsets.symmetric(
    horizontal: md,
  );
  static const EdgeInsets paddingHorizontalLG = EdgeInsets.symmetric(
    horizontal: lg,
  );
  static const EdgeInsets paddingHorizontalXL = EdgeInsets.symmetric(
    horizontal: xl,
  );
  static const EdgeInsets paddingHorizontalXXL = EdgeInsets.symmetric(
    horizontal: xxl,
  );

  // ============== Vertical Padding ==============
  static const EdgeInsets paddingVerticalXS = EdgeInsets.symmetric(
    vertical: xs,
  );
  static const EdgeInsets paddingVerticalSM = EdgeInsets.symmetric(
    vertical: sm,
  );
  static const EdgeInsets paddingVerticalMD = EdgeInsets.symmetric(
    vertical: md,
  );
  static const EdgeInsets paddingVerticalLG = EdgeInsets.symmetric(
    vertical: lg,
  );
  static const EdgeInsets paddingVerticalXL = EdgeInsets.symmetric(
    vertical: xl,
  );
  static const EdgeInsets paddingVerticalXXL = EdgeInsets.symmetric(
    vertical: xxl,
  );

  // ============== Screen/Page Padding ==============
  /// Standard screen horizontal padding (20px)
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: lg);

  /// Screen padding with top space
  static const EdgeInsets screenPaddingWithTop = EdgeInsets.only(
    left: lg,
    right: lg,
    top: md,
  );

  /// Full screen padding (horizontal + vertical)
  static const EdgeInsets screenPaddingAll = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  // ============== Card Padding ==============
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets cardPaddingLG = EdgeInsets.all(lg);

  // ============== List Item Padding ==============
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  // ============== Gap Widgets ==============
  // Use these as children in Row/Column for spacing
  static const SizedBox gapXXS = SizedBox(width: xxs, height: xxs);
  static const SizedBox gapXS = SizedBox(width: xs, height: xs);
  static const SizedBox gapSM = SizedBox(width: sm, height: sm);
  static const SizedBox gapMD = SizedBox(width: md, height: md);
  static const SizedBox gapLG = SizedBox(width: lg, height: lg);
  static const SizedBox gapXL = SizedBox(width: xl, height: xl);
  static const SizedBox gapXXL = SizedBox(width: xxl, height: xxl);

  // ============== Horizontal Gaps ==============
  static const SizedBox gapHorizontalXXS = SizedBox(width: xxs);
  static const SizedBox gapHorizontalXS = SizedBox(width: xs);
  static const SizedBox gapHorizontalSM = SizedBox(width: sm);
  static const SizedBox gapHorizontalMD = SizedBox(width: md);
  static const SizedBox gapHorizontalLG = SizedBox(width: lg);
  static const SizedBox gapHorizontalXL = SizedBox(width: xl);

  // ============== Vertical Gaps ==============
  static const SizedBox gapVerticalXXS = SizedBox(height: xxs);
  static const SizedBox gapVerticalXS = SizedBox(height: xs);
  static const SizedBox gapVerticalSM = SizedBox(height: sm);
  static const SizedBox gapVerticalMD = SizedBox(height: md);
  static const SizedBox gapVerticalLG = SizedBox(height: lg);
  static const SizedBox gapVerticalXL = SizedBox(height: xl);
  static const SizedBox gapVerticalXXL = SizedBox(height: xxl);
  static const SizedBox gapVerticalXXXL = SizedBox(height: xxxl);
  static const SizedBox gapVerticalHuge = SizedBox(height: huge);
}

/// Border radius constants from design system.
abstract class AppRadius {
  static const double none = 0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 10.0; // Used for cards in the design
  static const double lg = 14.0; // Used for main screens
  static const double xl = 16.0;
  static const double xxl = 20.0;
  static const double xxxl = 24.0;
  static const double full = 999.0;

  // ============== BorderRadius Presets ==============
  static const BorderRadius borderRadiusNone = BorderRadius.zero;
  static const BorderRadius borderRadiusXS = BorderRadius.all(
    Radius.circular(xs),
  );
  static const BorderRadius borderRadiusSM = BorderRadius.all(
    Radius.circular(sm),
  );
  static const BorderRadius borderRadiusMD = BorderRadius.all(
    Radius.circular(md),
  );
  static const BorderRadius borderRadiusLG = BorderRadius.all(
    Radius.circular(lg),
  );
  static const BorderRadius borderRadiusXL = BorderRadius.all(
    Radius.circular(xl),
  );
  static const BorderRadius borderRadiusXXL = BorderRadius.all(
    Radius.circular(xxl),
  );
  static const BorderRadius borderRadiusXXXL = BorderRadius.all(
    Radius.circular(xxxl),
  );
  static const BorderRadius borderRadiusFull = BorderRadius.all(
    Radius.circular(full),
  );

  // ============== Top Radius (for bottom sheets, modals) ==============
  static const BorderRadius borderRadiusTopMD = BorderRadius.vertical(
    top: Radius.circular(md),
  );
  static const BorderRadius borderRadiusTopLG = BorderRadius.vertical(
    top: Radius.circular(lg),
  );
  static const BorderRadius borderRadiusTopXL = BorderRadius.vertical(
    top: Radius.circular(xl),
  );
  static const BorderRadius borderRadiusTopXXL = BorderRadius.vertical(
    top: Radius.circular(xxl),
  );
  static const BorderRadius borderRadiusTopXXXL = BorderRadius.vertical(
    top: Radius.circular(xxxl),
  );
}

/// Common sizes for icons, buttons, and other UI elements.
abstract class AppSizes {
  // ============== Icon Sizes ==============
  static const double iconXS = 16.0;
  static const double iconSM = 20.0;
  static const double iconMD = 24.0;
  static const double iconLG = 28.0;
  static const double iconXL = 32.0;
  static const double iconXXL = 48.0;

  // ============== Button Heights ==============
  static const double buttonHeightSM = 36.0;
  static const double buttonHeightMD = 44.0;
  static const double buttonHeightLG = 52.0;
  static const double buttonHeightXL = 56.0;

  // ============== Button Widths ==============
  static const double buttonMinWidth = 120.0;

  // ============== Input Field Sizes ==============
  static const double inputHeight = 48.0;
  static const double inputHeightLG = 56.0;

  // ============== Avatar Sizes ==============
  static const double avatarXS = 24.0;
  static const double avatarSM = 32.0;
  static const double avatarMD = 40.0;
  static const double avatarLG = 48.0;
  static const double avatarXL = 56.0;
  static const double avatarXXL = 80.0;

  // ============== FAB Sizes ==============
  static const double fabSize = 56.0;
  static const double fabSizeMini = 40.0;

  // ============== Card Sizes ==============
  static const double taskCardHeight = 100.0;
  static const double taskGroupCardHeight = 70.0;

  // ============== Progress Indicator Sizes ==============
  static const double progressCircleSmall = 40.0;
  static const double progressCircleMedium = 60.0;
  static const double progressCircleLarge = 80.0;
  static const double progressStrokeWidth = 6.0;

  // ============== Calendar Sizes ==============
  static const double calendarDaySize = 48.0;
  static const double calendarDaySizeSelected = 48.0;

  // ============== Bottom Navigation ==============
  static const double bottomNavHeight = 80.0;
  static const double bottomNavIconSize = 24.0;

  // ============== Touch Target ==============
  /// Minimum touch target size for accessibility (48dp)
  static const double minTouchTarget = 48.0;

  // ============== App Bar ==============
  static const double appBarHeight = 56.0;
  static const double appBarHeightLarge = 96.0;

  // ============== Tab Bar ==============
  static const double tabBarHeight = 44.0;

  // ============== Divider ==============
  static const double dividerThickness = 1.0;
}
