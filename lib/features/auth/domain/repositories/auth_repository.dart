import '../entities/user_entity.dart';

abstract class AuthRepository {
  // Authentication methods
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
  Future<UserEntity> createUserWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  );
  Future<UserEntity?> signInWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword(String email);
  
  // User management
  Future<UserEntity?> getCurrentUser();
  Future<void> updateUserProfile(UserEntity user);
  Future<void> deleteUser();
  
  // Email verification
  Future<void> sendEmailVerification();
  Future<void> verifyEmail(String code);
  
  // Auth state
  Stream<UserEntity?> get authStateChanges;
  bool get isAuthenticated;
}