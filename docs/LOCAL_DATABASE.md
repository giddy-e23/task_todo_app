# Local Database Documentation

## Overview

The app uses **Isar** for local storage with an offline-first architecture. Data is stored locally and syncs to the server when the user registers and has connectivity.

## Collections (Tables)

### StatusCollection
Predefined task statuses (seeded on first launch).

| Field | Type | Description |
|-------|------|-------------|
| id | int | Isar auto-increment ID |
| serverId | String | UUID - server primary key |
| name | String | "To Do", "In Progress", "Done", "Canceled" |
| description | String? | Status description |
| hexColor | String | Color hex code (e.g., "#10B981") |
| displayOrder | int | UI sort order |
| syncStatus | SyncStatus | synced/pending/conflict |

### UserCollection
Local user profile.

| Field | Type | Description |
|-------|------|-------------|
| id | int | Isar auto-increment ID |
| serverId | String | UUID - server primary key |
| firstName | String | User's first name |
| lastName | String | User's last name |
| email | String | Email (unique) |
| phoneNumber | String? | Optional phone |
| profilePictureUrl | String? | Avatar URL |
| emailVerifiedAt | DateTime? | Verification timestamp |
| syncStatus | SyncStatus | synced/pending/conflict |

### TaskGroupCollection
Task groups/categories (e.g., "Work", "Personal").

| Field | Type | Description |
|-------|------|-------------|
| id | int | Isar auto-increment ID |
| serverId | String | UUID - server primary key |
| userId | String | Owner's serverId |
| name | String | Group name |
| hexColor | String | Display color |
| icon | String? | Icon identifier |
| completed | double? | Completion % (0-100) |
| tasks | IsarLinks | Backlink to tasks |
| syncStatus | SyncStatus | synced/pending/conflict |

### TaskCollection
Individual tasks.

| Field | Type | Description |
|-------|------|-------------|
| id | int | Isar auto-increment ID |
| serverId | String | UUID - server primary key |
| userId | String | Owner's serverId |
| title | String | Task title |
| description | String | Task description |
| startDate | DateTime | Start date/time |
| endDate | DateTime | Due date/time |
| logo | String | Icon identifier |
| statusServerId | String? | Current status reference |
| completedAt | DateTime? | Completion timestamp |
| group | IsarLink | Link to TaskGroupCollection |
| syncStatus | SyncStatus | synced/pending/conflict |

## Relationships

```
UserCollection (1) ──┬──< (N) TaskGroupCollection
                     └──< (N) TaskCollection

TaskGroupCollection (1) ──< (N) TaskCollection

StatusCollection (1) ──< (N) TaskCollection (via statusServerId)
```

## Sync Status

All collections have sync metadata:

```dart
enum SyncStatus {
  synced,   // In sync with server
  pending,  // Local changes need upload
  conflict, // Conflict during sync
}
```

Fields:
- `syncStatus` - Current sync state
- `lastSyncedAt` - Last successful sync timestamp
- `serverId` - Server UUID (used for matching records)

## User Flow

### First Launch (Guest Mode)
1. App starts → `AppDatabase.initialize()`
2. Default statuses seeded (To Do, In Progress, Done, Canceled)
3. Guest user auto-created: "Guest User"
4. Sample data seeded for demo
5. User can use app fully offline

### Registration (Future)
1. User taps "Sign up to sync"
2. Creates server account
3. Guest user's `serverId` linked to server account
4. All pending data syncs to server
5. `syncStatus` → `synced`

### Login on New Device (Future)
1. User logs in
2. Server data downloaded
3. Local collections populated
4. Replaces any existing guest data

## Repositories

### StatusRepository
```dart
// Get all statuses
await statusRepository.getAll();

// Get by name
await statusRepository.getByName('Done');

// Reactive stream
statusRepository.watchAll();
```

### UserRepository
```dart
// Get current user
await userRepository.getCurrentUser();

// Create guest user
await userRepository.createGuestUser();

// Update profile
await userRepository.updateProfile(user, firstName: 'John');

// Check if logged in
await userRepository.isLoggedIn();
```

### TaskGroupRepository
```dart
// Get all for user
await taskGroupRepository.getAllForUser(userId);

// Create group
await taskGroupRepository.create(
  userId: userId,
  name: 'Work',
  hexColor: '#7C3AED',
  icon: 'briefcase',
);

// Update group
await taskGroupRepository.update(group, name: 'Office');

// Reactive stream
taskGroupRepository.watchAllForUser(userId);
```

### TaskRepository
```dart
// Get all for user
await taskRepository.getAllForUser(userId);

// Get today's tasks
await taskRepository.getTodayTasks(userId);

// Get by status
await taskRepository.getByStatus(userId, statusServerId);

// Create task
await taskRepository.create(
  userId: userId,
  title: 'Review PR',
  description: 'Review pull request #123',
  startDate: DateTime.now(),
  endDate: DateTime.now().add(Duration(hours: 2)),
  logo: 'code',
  group: workGroup,
  statusServerId: todoStatus.serverId,
);

// Update status (with swipe)
await taskRepository.updateStatus(task, doneStatus.serverId, markCompleted: true);

// Reactive stream
taskRepository.watchTodayTasks(userId);
```

## Database Location

- **Android**: `/data/data/com.example.task_todo_app/app_flutter/task_todo_db.isar`
- **iOS**: `~/Documents/task_todo_db.isar`

## Clearing Data

```dart
// Clear all data (logout)
await AppDatabase.clearAll();
// Note: Re-seeds default statuses after clear
```

## Code Generation

After modifying collections, regenerate schemas:

```bash
dart run build_runner build --delete-conflicting-outputs
```
