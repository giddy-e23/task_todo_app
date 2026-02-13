import 'package:isar/isar.dart';
import 'status_collection.dart';
import 'task_collection.dart';

part 'task_group_collection.g.dart';

/// TaskGroup collection - groups/categories for tasks
/// Maps to SQL: task_groups table
@Collection()
class TaskGroupCollection {
  Id id = Isar.autoIncrement;

  /// Server UUID - matches SQL task_groups.id
  @Index(unique: true)
  late String serverId;

  /// User ID who owns this group
  @Index()
  late String userId;

  /// Group name (e.g., "Work", "Personal", "Design")
  @Index()
  late String name;

  /// Color as hex string (e.g., "#7C3AED")
  late String hexColor;

  /// Icon identifier (icon name or code point)
  String? icon;

  /// Completion percentage (0-100)
  double? completed;

  /// Timestamps
  late DateTime createdAt;
  late DateTime updatedAt;

  /// Sync metadata
  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.pending;

  DateTime? lastSyncedAt;

  /// Backlink to tasks in this group
  @Backlink(to: 'group')
  final tasks = IsarLinks<TaskCollection>();

  /// Helper to get task count
  @ignore
  int get taskCount => tasks.length;

  /// Helper to calculate progress from tasks
  double calculateProgress(List<TaskCollection> allTasks, List<StatusCollection> statuses) {
    if (allTasks.isEmpty) return 0.0;
    
    final doneStatus = statuses.where((s) => s.name == 'Done').firstOrNull;
    if (doneStatus == null) return 0.0;
    
    final doneTasks = allTasks.where((t) => t.statusServerId == doneStatus.serverId).length;
    return (doneTasks / allTasks.length) * 100;
  }
}
