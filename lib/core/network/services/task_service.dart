import 'package:dio/dio.dart';

import '../api_client.dart';
import '../api_endpoints.dart';
import '../dto/dto.dart';

/// Service for task-related API operations
class TaskApiService {
  final ApiClient _apiClient;

  TaskApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Create a new task
  /// If the task group doesn't exist, it will be created automatically
  Future<CreateTaskResponseDto> createTask(CreateTaskRequestDto request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.createTask,
        data: request.toJson(),
      );
      return CreateTaskResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Update task status
  Future<TaskDto> updateTaskStatus(UpdateTaskStatusRequestDto request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.updateTaskStatus,
        data: request.toJson(),
      );
      return TaskDto.fromJson(response.data['task']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get all available task statuses
  Future<List<StatusDto>> getStatuses() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.getStatuses);
      final data = response.data['data'] as List<dynamic>;
      return data.map((json) => StatusDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get all task groups (paginated)
  Future<PaginatedResponse<TaskGroupDto>> getTaskGroups({int page = 1}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.getTaskGroups,
        queryParameters: {'page': page},
      );
      return PaginatedResponse.fromJson(
        response.data,
        (json) => TaskGroupDto.fromJson(json),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get all task groups (fetch all pages)
  Future<List<TaskGroupDto>> getAllTaskGroups() async {
    final List<TaskGroupDto> allGroups = [];
    int currentPage = 1;
    bool hasMore = true;

    while (hasMore) {
      final response = await getTaskGroups(page: currentPage);
      allGroups.addAll(response.data);
      hasMore = response.hasNextPage;
      currentPage++;
    }

    return allGroups;
  }

  /// Get a single task group with its tasks (paginated)
  Future<TaskGroupDetailResponse> getTaskGroupWithTasks(
    String taskGroupId, {
    int page = 1,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.getTaskGroupDetail(taskGroupId),
        queryParameters: {'page': page},
      );
      return TaskGroupDetailResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get all tasks for a task group (fetch all pages)
  Future<List<TaskDto>> getAllTasksForGroup(String taskGroupId) async {
    final List<TaskDto> allTasks = [];
    int currentPage = 1;
    bool hasMore = true;

    while (hasMore) {
      final response = await getTaskGroupWithTasks(taskGroupId, page: currentPage);
      final tasks = response.tasks.data.map((json) => TaskDto.fromJson(json)).toList();
      allTasks.addAll(tasks);
      hasMore = response.tasks.hasNextPage;
      currentPage++;
    }

    return allTasks;
  }
}
