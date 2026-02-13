import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

/// Repository for task operations
class TaskRepository {
  AppDatabase get _db => AppDatabase.instance;

  /// Get all tasks for a user
  Future<List<Task>> getAllForUser(String userId) async {
    return (_db.select(_db.tasks)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
        .get();
  }

  /// Get task by ID
  Future<Task?> getById(int id) async {
    return (_db.select(_db.tasks)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get task by server ID
  Future<Task?> getByServerId(String serverId) async {
    return (_db.select(_db.tasks)..where((t) => t.serverId.equals(serverId)))
        .getSingleOrNull();
  }

  /// Get tasks by status
  Future<List<Task>> getByStatus(String userId, String statusServerId) async {
    return (_db.select(_db.tasks)
          ..where((t) =>
              t.userId.equals(userId) & t.statusServerId.equals(statusServerId))
          ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
        .get();
  }

  /// Get tasks by group
  Future<List<Task>> getByGroup(String userId, String groupServerId) async {
    return (_db.select(_db.tasks)
          ..where((t) =>
              t.userId.equals(userId) & t.groupServerId.equals(groupServerId))
          ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
        .get();
  }

  /// Get tasks for today
  Future<List<Task>> getTodayTasks(String userId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (_db.select(_db.tasks)
          ..where((t) =>
              t.userId.equals(userId) &
              t.startDate.isBiggerOrEqualValue(startOfDay) &
              t.startDate.isSmallerThanValue(endOfDay))
          ..orderBy([(t) => OrderingTerm.asc(t.startDate)]))
        .get();
  }

  /// Get tasks for a date range
  Future<List<Task>> getByDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    return (_db.select(_db.tasks)
          ..where((t) =>
              t.userId.equals(userId) &
              t.startDate.isBiggerOrEqualValue(start) &
              t.startDate.isSmallerOrEqualValue(end))
          ..orderBy([(t) => OrderingTerm.asc(t.startDate)]))
        .get();
  }

  /// Get completed tasks for a user
  Future<List<Task>> getCompletedTasks(String userId) async {
    return (_db.select(_db.tasks)
          ..where((t) =>
              t.userId.equals(userId) & t.completedAt.isNotNull())
          ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]))
        .get();
  }

  /// Get incomplete tasks for a user
  Future<List<Task>> getIncompleteTasks(String userId) async {
    return (_db.select(_db.tasks)
          ..where((t) =>
              t.userId.equals(userId) & t.completedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.startDate)]))
        .get();
  }

  /// Create a new task
  Future<Task> create({
    required String userId,
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String logo,
    required String groupServerId,
    String? statusServerId,
  }) async {
    final now = DateTime.now();
    final id = await _db.into(_db.tasks).insert(TasksCompanion.insert(
      serverId: AppDatabase.generateId(),
      userId: userId,
      title: title,
      description: description,
      startDate: startDate,
      endDate: endDate,
      logo: logo,
      groupServerId: Value(groupServerId),
      statusServerId: Value(statusServerId),
      createdAt: now,
      updatedAt: now,
      syncStatus: const Value(SyncStatus.pending),
    ));

    return (await getById(id))!;
  }

  /// Update a task
  Future<Task> update(
    Task task, {
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? logo,
    String? statusServerId,
    String? groupServerId,
  }) async {
    await (_db.update(_db.tasks)..where((t) => t.id.equals(task.id))).write(
      TasksCompanion(
        title: title != null ? Value(title) : const Value.absent(),
        description: description != null ? Value(description) : const Value.absent(),
        startDate: startDate != null ? Value(startDate) : const Value.absent(),
        endDate: endDate != null ? Value(endDate) : const Value.absent(),
        logo: logo != null ? Value(logo) : const Value.absent(),
        statusServerId: statusServerId != null ? Value(statusServerId) : const Value.absent(),
        groupServerId: groupServerId != null ? Value(groupServerId) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );

    return (await getById(task.id))!;
  }

  /// Update task status
  Future<Task> updateStatus(
    Task task,
    String statusServerId, {
    bool markCompleted = false,
  }) async {
    await (_db.update(_db.tasks)..where((t) => t.id.equals(task.id))).write(
      TasksCompanion(
        statusServerId: Value(statusServerId),
        completedAt: markCompleted ? Value(DateTime.now()) : const Value(null),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );

    return (await getById(task.id))!;
  }

  /// Mark task as completed
  Future<Task> markCompleted(Task task, String doneStatusServerId) async {
    return updateStatus(task, doneStatusServerId, markCompleted: true);
  }

  /// Mark task as incomplete
  Future<Task> markIncomplete(Task task, String todoStatusServerId) async {
    return updateStatus(task, todoStatusServerId, markCompleted: false);
  }

  /// Delete a task
  Future<bool> delete(int id) async {
    final count = await (_db.delete(_db.tasks)..where((t) => t.id.equals(id))).go();
    return count > 0;
  }

  /// Delete a task by server ID
  Future<bool> deleteByServerId(String serverId) async {
    final count = await (_db.delete(_db.tasks)
          ..where((t) => t.serverId.equals(serverId)))
        .go();
    return count > 0;
  }

  /// Watch all tasks for a user (reactive)
  Stream<List<Task>> watchAllForUser(String userId) {
    return (_db.select(_db.tasks)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
        .watch();
  }

  /// Watch today's tasks (reactive)
  Stream<List<Task>> watchTodayTasks(String userId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (_db.select(_db.tasks)
          ..where((t) =>
              t.userId.equals(userId) &
              t.startDate.isBiggerOrEqualValue(startOfDay) &
              t.startDate.isSmallerThanValue(endOfDay))
          ..orderBy([(t) => OrderingTerm.asc(t.startDate)]))
        .watch();
  }

  /// Get tasks with pending sync
  Future<List<Task>> getPendingSync() async {
    return (_db.select(_db.tasks)
          ..where((t) => t.syncStatus.equalsValue(SyncStatus.pending)))
        .get();
  }

  /// Mark task as synced
  Future<void> markSynced(Task task, String serverId) async {
    await (_db.update(_db.tasks)..where((t) => t.id.equals(task.id))).write(
      TasksCompanion(
        serverId: Value(serverId),
        syncStatus: const Value(SyncStatus.synced),
        lastSyncedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Get task count for a user
  Future<int> getCountForUser(String userId) async {
    final result = await (_db.selectOnly(_db.tasks)
          ..addColumns([_db.tasks.id.count()])
          ..where(_db.tasks.userId.equals(userId)))
        .getSingle();
    return result.read(_db.tasks.id.count()) ?? 0;
  }

  /// Get completed task count for a user
  Future<int> getCompletedCountForUser(String userId) async {
    final result = await (_db.selectOnly(_db.tasks)
          ..addColumns([_db.tasks.id.count()])
          ..where(_db.tasks.userId.equals(userId) & _db.tasks.completedAt.isNotNull()))
        .getSingle();
    return result.read(_db.tasks.id.count()) ?? 0;
  }

  /// Get tasks due soon (within hours)
  Future<List<Task>> getTasksDueSoon(String userId, {int hours = 24}) async {
    final now = DateTime.now();
    final soon = now.add(Duration(hours: hours));

    return (_db.select(_db.tasks)
          ..where((t) =>
              t.userId.equals(userId) &
              t.completedAt.isNull() &
              t.endDate.isBiggerOrEqualValue(now) &
              t.endDate.isSmallerOrEqualValue(soon))
          ..orderBy([(t) => OrderingTerm.asc(t.endDate)]))
        .get();
  }
}
