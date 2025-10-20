import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/utils/logger.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseService.auth;
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream of auth state changes
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      return user != null ? _mapFirebaseUserToUserModel(user) : null;
    });
  }

  // Get current user
  UserModel? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user != null ? _mapFirebaseUserToUserModel(user) : null;
  }

  // Sign in with email and password
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Sign in failed');
      }

      final userModel = _mapFirebaseUserToUserModel(credential.user!);
      await _updateUserInFirestore(userModel);
      
      AppLogger.info('User signed in successfully: ${userModel.email}');
      return userModel;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Sign in error: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      AppLogger.error('Unexpected sign in error: $e');
      throw Exception('Sign in failed. Please try again.');
    }
  }

  // Sign up with email and password
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Sign up failed');
      }

      // Update display name if provided
      if (displayName != null && displayName.isNotEmpty) {
        await credential.user!.updateDisplayName(displayName);
      }

      // Send email verification
      await credential.user!.sendEmailVerification();

      final userModel = _mapFirebaseUserToUserModel(credential.user!);
      await _createUserInFirestore(userModel);
      
      AppLogger.info('User signed up successfully: ${userModel.email}');
      return userModel;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Sign up error: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      AppLogger.error('Unexpected sign up error: $e');
      throw Exception('Sign up failed. Please try again.');
    }
  }

  // Sign in with Google
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final authResult = await _firebaseAuth.signInWithCredential(credential);
      
      if (authResult.user == null) {
        throw Exception('Google sign in failed');
      }

      final userModel = _mapFirebaseUserToUserModel(authResult.user!);
      
      // Check if this is a new user
      if (authResult.additionalUserInfo?.isNewUser == true) {
        await _createUserInFirestore(userModel);
      } else {
        await _updateUserInFirestore(userModel);
      }
      
      AppLogger.info('User signed in with Google: ${userModel.email}');
      return userModel;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Google sign in error: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      AppLogger.error('Unexpected Google sign in error: $e');
      throw Exception('Google sign in failed. Please try again.');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      
      AppLogger.info('User signed out successfully');
    } catch (e) {
      AppLogger.error('Sign out error: $e');
      throw Exception('Sign out failed. Please try again.');
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      AppLogger.info('Password reset email sent to: $email');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Password reset error: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      AppLogger.error('Unexpected password reset error: $e');
      throw Exception('Failed to send password reset email.');
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        AppLogger.info('Email verification sent to: ${user.email}');
      }
    } catch (e) {
      AppLogger.error('Email verification error: $e');
      throw Exception('Failed to send email verification.');
    }
  }

  // Update user profile
  Future<UserModel> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }

      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }

      await user.reload();
      final updatedUser = _firebaseAuth.currentUser!;
      final userModel = _mapFirebaseUserToUserModel(updatedUser);
      
      await _updateUserInFirestore(userModel);
      AppLogger.info('User profile updated successfully');
      
      return userModel;
    } catch (e) {
      AppLogger.error('Profile update error: $e');
      throw Exception('Failed to update profile.');
    }
  }

  // Private helper methods

  UserModel _mapFirebaseUserToUserModel(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime,
      lastSignIn: user.metadata.lastSignInTime,
    );
  }

  Future<void> _createUserInFirestore(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        ...user.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      AppLogger.warning('Failed to create user in Firestore: $e');
    }
  }

  Future<void> _updateUserInFirestore(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        ...user.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      AppLogger.warning('Failed to update user in Firestore: $e');
    }
  }

  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found with this email address.');
      case 'wrong-password':
        return Exception('Incorrect password.');
      case 'email-already-in-use':
        return Exception('An account already exists with this email address.');
      case 'weak-password':
        return Exception('Password should be at least 6 characters long.');
      case 'invalid-email':
        return Exception('Please enter a valid email address.');
      case 'user-disabled':
        return Exception('This account has been disabled.');
      case 'too-many-requests':
        return Exception('Too many failed attempts. Please try again later.');
      case 'operation-not-allowed':
        return Exception('This sign-in method is not allowed.');
      default:
        return Exception(e.message ?? 'An authentication error occurred.');
    }
  }
}