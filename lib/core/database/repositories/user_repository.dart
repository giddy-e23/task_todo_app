import 'package:isar/isar.dart';

import '../app_database.dart';
import '../collections/collections.dart';

/// Repository for user operations
/// Manages local user profile for offline-first functionality
class UserRepository {
  Isar get _db => AppDatabase.instance;

  /// Get the current logged-in user (local profile)
  /// Returns the first user in the database (single-user local mode)
  Future<UserCollection?> getCurrentUser() async {
    return _db.userCollections.where().findFirst();
  }

  /// Get user by ID
  Future<UserCollection?> getById(int id) async {
    return _db.userCollections.get(id);
  }

  /// Get user by server ID
  Future<UserCollection?> getByServerId(String serverId) async {
    return _db.userCollections
        .where()
        .serverIdEqualTo(serverId)
        .findFirst();
  }

  /// Get user by email
  Future<UserCollection?> getByEmail(String email) async {
    return _db.userCollections
        .where()
        .emailEqualTo(email)
        .findFirst();
  }

  /// Create or update local user profile (from server sync or offline creation)
  Future<UserCollection> createOrUpdate({
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
    var user = await getByServerId(serverId);
    
    if (user == null) {
      // Create new user
      user = UserCollection()
        ..serverId = serverId
        ..firstName = firstName
        ..lastName = lastName
        ..email = email
        ..phoneNumber = phoneNumber
        ..profilePictureUrl = profilePictureUrl
        ..emailVerifiedAt = emailVerifiedAt
        ..createdAt = now
        ..updatedAt = now
        ..syncStatus = SyncStatus.synced;
    } else {
      // Update existing user
      user
        ..firstName = firstName
        ..lastName = lastName
        ..email = email
        ..phoneNumber = phoneNumber
        ..profilePictureUrl = profilePictureUrl
        ..emailVerifiedAt = emailVerifiedAt
        ..updatedAt = now;
    }

    await _db.writeTxn(() async {
      await _db.userCollections.put(user!);
    });

    return user;
  }

  /// Update user profile locally
  Future<UserCollection> updateProfile(
    UserCollection user, {
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profilePictureUrl,
  }) async {
    if (firstName != null) user.firstName = firstName;
    if (lastName != null) user.lastName = lastName;
    if (phoneNumber != null) user.phoneNumber = phoneNumber;
    if (profilePictureUrl != null) user.profilePictureUrl = profilePictureUrl;

    user.updatedAt = DateTime.now();
    user.syncStatus = SyncStatus.pending;

    await _db.writeTxn(() async {
      await _db.userCollections.put(user);
    });

    return user;
  }

  /// Delete user (for logout)
  Future<bool> delete(int id) async {
    return _db.writeTxn(() async {
      return _db.userCollections.delete(id);
    });
  }

  /// Delete all users (for logout/clear data)
  Future<void> deleteAll() async {
    await _db.writeTxn(() async {
      await _db.userCollections.clear();
    });
  }

  /// Watch current user (reactive)
  Stream<UserCollection?> watchCurrentUser() {
    return _db.userCollections
        .where()
        .watch(fireImmediately: true)
        .map((users) => users.isNotEmpty ? users.first : null);
  }

  /// Check if user is logged in (has local profile)
  Future<bool> isLoggedIn() async {
    final count = await _db.userCollections.count();
    return count > 0;
  }

  /// Get user with pending sync
  Future<List<UserCollection>> getPendingSync() async {
    return _db.userCollections
        .where()
        .filter()
        .syncStatusEqualTo(SyncStatus.pending)
        .findAll();
  }

  /// Mark user as synced
  Future<void> markSynced(UserCollection user) async {
    user.syncStatus = SyncStatus.synced;
    user.lastSyncedAt = DateTime.now();

    await _db.writeTxn(() async {
      await _db.userCollections.put(user);
    });
  }

  /// Create a guest/offline user
  Future<UserCollection> createGuestUser({
    String firstName = 'Guest',
    String lastName = 'User',
  }) async {
    final now = DateTime.now();
    final user = UserCollection()
      ..serverId = AppDatabase.generateId()
      ..firstName = firstName
      ..lastName = lastName
      ..email = 'guest@local.device'
      ..createdAt = now
      ..updatedAt = now
      ..syncStatus = SyncStatus.pending;

    await _db.writeTxn(() async {
      await _db.userCollections.put(user);
    });

    return user;
  }
}
