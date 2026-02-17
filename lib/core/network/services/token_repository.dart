import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Repository for secure token storage
class TokenRepository {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  final FlutterSecureStorage _storage;

  TokenRepository({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  /// Save authentication token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Get stored token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Check if token exists
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear stored token
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Save current user ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  /// Get stored user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// Clear user ID
  Future<void> clearUserId() async {
    await _storage.delete(key: _userIdKey);
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
