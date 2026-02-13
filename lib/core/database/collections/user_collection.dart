import 'package:isar/isar.dart';
import 'status_collection.dart';

part 'user_collection.g.dart';

/// User collection - stores local user profile
/// Maps to SQL: users table
@Collection()
class UserCollection {
  Id id = Isar.autoIncrement;

  /// Server UUID - matches SQL users.id
  @Index(unique: true)
  late String serverId;

  /// User's first name
  late String firstName;

  /// User's last name
  late String lastName;

  /// Phone number (optional)
  String? phoneNumber;

  /// Email address
  @Index(unique: true)
  late String email;

  /// Email verification timestamp
  DateTime? emailVerifiedAt;

  /// Profile picture URL
  String? profilePictureUrl;

  /// Timestamps
  late DateTime createdAt;
  late DateTime updatedAt;

  /// Sync metadata
  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.synced;

  DateTime? lastSyncedAt;

  /// Helper to get full name
  @ignore
  String get fullName => '$firstName $lastName';

  /// Helper to get initials
  @ignore
  String get initials {
    final first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last';
  }
}
