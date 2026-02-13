import 'package:isar/isar.dart';

part 'status_collection.g.dart';

/// Sync status for offline-first functionality
enum SyncStatus {
  synced,     // Data is in sync with server
  pending,    // Local changes waiting to sync
  conflict,   // Conflict detected during sync
}

/// Status collection - lookup table for task statuses
/// Maps to SQL: statuses table
@Collection()
class StatusCollection {
  Id id = Isar.autoIncrement;

  /// Server UUID - matches SQL statuses.id
  @Index(unique: true)
  late String serverId;

  /// Status name: "To Do", "In Progress", "Done", "Canceled"
  @Index(unique: true)
  late String name;

  /// Optional description
  String? description;

  /// Color as hex string (e.g., "#10B981")
  late String hexColor;

  /// Display order for UI sorting
  late int displayOrder;

  /// Timestamps
  late DateTime createdAt;
  late DateTime updatedAt;

  /// Sync metadata
  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.synced;
  
  DateTime? lastSyncedAt;
}
