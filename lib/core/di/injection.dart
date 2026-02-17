import 'package:get_it/get_it.dart';

import '../database/database.dart';
import '../network/network.dart';

/// Global service locator instance
final getIt = GetIt.instance;

/// Initialize all dependencies
/// Call this after AppDatabase.initialize() in main()
Future<void> initializeDependencies() async {
  // Network layer
  getIt.registerLazySingleton<TokenRepository>(() => TokenRepository());
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(getIt<TokenRepository>()),
  );
  getIt.registerLazySingleton<AuthApiService>(
    () => AuthApiService(
      apiClient: getIt<ApiClient>(),
      tokenRepository: getIt<TokenRepository>(),
    ),
  );
  getIt.registerLazySingleton<TaskApiService>(
    () => TaskApiService(apiClient: getIt<ApiClient>()),
  );

  // Local database repositories
  getIt.registerLazySingleton<StatusRepository>(() => StatusRepository());
  getIt.registerLazySingleton<UserRepository>(() => UserRepository());
  getIt.registerLazySingleton<TaskGroupRepository>(() => TaskGroupRepository());
  getIt.registerLazySingleton<TaskRepository>(() => TaskRepository());
}

/// Reset all dependencies (for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
  ApiClient.resetInstance();
}

/// Convenience getters for network services
TokenRepository get tokenRepository => getIt<TokenRepository>();
ApiClient get apiClient => getIt<ApiClient>();
AuthApiService get authApiService => getIt<AuthApiService>();
TaskApiService get taskApiService => getIt<TaskApiService>();

/// Convenience getters for repositories
StatusRepository get statusRepository => getIt<StatusRepository>();
UserRepository get userRepository => getIt<UserRepository>();
TaskGroupRepository get taskGroupRepository => getIt<TaskGroupRepository>();
TaskRepository get taskRepository => getIt<TaskRepository>();
