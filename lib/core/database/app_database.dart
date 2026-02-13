import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import 'tables/tables.dart';

part 'app_database.g.dart';

/// Database manager for the app using Drift
@DriftDatabase(tables: [Statuses, Users, TaskGroups, Tasks])
class AppDatabase extends _$AppDatabase {
  static AppDatabase? _instance;
  static const _uuid = Uuid();

  AppDatabase._() : super(_openConnection());

  /// Get the singleton database instance
  static AppDatabase get instance {
    _instance ??= AppDatabase._();
    return _instance!;
  }

  /// Check if database is initialized
  static bool get isInitialized => _instance != null;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Seed default statuses after table creation
        await _seedDefaultStatuses();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle migrations here
      },
    );
  }

  /// Seed default statuses on first run
  Future<void> _seedDefaultStatuses() async {
    final statusCount = await (select(statuses)..limit(1)).get();
    if (statusCount.isNotEmpty) return;

    final now = DateTime.now();
    final defaultStatuses = [
      StatusesCompanion.insert(
        serverId: _uuid.v4(),
        name: 'To Do',
        description: const Value('Tasks that need to be started'),
        hexColor: '#6B7280',
        displayOrder: 1,
        createdAt: now,
        updatedAt: now,
      ),
      StatusesCompanion.insert(
        serverId: _uuid.v4(),
        name: 'In Progress',
        description: const Value('Tasks currently being worked on'),
        hexColor: '#F59E0B',
        displayOrder: 2,
        createdAt: now,
        updatedAt: now,
      ),
      StatusesCompanion.insert(
        serverId: _uuid.v4(),
        name: 'Done',
        description: const Value('Completed tasks'),
        hexColor: '#10B981',
        displayOrder: 3,
        createdAt: now,
        updatedAt: now,
      ),
      StatusesCompanion.insert(
        serverId: _uuid.v4(),
        name: 'Canceled',
        description: const Value('Canceled tasks'),
        hexColor: '#EF4444',
        displayOrder: 4,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    await batch((batch) {
      batch.insertAll(statuses, defaultStatuses);
    });
  }

  /// Re-seed statuses (for use after initialization)
  Future<void> ensureDefaultStatuses() async {
    await _seedDefaultStatuses();
  }

  /// Close the database and reset singleton
  static Future<void> closeDatabase() async {
    await _instance?.close();
    _instance = null;
  }

  /// Generate a new UUID
  static String generateId() => _uuid.v4();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'task_todo_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
