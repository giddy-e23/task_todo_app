import 'package:isar/isar.dart';

import '../app_database.dart';
import '../collections/collections.dart';

/// Repository for task operations
class TaskRepository {
  Isar get _db => AppDatabase.instance;

  /// Get all tasks for a user
  Future<List<TaskCollection>> getAllForUser(String userId) async {
    return _db.taskCollections
        .where()
        .userIdEqualTo(userId)
        .sortByStartDateDesc()
        .findAll();
  }

  /// Get task by ID
  Future<TaskCollection?> getById(int id) async {
    return _db.taskCollections.get(id);
  }

  /// Get task by server ID
  Future<TaskCollection?> getByServerId(String serverId) async {
    return _db.taskCollections
        .where()
        .serverIdEqualTo(serverId)
        .findFirst();
  }

  /// Get tasks by status
  Future<List<TaskCollection>> getByStatus(String userId, String statusServerId) async {
    return _db.taskCollections
        .where()
        .userIdEqualTo(userId)
        .filter()
        .statusServerIdEqualTo(statusServerId)
        .sortByStartDateDesc()
        .findAll();
  }

  /// Get tasks by group
  Future<List<TaskCollection>> getByGroup(String userId, int groupId) async {
    final tasks = await _db.taskCollections
        .where()
        .userIdEqualTo(userId)
        .sortByStartDateDesc()
        .findAll();
    
    return tasks.where((t) => t.group.value?.id == groupId).toList();
  }

  /// Get tasks for today
  Future<List<TaskCollection>> getTodayTasks(String userId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _db.taskCollections
        .where()
        .userIdEqualTo(userId)
        .filter()
        .startDateBetween(startOfDay, endOfDay)
        .sortByStartDate()
        .findAll();
  }

  /// Get tasks for a date range
  Future<List<TaskCollection>> getByDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    return _db.taskCollections
        .where()
        .userIdEqualTo(userId)
        .filter()
        .startDateBetween(start, end)
        .sortByStartDate()
        .findAll();
  }

  /// Get completed tasks for a user
  Future<List<TaskCollection>> getCompletedTasks(String userId) async {
    return _db.taskCollections
        .where()
        .userIdEqualTo(userId)
        .filter()
        .completedAtIsNotNull()
        .sortByCompletedAtDesc()
        .findAll();
  }

  /// Get incomplete tasks for a user
  Future<List<TaskCollection>> getIncompleteTasks(String userId) async {
    return _db.taskCollections
        .where()
        .userIdEqualTo(userId)
        .filter()
        .completedAtIsNull()
        .sortByStartDate()
        .findAll();
  }

  /// Create a new task
  Future<TaskCollection> create({
    required String userId,
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String logo,
    required TaskGroupCollection group,
    String? statusServerId,
  }) async {
    final now = DateTime.now();
    final task = TaskCollection()
      ..serverId = AppDatabase.generateId()
      ..userId = userId
      ..title = title
      ..description = description
      ..startDate = startDate
      ..endDate = endDate
      ..logo = logo
      ..statusServerId = statusServerId
      ..createdAt = now
      ..updatedAt = now
      ..syncStatus = SyncStatus.pending;

    task.group.value = group;

    await _db.writeTxn(() async {
      await _db.taskCollections.put(task);
      await task.group.save();
    });

    return task;
  }

  /// Update a task
  Future<TaskCollection> update(
    TaskCollection task, {
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? logo,
    String? statusServerId,
    TaskGroupCollection? group,
  }) async {
    if (title != null) task.title = title;
    if (description != null) task.description = description;
    if (startDate != null) task.startDate = startDate;
    if (endDate != null) task.endDate = endDate;
    if (logo != null) task.logo = logo;
    if (statusServerId != null) task.statusServerId = statusServerId;
    if (group != null) task.group.value = group;

    task.updatedAt = DateTime.now();
    task.syncStatus = SyncStatus.pending;

    await _db.writeTxn(() async {
      await _db.taskCollections.put(task);
      if (group != null) await task.group.save();
    });

    return task;
  }

  /// Update task status
  Future<TaskCollection> updateStatus(
    TaskCollection task,
    String statusServerId, {
    bool markCompleted = false,
  }) async {
    task.statusServerId = statusServerId;
    task.updatedAt = DateTime.now();
    task.syncStatus = SyncStatus.pending;

    if (markCompleted) {
      task.completedAt = DateTime.now();
    } else {
      task.completedAt = null;
    }

    await _db.writeTxn(() async {
      await _db.taskCollections.put(task);
    });

    return task;
  }

  /// Mark task as completed
  Future<TaskCollection> markCompleted(TaskCollection task, String doneStatusServerId) async {
    return updateStatus(task, doneStatusServerId, markCompleted: true);
  }

  /// Mark task as incomplete
  Future<TaskCollection> markIncomplete(TaskCollection task, String todoStatusServerId) async {
    return updateStatus(task, todoStatusServerId, markCompleted: false);
  }

  /// Delete a task
  Future<bool> delete(int id) async {
    return _db.writeTxn(() async {
      return _db.taskCollections.delete(id);
    });
  }

  /// Delete a task by server ID
  Future<bool> deleteByServerId(String serverId) async {
    return _db.writeTxn(() async {
      return _db.taskCollections
          .where()
          .serverIdEqualTo(serverId)
          .deleteFirst();
    });
  }

  /// Watch all tasks for a user (reactive)
  Stream<List<TaskCollection>> watchAllForUser(String userId) {
    return _db.taskCollections
        .where()
        .userIdEqualTo(userId)
        .sortByStartDateDesc()
        .watch(fireImmediately: true);
  }

  /// Watch today's tasks (reactive)
  Stream<List<TaskCollection>> watchTodayTasks(String userId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _db.taskCollections
        .where()
        .userIdEqualTo(userId)
        .filter()
        .startDateBetween(startOfDay, endOfDay)
        .sortByStartDate()
        .watch(fireImmediately: true);
  }

  /// Get tasks with pending sync
  Future<List<TaskCollection>> getPendingSync() async {
    return _db.taskCollections
        .where()
        .filter()
        .syncStatusEqualTo(SyncStatus.pending)
        .findAll();
  }

  /// Mark task as synced
  Future<void> markSynced(TaskCollection task, String serverId) async {
    task.serverId = serverId;
    task.syncStatus = SyncStatus.synced;
    task.lastSyncedAt = DateTime.now();

    await _db.writeTxn(() async {
      await _db.taskCollections.put(task);
    });
  }

  /// Get task count for a user
  Future<int> getCountForUser(String userId) async {
    return _db.taskCollections
        .where()
        .userIdEqualTo(userId)
        .count();
  }

  /// Get completed task count for a user
  Future<int> getCompletedCountForUser(String userId) async {
    return _db.taskCollections
        .where()
        .userIdEqualTo(userId)
        .filter()
        .completedAtIsNotNull()
        .count();
  }

  /// Get tasks due soon (within hours)
  Future<List<TaskCollection>> getTasksDueSoon(String userId, {int hours = 24}) async {
    final now = DateTime.now();
    final soon = now.add(Duration(hours: hours));

    return _db.taskCollections
        .where()
        .userIdEqualTo(userId)
        .filter()
        .completedAtIsNull()
        .endDateBetween(now, soon)
        .sortByEndDate()
        .findAll();
  }
}
