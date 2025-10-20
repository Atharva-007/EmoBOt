import 'package:equatable/equatable.dart';

enum UserRole {
  superAdmin,
  admin,
  manager,
  moderator,
  user,
  guest,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.admin:
        return 'Administrator';
      case UserRole.manager:
        return 'Manager';
      case UserRole.moderator:
        return 'Moderator';
      case UserRole.user:
        return 'User';
      case UserRole.guest:
        return 'Guest';
    }
  }
  
  int get level {
    switch (this) {
      case UserRole.superAdmin:
        return 100;
      case UserRole.admin:
        return 80;
      case UserRole.manager:
        return 60;
      case UserRole.moderator:
        return 40;
      case UserRole.user:
        return 20;
      case UserRole.guest:
        return 10;
    }
  }
  
  bool hasPermission(UserRole requiredRole) {
    return level >= requiredRole.level;
  }
}

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final String? profileImageUrl;
  final UserRole role;
  final bool isActive;
  final bool isEmailVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;
  final Map<String, dynamic> metadata;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.displayName,
    this.profileImageUrl,
    this.role = UserRole.user,
    this.isActive = true,
    this.isEmailVerified = false,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
    this.metadata = const {},
  });

  UserEntity copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? profileImageUrl,
    UserRole? role,
    bool? isActive,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? metadata,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        profileImageUrl,
        role,
        isActive,
        isEmailVerified,
        createdAt,
        updatedAt,
        lastLoginAt,
        metadata,
      ];
}