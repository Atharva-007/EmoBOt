import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_entity.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/services/firebase_service.dart';

class FirebaseAuthDatasource {
  final FirebaseAuth _firebaseAuth = FirebaseService.auth;
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in with email and password
  Future<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        return await _getUserFromFirebase(credential.user!);
      } else {
        throw Exception('Failed to sign in');
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase auth error: ${e.code}');
      throw _handleAuthException(e);
    } catch (e) {
      AppLogger.error('Sign in error: $e');
      throw Exception('Failed to sign in: $e');
    }
  }

  // Create user with email and password
  Future<UserEntity> createUserWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        // Update display name
        await credential.user!.updateDisplayName(displayName);
        
        // Create user profile in Firestore
        final userEntity = UserEntity(
          uid: credential.user!.uid,
          email: email,
          displayName: displayName,
          isEmailVerified: credential.user!.emailVerified,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        await _createUserProfile(userEntity);
        return userEntity;
      } else {
        throw Exception('Failed to create user');
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase auth error: ${e.code}');
      throw _handleAuthException(e);
    } catch (e) {
      AppLogger.error('Create user error: $e');
      throw Exception('Failed to create user: $e');
    }
  }

  // Sign in with Google
  Future<UserEntity?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return null; // User cancelled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        return await _getUserFromFirebase(userCredential.user!);
      } else {
        throw Exception('Failed to sign in with Google');
      }
    } catch (e) {
      AppLogger.error('Google sign in error: $e');
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      AppLogger.error('Sign out error: $e');
      throw Exception('Failed to sign out: $e');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Reset password error: ${e.code}');
      throw _handleAuthException(e);
    } catch (e) {
      AppLogger.error('Reset password error: $e');
      throw Exception('Failed to reset password: $e');
    }
  }

  // Get current user
  Future<UserEntity?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        return await _getUserFromFirebase(user);
      }
      return null;
    } catch (e) {
      AppLogger.error('Get current user error: $e');
      return null;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserEntity userEntity) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        // Update Firebase Auth profile
        await user.updateDisplayName(userEntity.displayName);
        
        // Update Firestore profile
        await _firestore.collection('users').doc(userEntity.uid).update({
          'displayName': userEntity.displayName,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      AppLogger.error('Update user profile error: $e');
      throw Exception('Failed to update user profile: $e');
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      AppLogger.error('Send email verification error: $e');
      throw Exception('Failed to send email verification: $e');
    }
  }

  // Auth state changes stream
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user != null) {
        return await _getUserFromFirebase(user);
      }
      return null;
    });
  }

  // Check if authenticated
  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  // Private helper methods
  Future<UserEntity> _getUserFromFirebase(User firebaseUser) async {
    try {
      final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      
      if (doc.exists) {
        final data = doc.data()!;
        return UserEntity(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? data['displayName'] ?? '',
          profileImageUrl: firebaseUser.photoURL ?? data['profileImageUrl'],
          role: UserRole.values.firstWhere(
            (role) => role.toString() == 'UserRole.${data['role'] ?? 'user'}',
            orElse: () => UserRole.user,
          ),
          isActive: data['isActive'] ?? true,
          isEmailVerified: firebaseUser.emailVerified,
          createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
          updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
          lastLoginAt: (data['lastLoginAt'] as Timestamp?)?.toDate(),
          metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
        );
      } else {
        // Create basic user profile if it doesn't exist
        final userEntity = UserEntity(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
          profileImageUrl: firebaseUser.photoURL,
          isEmailVerified: firebaseUser.emailVerified,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        await _createUserProfile(userEntity);
        return userEntity;
      }
    } catch (e) {
      AppLogger.error('Get user from Firebase error: $e');
      throw Exception('Failed to get user data: $e');
    }
  }

  Future<void> _createUserProfile(UserEntity userEntity) async {
    try {
      await _firestore.collection('users').doc(userEntity.uid).set({
        'uid': userEntity.uid,
        'email': userEntity.email,
        'displayName': userEntity.displayName,
        'profileImageUrl': userEntity.profileImageUrl,
        'role': userEntity.role.toString().split('.').last,
        'isActive': userEntity.isActive,
        'isEmailVerified': userEntity.isEmailVerified,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'metadata': userEntity.metadata,
      });
    } catch (e) {
      AppLogger.error('Create user profile error: $e');
      throw Exception('Failed to create user profile: $e');
    }
  }

  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No account found with this email');
      case 'wrong-password':
        return Exception('Incorrect password');
      case 'email-already-in-use':
        return Exception('This email is already registered');
      case 'weak-password':
        return Exception('Password is too weak');
      case 'invalid-email':
        return Exception('Invalid email address');
      case 'user-disabled':
        return Exception('This account has been disabled');
      case 'too-many-requests':
        return Exception('Too many failed attempts. Please try again later');
      case 'network-request-failed':
        return Exception('Network error. Please check your connection');
      default:
        return Exception(e.message ?? 'Authentication failed');
    }
  }
}