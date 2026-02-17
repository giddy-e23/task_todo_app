/// API endpoint constants
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String register = '/register';
  static const String login = '/login';
  static const String forgotPassword = '/forgotPassword';
  static const String verifyAndResetPassword = '/verifyAndResetPassword';
  static const String changePassword = '/changePassword';

  // User
  static const String user = '/user';

  // Tasks
  static const String createTask = '/createTask';
  static const String updateTaskStatus = '/updateTaskStatus';
  static const String getTaskGroups = '/getTaskGroups';

  /// Get task group with tasks: /getTaskGroups/{taskGroupId}
  static String getTaskGroupDetail(String taskGroupId) =>
      '/getTaskGroups/$taskGroupId';
}
