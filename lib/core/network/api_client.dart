import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import 'services/token_repository.dart';

/// API client singleton for making HTTP requests
class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;
  final TokenRepository _tokenRepository;

  ApiClient._internal(this._tokenRepository) {
    _dio = Dio(
      BaseOptions(
        baseUrl: appConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  factory ApiClient(TokenRepository tokenRepository) {
    _instance ??= ApiClient._internal(tokenRepository);
    return _instance!;
  }

  /// Reset the singleton instance (useful for testing)
  static void resetInstance() {
    _instance = null;
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Attach auth token if available
          final token = await _tokenRepository.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          if (appConfig.isDebug) {
            debugPrint('🌐 REQUEST[${options.method}] => PATH: ${options.path}');
            debugPrint('📦 DATA: ${options.data}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (appConfig.isDebug) {
            debugPrint(
              '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
            );
          }
          return handler.next(response);
        },
        onError: (error, handler) async {
          if (appConfig.isDebug) {
            debugPrint(
              '❌ ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
            );
            debugPrint('📛 MESSAGE: ${error.message}');
            debugPrint('📛 DATA: ${error.response?.data}');
          }

          // Handle 401 Unauthorized - clear token
          if (error.response?.statusCode == 401) {
            await _tokenRepository.clearToken();
            // The app should handle navigation to login via AuthBloc
          }

          return handler.next(error);
        },
      ),
    );
  }
}

/// Exception for API errors with structured error data
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, List<String>>? validationErrors;

  ApiException({
    required this.message,
    this.statusCode,
    this.validationErrors,
  });

  factory ApiException.fromDioError(DioException error) {
    final response = error.response;
    final data = response?.data;

    String message = 'An error occurred';
    Map<String, List<String>>? validationErrors;

    if (data is Map<String, dynamic>) {
      message = data['message'] ?? message;

      // Parse validation errors (422)
      if (data['errors'] != null && data['errors'] is Map) {
        validationErrors = {};
        final errors = data['errors'] as Map<String, dynamic>;
        errors.forEach((key, value) {
          if (value is List) {
            validationErrors![key] = value.cast<String>();
          }
        });
      }
    }

    return ApiException(
      message: message,
      statusCode: response?.statusCode,
      validationErrors: validationErrors,
    );
  }

  @override
  String toString() => message;

  /// Get first error for a specific field
  String? getFieldError(String field) {
    return validationErrors?[field]?.firstOrNull;
  }

  /// Get all field errors as a flat list
  List<String> get allErrors {
    if (validationErrors == null) return [message];
    return validationErrors!.values.expand((e) => e).toList();
  }
}
