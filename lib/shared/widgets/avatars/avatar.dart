import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

/// User avatar widget with various size options and optional status indicator.
///
/// Example usage:
/// ```dart
/// AppAvatar(
///   imageUrl: user.photoUrl,
///   name: user.displayName,
///   size: AvatarSize.large,
///   showOnlineStatus: true,
///   isOnline: true,
/// )
/// ```
class AppAvatar extends StatelessWidget {
  /// Image URL for the avatar
  final String? imageUrl;

  /// User's name (used for initials if no image)
  final String? name;

  /// Avatar size
  final AvatarSize size;

  /// Background color when showing initials
  final Color? backgroundColor;

  /// Whether to show online status indicator
  final bool showOnlineStatus;

  /// Whether user is online (only shown if showOnlineStatus is true)
  final bool isOnline;

  /// Border color
  final Color? borderColor;

  /// Border width
  final double? borderWidth;

  /// Callback when avatar is tapped
  final VoidCallback? onTap;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AvatarSize.medium,
    this.backgroundColor,
    this.showOnlineStatus = false,
    this.isOnline = false,
    this.borderColor,
    this.borderWidth,
    this.onTap,
  });

  String get _initials {
    if (name == null || name!.isEmpty) return '?';
    final parts = name!.split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final dimension = size.dimension;
    final statusDimension = size.statusSize;
    final fontSize = size.fontSize;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: dimension,
            height: dimension,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor ?? colors.primaryContainer,
              border: borderColor != null || borderWidth != null
                  ? Border.all(
                      color: borderColor ?? colors.primary,
                      width: borderWidth ?? 2,
                    )
                  : null,
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl == null
                ? Center(
                    child: Text(
                      _initials,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: colors.primary,
                      ),
                    ),
                  )
                : null,
          ),
          if (showOnlineStatus)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: statusDimension,
                height: statusDimension,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOnline
                      ? AppColorPalette.categoryGreen
                      : colors.textDisabled,
                  border: Border.all(color: colors.surface, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Avatar sizes.
enum AvatarSize {
  /// Extra small - 24px
  xs(24, 8, 10),

  /// Small - 32px
  small(32, 10, 12),

  /// Medium - 40px (default)
  medium(40, 12, 14),

  /// Large - 56px
  large(56, 14, 18),

  /// Extra large - 72px
  xl(72, 18, 24),

  /// XXL - 96px
  xxl(96, 20, 32);

  final double dimension;
  final double statusSize;
  final double fontSize;

  const AvatarSize(this.dimension, this.statusSize, this.fontSize);
}

/// Row of overlapping avatars showing multiple users.
///
/// Example usage:
/// ```dart
/// AvatarStack(
///   avatars: [
///     AvatarData(imageUrl: 'url1'),
///     AvatarData(imageUrl: 'url2', name: 'John'),
///     AvatarData(name: 'Jane'),
///   ],
///   maxVisible: 3,
///   onTap: () => showAllMembers(),
/// )
/// ```
class AvatarStack extends StatelessWidget {
  /// List of avatar data
  final List<AvatarData> avatars;

  /// Maximum number of visible avatars
  final int maxVisible;

  /// Size of each avatar
  final AvatarSize size;

  /// Overlap amount (0.0 to 1.0)
  final double overlapFactor;

  /// Callback when stack is tapped
  final VoidCallback? onTap;

  const AvatarStack({
    super.key,
    required this.avatars,
    this.maxVisible = 3,
    this.size = AvatarSize.small,
    this.overlapFactor = 0.3,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final visibleAvatars = avatars.take(maxVisible).toList();
    final extraCount = avatars.length - maxVisible;
    final dimension = size.dimension;
    final overlap = dimension * overlapFactor;
    final totalWidth =
        dimension +
        (visibleAvatars.length - 1 + (extraCount > 0 ? 1 : 0)) *
            (dimension - overlap);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: totalWidth,
        height: dimension,
        child: Stack(
          children: [
            ...List.generate(visibleAvatars.length, (index) {
              return Positioned(
                left: index * (dimension - overlap),
                child: AppAvatar(
                  imageUrl: visibleAvatars[index].imageUrl,
                  name: visibleAvatars[index].name,
                  size: size,
                  borderColor: colors.surface,
                  borderWidth: 2,
                ),
              );
            }),
            if (extraCount > 0)
              Positioned(
                left: visibleAvatars.length * (dimension - overlap),
                child: Container(
                  width: dimension,
                  height: dimension,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.primary,
                    border: Border.all(color: colors.surface, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '+$extraCount',
                      style: TextStyle(
                        fontSize: size.fontSize - 2,
                        fontWeight: FontWeight.w600,
                        color: AppColorPalette.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Data class for avatar in AvatarStack.
class AvatarData {
  final String? imageUrl;
  final String? name;

  const AvatarData({this.imageUrl, this.name});
}

/// Profile avatar with edit capability.
class EditableAvatar extends StatelessWidget {
  /// Current image URL
  final String? imageUrl;

  /// User's name
  final String? name;

  /// Avatar size
  final AvatarSize size;

  /// Callback when edit is tapped
  final VoidCallback? onEditTap;

  const EditableAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AvatarSize.xxl,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Stack(
      children: [
        AppAvatar(imageUrl: imageUrl, name: name, size: size),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: onEditTap,
            child: Container(
              width: size.statusSize * 2,
              height: size.statusSize * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary,
                border: Border.all(color: colors.surface, width: 2),
              ),
              child: Icon(
                Icons.camera_alt,
                size: size.statusSize,
                color: AppColorPalette.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
