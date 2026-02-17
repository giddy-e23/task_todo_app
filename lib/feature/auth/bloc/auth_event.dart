import 'package:equatable/equatable.dart';

/// Auth events
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Check if user is authenticated on app start
class CheckAuthRequested extends AuthEvent {
  const CheckAuthRequested();
}

/// Login event
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Register event
class RegisterRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String password;
  final String passwordConfirmation;

  const RegisterRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        phoneNumber,
        password,
        passwordConfirmation,
      ];
}

/// Logout event
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// Forgot password event
class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Reset password with OTP event
class ResetPasswordRequested extends AuthEvent {
  final String email;
  final String otp;
  final String password;
  final String passwordConfirmation;

  const ResetPasswordRequested({
    required this.email,
    required this.otp,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object?> get props => [email, otp, password, passwordConfirmation];
}
