/// Paginated response wrapper
class PaginatedResponse<T> {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String? nextPageUrl;
  final String? prevPageUrl;

  PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  bool get hasNextPage => nextPageUrl != null;
  bool get hasPrevPage => prevPageUrl != null;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    // Handle both direct pagination and nested under "task_groups" key
    final paginationData = json['task_groups'] ?? json;

    final List<dynamic> dataList = paginationData['data'] as List<dynamic>;

    return PaginatedResponse(
      data: dataList
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      currentPage: paginationData['current_page'] as int? ?? 1,
      lastPage: paginationData['last_page'] as int? ?? 1,
      perPage: paginationData['per_page'] as int? ?? 10,
      total: paginationData['total'] as int? ?? dataList.length,
      nextPageUrl: paginationData['next_page_url'] as String?,
      prevPageUrl: paginationData['prev_page_url'] as String?,
    );
  }
}

/// Task groups response with nested tasks pagination
class TaskGroupDetailResponse {
  final Map<String, dynamic> taskGroup;
  final PaginatedTasksResponse tasks;

  TaskGroupDetailResponse({
    required this.taskGroup,
    required this.tasks,
  });

  factory TaskGroupDetailResponse.fromJson(Map<String, dynamic> json) {
    return TaskGroupDetailResponse(
      taskGroup: json['task_groups'] as Map<String, dynamic>,
      tasks: PaginatedTasksResponse.fromJson(json['tasks']),
    );
  }
}

/// Paginated tasks with meta format
class PaginatedTasksResponse {
  final List<Map<String, dynamic>> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginatedTasksResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  bool get hasNextPage => currentPage < lastPage;

  factory PaginatedTasksResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'] as List<dynamic>;
    final meta = json['meta'] as Map<String, dynamic>?;

    return PaginatedTasksResponse(
      data: dataList.map((item) => item as Map<String, dynamic>).toList(),
      currentPage: meta?['current_page'] as int? ?? 1,
      lastPage: meta?['last_page'] as int? ?? 1,
      perPage: meta?['per_page'] as int? ?? 10,
      total: meta?['total'] as int? ?? dataList.length,
    );
  }
}
