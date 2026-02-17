/// Application configuration
abstract class AppConfig {
  /// API base URL
  String get baseUrl;

  /// Whether the app is in debug mode
  bool get isDebug;
}

/// Development configuration
class DevConfig implements AppConfig {
  @override
  String get baseUrl => 'http://192.168.1.199:8000/api'; // Local network IP for physical device

  @override
  bool get isDebug => true;
}

/// Production configuration
class ProdConfig implements AppConfig {
  @override
  String get baseUrl => 'https://your-production-server.com/api';

  @override
  bool get isDebug => false;
}

/// Current app configuration
/// Change this to ProdConfig() for production builds
final AppConfig appConfig = DevConfig();
