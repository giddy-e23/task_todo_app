import 'package:isar/isar.dart';

import '../app_database.dart';
import '../collections/collections.dart';

/// Repository for task group operations
class TaskGroupRepository {
  Isar get _db => AppDatabase.instance;

  /// Get all task groups for a user
  Future<List<TaskGroupCollection>> getAllForUser(String userId) async {
    return _db.taskGroupCollections
        .where()
        .userIdEqualTo(userId)
        .sortByName()
        .findAll();
  }

  /// Get task group by ID
  Future<TaskGroupCollection?> getById(int id) async {
    return _db.taskGroupCollections.get(id);
  }

  /// Get task group by server ID
  Future<TaskGroupCollection?> getByServerId(String serverId) async {
    return _db.taskGroupCollections
        .where()
        .serverIdEqualTo(serverId)
        .findFirst();
  }

  /// Get task group by name for a user
  Future<TaskGroupCollection?> getByName(String userId, String name) async {
    return _db.taskGroupCollections
        .where()
        .userIdEqualTo(userId)
        .filter()
        .nameEqualTo(name)
        .findFirst();
  }

  /// Create a new task group
  Future<TaskGroupCollection> create({
    required String userId,
    required String name,
    required String hexColor,
    String? icon,
  }) async {
    final now = DateTime.now();
    final group = TaskGroupCollection()
      ..serverId = AppDatabase.generateId()
      ..userId = userId
      ..name = name
      ..hexColor = hexColor
      ..icon = icon
      ..completed = 0
      ..createdAt = now
      ..updatedAt = now
      ..syncStatus = SyncStatus.pending;

    await _db.writeTxn(() async {
      await _db.taskGroupCollections.put(group);
    });

    return group;
  }

  /// Update a task group
  Future<TaskGroupCollection> update(
    TaskGroupCollection group, {
    String? name,
    String? hexColor,
    String? icon,
    double? completed,
  }) async {
    if (name != null) group.name = name;
    if (hexColor != null) group.hexColor = hexColor;
    if (icon != null) group.icon = icon;
    if (completed != null) group.completed = completed;
    
    group.updatedAt = DateTime.now();
    group.syncStatus = SyncStatus.pending;

    await _db.writeTxn(() async {
      await _db.taskGroupCollections.put(group);
    });

    return group;
  }

  /// Delete a task group
  Future<bool> delete(int id) async {
    return _db.writeTxn(() async {
      return _db.taskGroupCollections.delete(id);
    });
  }

  /// Delete a task group by server ID
  Future<bool> deleteByServerId(String serverId) async {
    return _db.writeTxn(() async {
      return _db.taskGroupCollections
          .where()
          .serverIdEqualTo(serverId)
          .deleteFirst();
    });
  }

  /// Watch all task groups for a user (reactive)
  Stream<List<TaskGroupCollection>> watchAllForUser(String userId) {
    return _db.taskGroupCollections
        .where()
        .userIdEqualTo(userId)
        .sortByName()
        .watch(fireImmediately: true);
  }

  /// Get groups with pending sync
  Future<List<TaskGroupCollection>> getPendingSync() async {
    return _db.taskGroupCollections
        .where()
        .filter()
        .syncStatusEqualTo(SyncStatus.pending)
        .findAll();
  }

  /// Mark group as synced
  Future<void> markSynced(TaskGroupCollection group, String serverId) async {
    group.serverId = serverId;
    group.syncStatus = SyncStatus.synced;
    group.lastSyncedAt = DateTime.now();

    await _db.writeTxn(() async {
      await _db.taskGroupCollections.put(group);
    });
  }

  /// Get group count for a user
  Future<int> getCountForUser(String userId) async {
    return _db.taskGroupCollections
        .where()
        .userIdEqualTo(userId)
        .count();
  }
}
