import 'package:isar/isar.dart';
import 'status_collection.dart';
import 'task_group_collection.dart';

part 'task_collection.g.dart';

/// Task collection - individual tasks
/// Maps to SQL: tasks table
@Collection()
class TaskCollection {
  Id id = Isar.autoIncrement;

  /// Server UUID - matches SQL tasks.id
  @Index(unique: true)
  late String serverId;

  /// User ID who owns this task
  @Index()
  late String userId;

  /// Task title
  late String title;

  /// Task description
  late String description;

  /// Start date/time
  @Index()
  late DateTime startDate;

  /// End date/time
  late DateTime endDate;

  /// Logo/icon identifier
  late String logo;

  /// Status server ID - references statuses table
  @Index()
  String? statusServerId;

  /// Completion timestamp
  DateTime? completedAt;

  /// Timestamps
  late DateTime createdAt;
  late DateTime updatedAt;

  /// Sync metadata
  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.pending;

  DateTime? lastSyncedAt;

  /// Link to task group
  final group = IsarLink<TaskGroupCollection>();

  /// Helper to check if task is completed
  @ignore
  bool get isCompleted => completedAt != null;

  /// Helper to check if task is overdue
  @ignore
  bool get isOverdue => !isCompleted && DateTime.now().isAfter(endDate);

  /// Helper to get remaining time
  @ignore
  Duration get remainingTime => endDate.difference(DateTime.now());

  /// Helper to check if task is due today
  @ignore
  bool get isDueToday {
    final now = DateTime.now();
    return startDate.year == now.year &&
        startDate.month == now.month &&
        startDate.day == now.day;
  }
}
