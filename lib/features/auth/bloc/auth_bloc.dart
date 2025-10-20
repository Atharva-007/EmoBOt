import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';
import '../repositories/auth_repository.dart';
import '../../../core/utils/logger.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<dynamic>? _authStateSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthGoogleSignInRequested>(_onAuthGoogleSignInRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthPasswordResetRequested>(_onAuthPasswordResetRequested);
    on<AuthEmailVerificationRequested>(_onAuthEmailVerificationRequested);
    on<AuthUserUpdated>(_onAuthUserUpdated);
  }

  Future<void> _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    AppLogger.info('AuthBloc: Starting auth state monitoring');
    
    // Listen to auth state changes
    _authStateSubscription?.cancel();
    _authStateSubscription = _authRepository.authStateChanges.listen(
      (user) {
        if (user != null) {
          AppLogger.info('AuthBloc: User authenticated - ${user.email}');
          emit(AuthAuthenticated(user: user));
        } else {
          AppLogger.info('AuthBloc: User unauthenticated');
          emit(AuthUnauthenticated());
        }
      },
      onError: (error) {
        AppLogger.error('AuthBloc: Auth state stream error - $error');
        emit(AuthError(message: 'Authentication error occurred'));
      },
    );

    // Check initial auth state
    final currentUser = _authRepository.currentUser;
    if (currentUser != null) {
      emit(AuthAuthenticated(user: currentUser));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      AppLogger.info('AuthBloc: Sign in requested for ${event.email}');
      final user = await _authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      
      AppLogger.info('AuthBloc: Sign in successful');
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      AppLogger.error('AuthBloc: Sign in failed - $e');
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      AppLogger.info('AuthBloc: Sign up requested for ${event.email}');
      final user = await _authRepository.signUpWithEmailAndPassword(
        email: event.email,
        password: event.password,
        displayName: event.displayName,
      );
      
      AppLogger.info('AuthBloc: Sign up successful');
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      AppLogger.error('AuthBloc: Sign up failed - $e');
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      AppLogger.info('AuthBloc: Google sign in requested');
      final user = await _authRepository.signInWithGoogle();
      
      AppLogger.info('AuthBloc: Google sign in successful');
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      AppLogger.error('AuthBloc: Google sign in failed - $e');
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      AppLogger.info('AuthBloc: Sign out requested');
      await _authRepository.signOut();
      
      AppLogger.info('AuthBloc: Sign out successful');
      emit(AuthUnauthenticated());
    } catch (e) {
      AppLogger.error('AuthBloc: Sign out failed - $e');
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      AppLogger.info('AuthBloc: Password reset requested for ${event.email}');
      await _authRepository.sendPasswordResetEmail(event.email);
      
      AppLogger.info('AuthBloc: Password reset email sent');
      emit(AuthPasswordResetSent(email: event.email));
    } catch (e) {
      AppLogger.error('AuthBloc: Password reset failed - $e');
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthEmailVerificationRequested(
    AuthEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      AppLogger.info('AuthBloc: Email verification requested');
      await _authRepository.sendEmailVerification();
      
      AppLogger.info('AuthBloc: Email verification sent');
      emit(AuthEmailVerificationSent());
    } catch (e) {
      AppLogger.error('AuthBloc: Email verification failed - $e');
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      AppLogger.info('AuthBloc: User profile update requested');
      final user = await _authRepository.updateUserProfile(
        displayName: event.displayName,
        photoURL: event.photoURL,
      );
      
      AppLogger.info('AuthBloc: User profile updated successfully');
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      AppLogger.error('AuthBloc: User profile update failed - $e');
      emit(AuthError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}