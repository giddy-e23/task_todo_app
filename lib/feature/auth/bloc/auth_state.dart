import 'package:equatable/equatable.dart';

import '../../../core/network/dto/auth_dto.dart';

/// Auth states
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state - checking auth status
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state - during login/register/checking
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated state - user is logged in
class Authenticated extends AuthState {
  final UserDto user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user.id];
}

/// Unauthenticated state - user needs to login
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// Auth error state - with error message and validation errors
class AuthError extends AuthState {
  final String message;
  final Map<String, List<String>>? validationErrors;

  const AuthError({
    required this.message,
    this.validationErrors,
  });

  /// Get first error for a specific field
  String? getFieldError(String field) {
    return validationErrors?[field]?.firstOrNull;
  }

  @override
  List<Object?> get props => [message, validationErrors];
}
