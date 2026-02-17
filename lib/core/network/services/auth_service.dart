import 'package:dio/dio.dart';

import '../api_client.dart';
import '../api_endpoints.dart';
import '../dto/auth_dto.dart';
import 'token_repository.dart';

/// Service for authentication API operations
class AuthApiService {
  final ApiClient _apiClient;
  final TokenRepository _tokenRepository;

  AuthApiService({
    required ApiClient apiClient,
    required TokenRepository tokenRepository,
  })  : _apiClient = apiClient,
        _tokenRepository = tokenRepository;

  /// Register a new user
  /// Returns the auth response with token and user data
  Future<AuthResponseDto> register(RegisterRequestDto request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      final authResponse = AuthResponseDto.fromJson(response.data);

      // Save token and user ID
      await _tokenRepository.saveToken(authResponse.token);
      if (authResponse.user != null) {
        await _tokenRepository.saveUserId(authResponse.user!.id);
      }

      return authResponse;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Login with email and password
  /// Returns the auth response with token
  Future<AuthResponseDto> login(LoginRequestDto request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      final authResponse = AuthResponseDto.fromJson(response.data);

      // Save token
      await _tokenRepository.saveToken(authResponse.token);

      // Fetch user details after login
      final user = await getCurrentUser();
      await _tokenRepository.saveUserId(user.id);

      return authResponse;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get current authenticated user
  Future<UserDto> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.user);
      return UserDto.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Send forgot password OTP
  Future<String> forgotPassword(ForgotPasswordRequestDto request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.forgotPassword,
        data: request.toJson(),
      );
      return response.data['message'] as String;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Verify OTP and reset password
  Future<String> verifyAndResetPassword(ResetPasswordRequestDto request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.verifyAndResetPassword,
        data: request.toJson(),
      );
      return response.data['message'] as String;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Change password for authenticated user
  Future<String> changePassword(ChangePasswordRequestDto request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.changePassword,
        data: request.toJson(),
      );
      return response.data['message'] as String;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Logout - clear local token
  Future<void> logout() async {
    await _tokenRepository.clearAll();
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await _tokenRepository.hasToken();
  }
}
