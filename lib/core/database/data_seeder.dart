import 'package:task_todo_app/core/database/database.dart';

/// Seeds sample data for new users (guest mode)
class DataSeeder {
  final UserRepository _userRepo;
  final TaskGroupRepository _groupRepo;
  final TaskRepository _taskRepo;
  final StatusRepository _statusRepo;

  DataSeeder({
    UserRepository? userRepo,
    TaskGroupRepository? groupRepo,
    TaskRepository? taskRepo,
    StatusRepository? statusRepo,
  })  : _userRepo = userRepo ?? UserRepository(),
        _groupRepo = groupRepo ?? TaskGroupRepository(),
        _taskRepo = taskRepo ?? TaskRepository(),
        _statusRepo = statusRepo ?? StatusRepository();

  /// Check if this is first launch (no user exists)
  Future<bool> isFirstLaunch() async {
    return !(await _userRepo.isLoggedIn());
  }

  /// Seed all initial data for a new guest user
  Future<void> seedInitialData() async {
    if (!await isFirstLaunch()) return;

    // Create guest user
    final user = await _userRepo.createGuestUser(
      firstName: 'Guest',
      lastName: 'User',
    );

    // Get statuses
    final todoStatus = await _statusRepo.getTodoStatus();
    final inProgressStatus = await _statusRepo.getInProgressStatus();
    final doneStatus = await _statusRepo.getDoneStatus();

    // Create task groups
    final workGroup = await _groupRepo.create(
      userId: user.serverId,
      name: 'Work',
      hexColor: '#7C3AED',
      icon: 'briefcase',
    );

    final personalGroup = await _groupRepo.create(
      userId: user.serverId,
      name: 'Personal',
      hexColor: '#F59E0B',
      icon: 'user',
    );

    final designGroup = await _groupRepo.create(
      userId: user.serverId,
      name: 'Design',
      hexColor: '#EC4899',
      icon: 'palette',
    );

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Create sample tasks
    await _taskRepo.create(
      userId: user.serverId,
      title: 'Review project proposal',
      description: 'Go through the Q1 project proposal and provide feedback',
      startDate: today.add(const Duration(hours: 9)),
      endDate: today.add(const Duration(hours: 11)),
      logo: 'document',
      groupServerId: workGroup.serverId,
      statusServerId: todoStatus?.serverId,
    );

    await _taskRepo.create(
      userId: user.serverId,
      title: 'Team standup meeting',
      description: 'Daily sync with the development team',
      startDate: today.add(const Duration(hours: 10)),
      endDate: today.add(const Duration(hours: 10, minutes: 30)),
      logo: 'people',
      groupServerId: workGroup.serverId,
      statusServerId: inProgressStatus?.serverId,
    );

    await _taskRepo.create(
      userId: user.serverId,
      title: 'Update app wireframes',
      description: 'Revise the wireframes based on client feedback',
      startDate: today.add(const Duration(hours: 14)),
      endDate: today.add(const Duration(hours: 17)),
      logo: 'design',
      groupServerId: designGroup.serverId,
      statusServerId: todoStatus?.serverId,
    );

    await _taskRepo.create(
      userId: user.serverId,
      title: 'Grocery shopping',
      description: 'Buy groceries for the week',
      startDate: today.add(const Duration(hours: 18)),
      endDate: today.add(const Duration(hours: 19)),
      logo: 'cart',
      groupServerId: personalGroup.serverId,
      statusServerId: todoStatus?.serverId,
    );

    final workoutTask = await _taskRepo.create(
      userId: user.serverId,
      title: 'Morning workout',
      description: '30 min cardio + stretching',
      startDate: today.add(const Duration(hours: 6)),
      endDate: today.add(const Duration(hours: 7)),
      logo: 'fitness',
      groupServerId: personalGroup.serverId,
      statusServerId: doneStatus?.serverId,
    );

    // Mark the workout task as completed
    if (doneStatus != null) {
      await _taskRepo.markCompleted(workoutTask, doneStatus.serverId);
    }
  }

  /// Get or create the current user
  Future<User> getOrCreateCurrentUser() async {
    var user = await _userRepo.getCurrentUser();
    if (user == null) {
      user = await _userRepo.createGuestUser();
    }
    return user;
  }
}
