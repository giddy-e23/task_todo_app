import 'package:get_it/get_it.dart';

import '../database/database.dart';

/// Global service locator instance
final getIt = GetIt.instance;

/// Initialize all dependencies
/// Call this after AppDatabase.initialize() in main()
Future<void> initializeDependencies() async {
  // Register repositories as lazy singletons
  getIt.registerLazySingleton<StatusRepository>(() => StatusRepository());
  getIt.registerLazySingleton<UserRepository>(() => UserRepository());
  getIt.registerLazySingleton<TaskGroupRepository>(() => TaskGroupRepository());
  getIt.registerLazySingleton<TaskRepository>(() => TaskRepository());
}

/// Reset all dependencies (for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}

/// Convenience getters for repositories
StatusRepository get statusRepository => getIt<StatusRepository>();
UserRepository get userRepository => getIt<UserRepository>();
TaskGroupRepository get taskGroupRepository => getIt<TaskGroupRepository>();
TaskRepository get taskRepository => getIt<TaskRepository>();
