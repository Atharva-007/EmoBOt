import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../features/auth/models/user_model.dart';

class UserAvatar extends StatelessWidget {
  final UserModel user;
  final double size;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    required this.user,
    this.size = 40,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget avatar = CircleAvatar(
      radius: size / 2,
      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
      child: user.photoURL != null && user.photoURL!.isNotEmpty
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: user.photoURL!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.primary,
                ),
                errorWidget: (context, url, error) => _buildDefaultAvatar(theme),
              ),
            )
          : _buildDefaultAvatar(theme),
    );

    if (onTap != null) {
      avatar = GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return avatar;
  }

  Widget _buildDefaultAvatar(ThemeData theme) {
    final initials = _getInitials();
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size / 2.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getInitials() {
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      final names = user.displayName!.split(' ');
      if (names.length >= 2) {
        return '${names[0][0]}${names[1][0]}'.toUpperCase();
      } else if (names.isNotEmpty) {
        return names[0][0].toUpperCase();
      }
    }
    
    // Fallback to email
    if (user.email.isNotEmpty) {
      return user.email[0].toUpperCase();
    }
    
    return 'U';
  }
}