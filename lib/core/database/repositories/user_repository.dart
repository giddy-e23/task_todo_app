import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

/// Repository for user operations
/// Manages local user profile for offline-first functionality
class UserRepository {
  AppDatabase get _db => AppDatabase.instance;

  /// Get the current logged-in user (local profile)
  /// Returns the first user in the database (single-user local mode)
  Future<User?> getCurrentUser() async {
    return (_db.select(_db.users)..limit(1)).getSingleOrNull();
  }

  /// Get user by ID
  Future<User?> getById(int id) async {
    return (_db.select(_db.users)..where((u) => u.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get user by server ID
  Future<User?> getByServerId(String serverId) async {
    return (_db.select(_db.users)..where((u) => u.serverId.equals(serverId)))
        .getSingleOrNull();
  }

  /// Get user by email
  Future<User?> getByEmail(String email) async {
    return (_db.select(_db.users)..where((u) => u.email.equals(email)))
        .getSingleOrNull();
  }

  /// Create or update local user profile (from server sync or offline creation)
  Future<User> createOrUpdate({
    required String serverId,
    required String firstName,
    required String lastName,
    required String email,
    String? phoneNumber,
    String? profilePictureUrl,
    DateTime? emailVerifiedAt,
  }) async {
    final now = DateTime.now();
    
    // Check if user exists
    final existing = await getByServerId(serverId);
    
    if (existing == null) {
      // Create new user
      final id = await _db.into(_db.users).insert(UsersCompanion.insert(
        serverId: serverId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: Value(phoneNumber),
        profilePictureUrl: Value(profilePictureUrl),
        emailVerifiedAt: Value(emailVerifiedAt),
        createdAt: now,
        updatedAt: now,
        syncStatus: const Value(SyncStatus.synced),
      ));
      return (await getById(id))!;
    } else {
      // Update existing user
      await (_db.update(_db.users)..where((u) => u.id.equals(existing.id)))
          .write(UsersCompanion(
        firstName: Value(firstName),
        lastName: Value(lastName),
        email: Value(email),
        phoneNumber: Value(phoneNumber),
        profilePictureUrl: Value(profilePictureUrl),
        emailVerifiedAt: Value(emailVerifiedAt),
        updatedAt: Value(now),
      ));
      return (await getById(existing.id))!;
    }
  }

  /// Update user profile locally
  Future<User> updateProfile(
    User user, {
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profilePictureUrl,
  }) async {
    await (_db.update(_db.users)..where((u) => u.id.equals(user.id))).write(
      UsersCompanion(
        firstName: firstName != null ? Value(firstName) : const Value.absent(),
        lastName: lastName != null ? Value(lastName) : const Value.absent(),
        phoneNumber: phoneNumber != null ? Value(phoneNumber) : const Value.absent(),
        profilePictureUrl: profilePictureUrl != null ? Value(profilePictureUrl) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );

    return (await getById(user.id))!;
  }

  /// Delete user (for logout)
  Future<bool> delete(int id) async {
    final count = await (_db.delete(_db.users)..where((u) => u.id.equals(id))).go();
    return count > 0;
  }

  /// Delete all users (for logout/clear data)
  Future<void> deleteAll() async {
    await _db.delete(_db.users).go();
  }

  /// Watch current user (reactive)
  Stream<User?> watchCurrentUser() {
    return (_db.select(_db.users)..limit(1))
        .watchSingleOrNull();
  }

  /// Check if user is logged in (has local profile)
  Future<bool> isLoggedIn() async {
    final count = await _db.users.count().getSingle();
    return count > 0;
  }

  /// Get user with pending sync
  Future<List<User>> getPendingSync() async {
    return (_db.select(_db.users)
          ..where((u) => u.syncStatus.equalsValue(SyncStatus.pending)))
        .get();
  }

  /// Mark user as synced
  Future<void> markSynced(User user) async {
    await (_db.update(_db.users)..where((u) => u.id.equals(user.id))).write(
      UsersCompanion(
        syncStatus: const Value(SyncStatus.synced),
        lastSyncedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Create a guest/offline user
  Future<User> createGuestUser({
    String firstName = 'Guest',
    String lastName = 'User',
  }) async {
    final now = DateTime.now();
    final id = await _db.into(_db.users).insert(UsersCompanion.insert(
      serverId: AppDatabase.generateId(),
      firstName: firstName,
      lastName: lastName,
      email: 'guest@local.device',
      createdAt: now,
      updatedAt: now,
      syncStatus: const Value(SyncStatus.pending),
    ));

    return (await getById(id))!;
  }
}
