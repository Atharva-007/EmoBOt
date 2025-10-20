import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource firebaseAuthDatasource;

  AuthRepositoryImpl({required this.firebaseAuthDatasource});

  @override
  Future<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await firebaseAuthDatasource.signInWithEmailAndPassword(
      email,
      password,
    );
  }

  @override
  Future<UserEntity> createUserWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    return await firebaseAuthDatasource.createUserWithEmailAndPassword(
      email,
      password,
      displayName,
    );
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    return await firebaseAuthDatasource.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    return await firebaseAuthDatasource.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    return await firebaseAuthDatasource.resetPassword(email);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await firebaseAuthDatasource.getCurrentUser();
  }

  @override
  Future<void> updateUserProfile(UserEntity user) async {
    return await firebaseAuthDatasource.updateUserProfile(user);
  }

  @override
  Future<void> deleteUser() async {
    // Implementation would go here
    throw UnimplementedError('Delete user not implemented yet');
  }

  @override
  Future<void> sendEmailVerification() async {
    return await firebaseAuthDatasource.sendEmailVerification();
  }

  @override
  Future<void> verifyEmail(String code) async {
    // Implementation would go here
    throw UnimplementedError('Verify email not implemented yet');
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return firebaseAuthDatasource.authStateChanges;
  }

  @override
  bool get isAuthenticated => firebaseAuthDatasource.isAuthenticated;
}