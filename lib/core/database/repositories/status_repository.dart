import 'package:isar/isar.dart';

import '../app_database.dart';
import '../collections/collections.dart';

/// Repository for task status operations
/// Primarily read-only since statuses are predefined
class StatusRepository {
  Isar get _db => AppDatabase.instance;

  /// Get all statuses ordered by display order
  Future<List<StatusCollection>> getAll() async {
    return _db.statusCollections
        .where()
        .sortByDisplayOrder()
        .findAll();
  }

  /// Get status by ID
  Future<StatusCollection?> getById(int id) async {
    return _db.statusCollections.get(id);
  }

  /// Get status by server ID
  Future<StatusCollection?> getByServerId(String serverId) async {
    return _db.statusCollections
        .where()
        .serverIdEqualTo(serverId)
        .findFirst();
  }

  /// Get status by name
  Future<StatusCollection?> getByName(String name) async {
    return _db.statusCollections
        .where()
        .nameEqualTo(name)
        .findFirst();
  }

  /// Get "To Do" status
  Future<StatusCollection?> getTodoStatus() => getByName('To Do');

  /// Get "In Progress" status
  Future<StatusCollection?> getInProgressStatus() => getByName('In Progress');

  /// Get "Done" status
  Future<StatusCollection?> getDoneStatus() => getByName('Done');

  /// Get "Canceled" status
  Future<StatusCollection?> getCanceledStatus() => getByName('Canceled');

  /// Watch all statuses (reactive)
  Stream<List<StatusCollection>> watchAll() {
    return _db.statusCollections
        .where()
        .sortByDisplayOrder()
        .watch(fireImmediately: true);
  }
}
