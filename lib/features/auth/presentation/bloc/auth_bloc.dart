import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/utils/logger.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthSignInWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  
  const AuthSignInWithEmailRequested({
    required this.email,
    required this.password,
  });
  
  @override
  List<Object> get props => [email, password];
}

class AuthSignUpWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  final String displayName;
  
  const AuthSignUpWithEmailRequested({
    required this.email,
    required this.password,
    required this.displayName,
  });
  
  @override
  List<Object> get props => [email, password, displayName];
}

class AuthSignInWithGoogleRequested extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}

class AuthResetPasswordRequested extends AuthEvent {
  final String email;
  
  const AuthResetPasswordRequested({required this.email});
  
  @override
  List<Object> get props => [email];
}

class AuthUserChanged extends AuthEvent {
  final UserEntity? user;
  
  const AuthUserChanged({this.user});
  
  @override
  List<Object?> get props => [user];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  
  const AuthAuthenticated({required this.user});
  
  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  
  const AuthError({required this.message});
  
  @override
  List<Object> get props => [message];
}

class AuthPasswordResetSent extends AuthState {
  final String email;
  
  const AuthPasswordResetSent({required this.email});
  
  @override
  List<Object> get props => [email];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInWithEmailRequested>(_onSignInWithEmailRequested);
    on<AuthSignUpWithEmailRequested>(_onSignUpWithEmailRequested);
    on<AuthSignInWithGoogleRequested>(_onSignInWithGoogleRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthResetPasswordRequested>(_onResetPasswordRequested);
    on<AuthUserChanged>(_onUserChanged);
    
    // Listen to auth state changes
    authRepository.authStateChanges.listen((user) {
      add(AuthUserChanged(user: user));
    });
  }
  
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      AppLogger.error('Auth check error: $e');
      emit(AuthUnauthenticated());
    }
  }
  
  Future<void> _onSignInWithEmailRequested(
    AuthSignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      final user = await authRepository.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      
      emit(AuthAuthenticated(user: user));
      AppLogger.info('User signed in successfully: ${user.email}');
    } catch (e) {
      AppLogger.error('Sign in error: $e');
      emit(AuthError(message: e.toString()));
    }
  }
  
  Future<void> _onSignUpWithEmailRequested(
    AuthSignUpWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      final user = await authRepository.createUserWithEmailAndPassword(
        event.email,
        event.password,
        event.displayName,
      );
      
      emit(AuthAuthenticated(user: user));
      AppLogger.info('User signed up successfully: ${user.email}');
    } catch (e) {
      AppLogger.error('Sign up error: $e');
      emit(AuthError(message: e.toString()));
    }
  }
  
  Future<void> _onSignInWithGoogleRequested(
    AuthSignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      final user = await authRepository.signInWithGoogle();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
        AppLogger.info('User signed in with Google: ${user.email}');
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      AppLogger.error('Google sign in error: $e');
      emit(AuthError(message: e.toString()));
    }
  }
  
  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await authRepository.signOut();
      emit(AuthUnauthenticated());
      AppLogger.info('User signed out successfully');
    } catch (e) {
      AppLogger.error('Sign out error: $e');
      emit(AuthError(message: e.toString()));
    }
  }
  
  Future<void> _onResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      await authRepository.resetPassword(event.email);
      emit(AuthPasswordResetSent(email: event.email));
      AppLogger.info('Password reset email sent to: ${event.email}');
    } catch (e) {
      AppLogger.error('Reset password error: $e');
      emit(AuthError(message: e.toString()));
    }
  }
  
  void _onUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(AuthAuthenticated(user: event.user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }
}