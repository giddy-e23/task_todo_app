import 'package:drift/drift.dart';

/// Sync status for offline-first functionality
enum SyncStatus {
  synced,   // Data is in sync with server
  pending,  // Local changes waiting to sync
  conflict, // Conflict detected during sync
}

/// Status table - lookup table for task statuses
/// Maps to SQL: statuses table
class Statuses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().unique()();
  TextColumn get name => text().unique()();
  TextColumn get description => text().nullable()();
  TextColumn get hexColor => text()();
  IntColumn get displayOrder => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => textEnum<SyncStatus>().withDefault(Constant(SyncStatus.synced.name))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
}

/// Users table - stores local user profile
/// Maps to SQL: users table
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().unique()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get email => text().unique()();
  DateTimeColumn get emailVerifiedAt => dateTime().nullable()();
  TextColumn get profilePictureUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => textEnum<SyncStatus>().withDefault(Constant(SyncStatus.synced.name))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
}

/// TaskGroups table - groups/categories for tasks
/// Maps to SQL: task_groups table
class TaskGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().unique()();
  TextColumn get userId => text()(); // Reference to users.serverId
  TextColumn get name => text()();
  TextColumn get hexColor => text()();
  TextColumn get icon => text().nullable()();
  RealColumn get completed => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => textEnum<SyncStatus>().withDefault(Constant(SyncStatus.pending.name))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
}

/// Tasks table - individual tasks
/// Maps to SQL: tasks table
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().unique()();
  TextColumn get userId => text()(); // Reference to users.serverId
  TextColumn get title => text()();
  TextColumn get description => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get logo => text()();
  TextColumn get statusServerId => text().nullable()(); // Reference to statuses.serverId
  TextColumn get groupServerId => text().nullable()(); // Reference to task_groups.serverId
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => textEnum<SyncStatus>().withDefault(Constant(SyncStatus.pending.name))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
}
