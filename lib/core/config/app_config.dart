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
  String get baseUrl => 'http://10.0.2.2:8000/api'; // Android emulator localhost

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
