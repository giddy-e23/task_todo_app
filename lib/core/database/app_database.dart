import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'collections/collections.dart';

/// Database manager for the app
/// Handles Isar initialization and provides access to collections
class AppDatabase {
  static Isar? _instance;
  static const _uuid = Uuid();

  /// Get the Isar instance (must be initialized first)
  static Isar get instance {
    if (_instance == null) {
      throw StateError('Database not initialized. Call AppDatabase.initialize() first.');
    }
    return _instance!;
  }

  /// Check if database is initialized
  static bool get isInitialized => _instance != null;

  /// Initialize the database
  /// Call this in main() before runApp()
  static Future<void> initialize() async {
    if (_instance != null) return;

    final dir = await getApplicationDocumentsDirectory();
    
    _instance = await Isar.open(
      [
        StatusCollectionSchema,
        UserCollectionSchema,
        TaskGroupCollectionSchema,
        TaskCollectionSchema,
      ],
      directory: dir.path,
      name: 'task_todo_db',
    );

    // Seed default statuses if empty
    await _seedDefaultStatuses();
  }

  /// Seed default statuses on first run
  static Future<void> _seedDefaultStatuses() async {
    final statusCount = await _instance!.statusCollections.count();
    if (statusCount > 0) return;

    final now = DateTime.now();
    final statuses = [
      StatusCollection()
        ..serverId = _uuid.v4()
        ..name = 'To Do'
        ..description = 'Tasks that need to be started'
        ..hexColor = '#6B7280'
        ..displayOrder = 1
        ..createdAt = now
        ..updatedAt = now
        ..syncStatus = SyncStatus.synced,
      StatusCollection()
        ..serverId = _uuid.v4()
        ..name = 'In Progress'
        ..description = 'Tasks currently being worked on'
        ..hexColor = '#F59E0B'
        ..displayOrder = 2
        ..createdAt = now
        ..updatedAt = now
        ..syncStatus = SyncStatus.synced,
      StatusCollection()
        ..serverId = _uuid.v4()
        ..name = 'Done'
        ..description = 'Completed tasks'
        ..hexColor = '#10B981'
        ..displayOrder = 3
        ..createdAt = now
        ..updatedAt = now
        ..syncStatus = SyncStatus.synced,
      StatusCollection()
        ..serverId = _uuid.v4()
        ..name = 'Canceled'
        ..description = 'Canceled tasks'
        ..hexColor = '#EF4444'
        ..displayOrder = 4
        ..createdAt = now
        ..updatedAt = now
        ..syncStatus = SyncStatus.synced,
    ];

    await _instance!.writeTxn(() async {
      await _instance!.statusCollections.putAll(statuses);
    });
  }

  /// Close the database
  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }

  /// Clear all data (for testing or logout)
  static Future<void> clearAll() async {
    await _instance?.writeTxn(() async {
      await _instance!.clear();
    });
    // Re-seed statuses
    await _seedDefaultStatuses();
  }

  /// Generate a new UUID
  static String generateId() => _uuid.v4();
}
