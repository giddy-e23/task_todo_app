/// Task status info from API (embedded in task response)
class TaskStatusDto {
  final String status;
  final String color;

  TaskStatusDto({
    required this.status,
    required this.color,
  });

  factory TaskStatusDto.fromJson(Map<String, dynamic> json) {
    return TaskStatusDto(
      status: json['status'] as String,
      color: json['color'] as String,
    );
  }
}

/// Status definition from /getStatuses endpoint
class StatusDto {
  final String id;
  final String name;
  final String hexColor;
  final int displayOrder;

  StatusDto({
    required this.id,
    required this.name,
    required this.hexColor,
    required this.displayOrder,
  });

  factory StatusDto.fromJson(Map<String, dynamic> json) {
    return StatusDto(
      id: json['id'] as String,
      name: json['name'] as String,
      hexColor: json['hex_color'] as String,
      displayOrder: json['display_order'] as int,
    );
  }
}

/// Task group from API
class TaskGroupDto {
  final String id;
  final String userId;
  final String name;
  final String hexColor;
  final String? icon;
  final double completed;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskGroupDto({
    required this.id,
    required this.userId,
    required this.name,
    required this.hexColor,
    this.icon,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskGroupDto.fromJson(Map<String, dynamic> json) {
    // Handle human-readable dates like "2 hours ago" or ISO format
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is String) {
        // Try parsing as ISO date first
        try {
          return DateTime.parse(value);
        } catch (_) {
          // If it's human-readable, just use current time
          return DateTime.now();
        }
      }
      return DateTime.now();
    }

    return TaskGroupDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      hexColor: (json['hex_color'] ?? json['color'] ?? '#000000') as String,
      icon: json['icon'] as String?,
      completed: double.tryParse(json['completed'].toString()) ?? 0.0,
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }
}

/// Task dates from API
class TaskDatesDto {
  final DateTime startDate;
  final DateTime endDate;

  TaskDatesDto({
    required this.startDate,
    required this.endDate,
  });

  factory TaskDatesDto.fromJson(Map<String, dynamic> json) {
    return TaskDatesDto(
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
    );
  }
}

/// Task from API
class TaskDto {
  final String taskId;
  final String taskName;
  final String? taskDescription;
  final TaskDatesDto dates;
  final String? logo;
  final String createdAt;
  final String updatedAt;
  final TaskStatusDto status;
  final TaskGroupDto group;

  TaskDto({
    required this.taskId,
    required this.taskName,
    this.taskDescription,
    required this.dates,
    this.logo,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.group,
  });

  factory TaskDto.fromJson(Map<String, dynamic> json) {
    return TaskDto(
      taskId: json['task_id'] as String,
      taskName: json['task_name'] as String,
      taskDescription: json['task_description'] as String?,
      dates: TaskDatesDto.fromJson(json['dates'] as Map<String, dynamic>),
      logo: json['logo'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      status: TaskStatusDto.fromJson(json['status'] as Map<String, dynamic>),
      group: TaskGroupDto.fromJson(json['group'] as Map<String, dynamic>),
    );
  }
}

/// Create task request
class CreateTaskRequestDto {
  final String groupName;
  final String groupColor;
  final String? groupIcon;
  final String taskName;
  final String? taskDescription;
  final DateTime startDate;
  final DateTime endDate;
  final String? logo;

  CreateTaskRequestDto({
    required this.groupName,
    required this.groupColor,
    this.groupIcon,
    required this.taskName,
    this.taskDescription,
    required this.startDate,
    required this.endDate,
    this.logo,
  });

  Map<String, dynamic> toJson() => {
        'group_name': groupName,
        'group_color': groupColor,
        if (groupIcon != null) 'group_icon': groupIcon,
        'task_name': taskName,
        if (taskDescription != null) 'task_description': taskDescription,
        'start_date': _formatDate(startDate),
        'end_date': _formatDate(endDate),
        if (logo != null) 'logo': logo,
      };

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

/// Update task status request
class UpdateTaskStatusRequestDto {
  final String taskId;
  final String statusId;

  UpdateTaskStatusRequestDto({
    required this.taskId,
    required this.statusId,
  });

  Map<String, dynamic> toJson() => {
        'task_id': taskId,
        'status_id': statusId,
      };
}

/// Create task response
class CreateTaskResponseDto {
  final String message;
  final TaskDto task;

  CreateTaskResponseDto({
    required this.message,
    required this.task,
  });

  factory CreateTaskResponseDto.fromJson(Map<String, dynamic> json) {
    return CreateTaskResponseDto(
      message: json['message'] as String,
      task: TaskDto.fromJson(json['task'] as Map<String, dynamic>),
    );
  }
}
