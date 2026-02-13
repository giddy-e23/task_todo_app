import 'package:drift/drift.dart';

import '../app_database.dart';

/// Repository for task status operations
/// Primarily read-only since statuses are predefined
class StatusRepository {
  AppDatabase get _db => AppDatabase.instance;

  /// Get all statuses ordered by display order
  Future<List<Statuse>> getAll() async {
    return (_db.select(_db.statuses)
          ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
        .get();
  }

  /// Get status by ID
  Future<Statuse?> getById(int id) async {
    return (_db.select(_db.statuses)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get status by server ID
  Future<Statuse?> getByServerId(String serverId) async {
    return (_db.select(_db.statuses)..where((t) => t.serverId.equals(serverId)))
        .getSingleOrNull();
  }

  /// Get status by name
  Future<Statuse?> getByName(String name) async {
    return (_db.select(_db.statuses)..where((t) => t.name.equals(name)))
        .getSingleOrNull();
  }

  /// Get "To Do" status
  Future<Statuse?> getTodoStatus() => getByName('To Do');

  /// Get "In Progress" status
  Future<Statuse?> getInProgressStatus() => getByName('In Progress');

  /// Get "Done" status
  Future<Statuse?> getDoneStatus() => getByName('Done');

  /// Get "Canceled" status
  Future<Statuse?> getCanceledStatus() => getByName('Canceled');

  /// Watch all statuses (reactive)
  Stream<List<Statuse>> watchAll() {
    return (_db.select(_db.statuses)
          ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
        .watch();
  }
}
