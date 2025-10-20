import 'package:flutter/material.dart';

/// A reusable widget for displaying user profile avatars with proper null handling
/// Shows a default user icon when the image URL is null, empty, or fails to load
class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final Color? backgroundColor;
  final Color? iconColor;
  final IconData fallbackIcon;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.radius = 20,
    this.backgroundColor,
    this.iconColor,
    this.fallbackIcon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? Colors.grey[300];
    final effectiveIconColor = iconColor ?? Colors.grey[600];

    // Check if imageUrl is valid
    final hasValidUrl = imageUrl != null && imageUrl!.isNotEmpty;

    return CircleAvatar(
      radius: radius,
      backgroundColor: effectiveBackgroundColor,
      backgroundImage: hasValidUrl ? NetworkImage(imageUrl!) : null,
      onBackgroundImageError: hasValidUrl ? (_, __) {} : null,
      child: hasValidUrl
          ? null
          : Icon(
              fallbackIcon,
              color: effectiveIconColor,
              size: radius * 0.8,
            ),
    );
  }
}
