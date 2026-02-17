import 'package:logger/logger.dart';

/// Application-wide logger with structured output
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  
  late final Logger _logger;
  
  factory AppLogger() => _instance;
  
  AppLogger._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 3,
        errorMethodCount: 8,
        lineLength: 100,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: Level.debug,
    );
  }
  
  /// Log debug message
  void d(String message, [dynamic data]) {
    if (data != null) {
      _logger.d('$message\n$data');
    } else {
      _logger.d(message);
    }
  }
  
  /// Log info message
  void i(String message, [dynamic data]) {
    if (data != null) {
      _logger.i('$message\n$data');
    } else {
      _logger.i(message);
    }
  }
  
  /// Log warning message
  void w(String message, [dynamic data]) {
    if (data != null) {
      _logger.w('$message\n$data');
    } else {
      _logger.w(message);
    }
  }
  
  /// Log error with stack trace
  void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace ?? StackTrace.current);
  }
  
  /// Log HTTP request
  void request({
    required String method,
    required String path,
    required String url,
    Map<String, dynamic>? headers,
    dynamic data,
  }) {
    final buffer = StringBuffer()
      ..writeln('┌─────────────────────────────────────────────────────────────')
      ..writeln('│ 🌐 REQUEST [$method] => $path')
      ..writeln('│ URL: $url');
    
    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('│ Headers: ${_formatJson(headers)}');
    }
    
    if (data != null) {
      buffer.writeln('│ Body: ${_formatJson(data)}');
    }
    
    buffer.write('└─────────────────────────────────────────────────────────────');
    
    _logger.i(buffer.toString());
  }
  
  /// Log HTTP response
  void response({
    required int? statusCode,
    required String path,
    dynamic data,
    Duration? duration,
  }) {
    final isSuccess = statusCode != null && statusCode >= 200 && statusCode < 300;
    final emoji = isSuccess ? '✅' : '⚠️';
    
    final buffer = StringBuffer()
      ..writeln('┌─────────────────────────────────────────────────────────────')
      ..writeln('│ $emoji RESPONSE [$statusCode] => $path');
    
    if (duration != null) {
      buffer.writeln('│ Duration: ${duration.inMilliseconds}ms');
    }
    
    if (data != null) {
      final formattedData = _formatJson(data);
      // Truncate very long responses
      if (formattedData.length > 1000) {
        buffer.writeln('│ Data: ${formattedData.substring(0, 1000)}...[truncated]');
      } else {
        buffer.writeln('│ Data: $formattedData');
      }
    }
    
    buffer.write('└─────────────────────────────────────────────────────────────');
    
    if (isSuccess) {
      _logger.i(buffer.toString());
    } else {
      _logger.w(buffer.toString());
    }
  }
  
  /// Log HTTP error with stack trace
  void httpError({
    required int? statusCode,
    required String path,
    required String? message,
    dynamic responseData,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final buffer = StringBuffer()
      ..writeln('┌─────────────────────────────────────────────────────────────')
      ..writeln('│ ❌ ERROR [$statusCode] => $path')
      ..writeln('│ Message: $message');
    
    if (responseData != null) {
      buffer.writeln('│ Response: ${_formatJson(responseData)}');
    }
    
    buffer.write('└─────────────────────────────────────────────────────────────');
    
    _logger.e(buffer.toString(), error: error, stackTrace: stackTrace ?? StackTrace.current);
  }
  
  String _formatJson(dynamic data) {
    if (data == null) return 'null';
    if (data is Map || data is List) {
      return data.toString();
    }
    return data.toString();
  }
}

/// Global logger instance
final log = AppLogger();
