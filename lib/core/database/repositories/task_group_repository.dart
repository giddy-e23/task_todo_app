import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

/// Repository for task group operations
class TaskGroupRepository {
  AppDatabase get _db => AppDatabase.instance;

  /// Get all task groups for a user
  Future<List<TaskGroup>> getAllForUser(String userId) async {
    return (_db.select(_db.taskGroups)
          ..where((g) => g.userId.equals(userId))
          ..orderBy([(g) => OrderingTerm.asc(g.name)]))
        .get();
  }

  /// Get task group by ID
  Future<TaskGroup?> getById(int id) async {
    return (_db.select(_db.taskGroups)..where((g) => g.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get task group by server ID
  Future<TaskGroup?> getByServerId(String serverId) async {
    return (_db.select(_db.taskGroups)
          ..where((g) => g.serverId.equals(serverId)))
        .getSingleOrNull();
  }

  /// Get task group by name for a user
  Future<TaskGroup?> getByName(String userId, String name) async {
    return (_db.select(_db.taskGroups)
          ..where((g) => g.userId.equals(userId) & g.name.equals(name)))
        .getSingleOrNull();
  }

  /// Create a new task group
  Future<TaskGroup> create({
    required String userId,
    required String name,
    required String hexColor,
    String? icon,
  }) async {
    final now = DateTime.now();
    final id = await _db.into(_db.taskGroups).insert(TaskGroupsCompanion.insert(
      serverId: AppDatabase.generateId(),
      userId: userId,
      name: name,
      hexColor: hexColor,
      icon: Value(icon),
      completed: const Value(0),
      createdAt: now,
      updatedAt: now,
      syncStatus: const Value(SyncStatus.pending),
    ));

    return (await getById(id))!;
  }

  /// Update a task group
  Future<TaskGroup> update(
    TaskGroup group, {
    String? name,
    String? hexColor,
    String? icon,
    double? completed,
  }) async {
    await (_db.update(_db.taskGroups)..where((g) => g.id.equals(group.id)))
        .write(TaskGroupsCompanion(
      name: name != null ? Value(name) : const Value.absent(),
      hexColor: hexColor != null ? Value(hexColor) : const Value.absent(),
      icon: icon != null ? Value(icon) : const Value.absent(),
      completed: completed != null ? Value(completed) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
      syncStatus: const Value(SyncStatus.pending),
    ));

    return (await getById(group.id))!;
  }

  /// Delete a task group
  Future<bool> delete(int id) async {
    final count = await (_db.delete(_db.taskGroups)..where((g) => g.id.equals(id))).go();
    return count > 0;
  }

  /// Delete a task group by server ID
  Future<bool> deleteByServerId(String serverId) async {
    final count = await (_db.delete(_db.taskGroups)
          ..where((g) => g.serverId.equals(serverId)))
        .go();
    return count > 0;
  }

  /// Watch all task groups for a user (reactive)
  Stream<List<TaskGroup>> watchAllForUser(String userId) {
    return (_db.select(_db.taskGroups)
          ..where((g) => g.userId.equals(userId))
          ..orderBy([(g) => OrderingTerm.asc(g.name)]))
        .watch();
  }

  /// Get groups with pending sync
  Future<List<TaskGroup>> getPendingSync() async {
    return (_db.select(_db.taskGroups)
          ..where((g) => g.syncStatus.equalsValue(SyncStatus.pending)))
        .get();
  }

  /// Mark group as synced
  Future<void> markSynced(TaskGroup group, String serverId) async {
    await (_db.update(_db.taskGroups)..where((g) => g.id.equals(group.id)))
        .write(TaskGroupsCompanion(
      serverId: Value(serverId),
      syncStatus: const Value(SyncStatus.synced),
      lastSyncedAt: Value(DateTime.now()),
    ));
  }

  /// Get group count for a user
  Future<int> getCountForUser(String userId) async {
    final result = await (_db.selectOnly(_db.taskGroups)
          ..addColumns([_db.taskGroups.id.count()])
          ..where(_db.taskGroups.userId.equals(userId)))
        .getSingle();
    return result.read(_db.taskGroups.id.count()) ?? 0;
  }
}
