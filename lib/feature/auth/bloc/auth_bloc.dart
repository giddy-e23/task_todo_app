import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/dto/auth_dto.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Authentication BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<CheckAuthRequested>(_onCheckAuth);
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<LogoutRequested>(_onLogout);
    on<ForgotPasswordRequested>(_onForgotPassword);
    on<ResetPasswordRequested>(_onResetPassword);
    on<UpdateProfileRequested>(_onUpdateProfile);
  }

  Future<void> _onCheckAuth(
    CheckAuthRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final isAuthenticated = await authApiService.isAuthenticated();

      if (isAuthenticated) {
        // Try to fetch user data
        try {
          final user = await authApiService.getCurrentUser();
          emit(Authenticated(user));
        } catch (e) {
          // Token might be invalid, clear it
          await authApiService.logout();
          emit(const Unauthenticated());
        }
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      emit(const Unauthenticated());
    }
  }

  Future<void> _onLogin(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final request = LoginRequestDto(
        email: event.email,
        password: event.password,
      );

      await authApiService.login(request);
      final user = await authApiService.getCurrentUser();
      emit(Authenticated(user));
    } on ApiException catch (e) {
      emit(AuthError(
        message: e.message,
        validationErrors: e.validationErrors,
      ));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRegister(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final request = RegisterRequestDto(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        phoneNumber: event.phoneNumber,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
      );

      final response = await authApiService.register(request);

      if (response.user != null) {
        emit(Authenticated(response.user!));
      } else {
        // Fetch user if not in response
        final user = await authApiService.getCurrentUser();
        emit(Authenticated(user));
      }
    } on ApiException catch (e) {
      emit(AuthError(
        message: e.message,
        validationErrors: e.validationErrors,
      ));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    await authApiService.logout();
    emit(const Unauthenticated());
  }

  Future<void> _onForgotPassword(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    // This is handled separately - doesn't change auth state
    // The UI should handle the response via a separate mechanism
  }

  Future<void> _onResetPassword(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    // This is handled separately - doesn't change auth state
    // The UI should handle the response via a separate mechanism
  }

  Future<void> _onUpdateProfile(
    UpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Store current state to restore on error
    final currentState = state;

    emit(const AuthLoading());

    try {
      final request = UpdateProfileRequestDto(
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phoneNumber,
      );

      final updatedUser = await authApiService.updateProfile(request);
      emit(Authenticated(updatedUser));
    } on ApiException catch (e) {
      // Restore previous state and emit error
      if (currentState is Authenticated) {
        emit(currentState);
      }
      emit(AuthError(
        message: e.message,
        validationErrors: e.validationErrors,
      ));
    } catch (e) {
      if (currentState is Authenticated) {
        emit(currentState);
      }
      emit(AuthError(message: e.toString()));
    }
  }
}
