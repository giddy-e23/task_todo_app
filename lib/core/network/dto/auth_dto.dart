/// User data from API
class UserDto {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final DateTime? emailVerifiedAt;
  final String? profilePictureUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserDto({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.emailVerifiedAt,
    this.profilePictureUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String?,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'] as String)
          : null,
      profilePictureUrl: json['profile_picture_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  String get fullName => '$firstName $lastName';

  /// Creates a copy of this UserDto with the given fields replaced with new values
  UserDto copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) {
    return UserDto(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailVerifiedAt: emailVerifiedAt,
      profilePictureUrl: profilePictureUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Request DTO for updating user profile
class UpdateProfileRequestDto {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;

  UpdateProfileRequestDto({
    this.firstName,
    this.lastName,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (firstName != null) json['first_name'] = firstName;
    if (lastName != null) json['last_name'] = lastName;
    if (phoneNumber != null) json['phone_number'] = phoneNumber;
    return json;
  }
}

/// Auth response from login/register
class AuthResponseDto {
  final String message;
  final String token;
  final UserDto? user;

  AuthResponseDto({
    required this.message,
    required this.token,
    this.user,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      message: json['message'] as String,
      token: json['token'] as String,
      user: json['user'] != null
          ? UserDto.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Login request body
class LoginRequestDto {
  final String email;
  final String password;

  LoginRequestDto({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

/// Register request body
class RegisterRequestDto {
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String password;
  final String passwordConfirmation;

  RegisterRequestDto({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        if (phoneNumber != null && phoneNumber!.isNotEmpty)
          'phone_number': phoneNumber,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };
}

/// Forgot password request
class ForgotPasswordRequestDto {
  final String email;

  ForgotPasswordRequestDto({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

/// Verify OTP and reset password request
class ResetPasswordRequestDto {
  final String email;
  final String otp;
  final String password;
  final String passwordConfirmation;

  ResetPasswordRequestDto({
    required this.email,
    required this.otp,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'otp': otp,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };
}

/// Change password request
class ChangePasswordRequestDto {
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  ChangePasswordRequestDto({
    required this.currentPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  Map<String, dynamic> toJson() => {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      };
}
