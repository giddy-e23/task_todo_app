import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_todo_app/feature/home/nav_page.dart';
import 'core/database/database.dart';
import 'core/di/injection.dart';
import 'core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database (triggers lazy initialization and runs migrations)
  // The database will seed default statuses on first run
  final _ = AppDatabase.instance;

  // Initialize dependency injection
  await initializeDependencies();

  // Seed initial data for new users (guest mode)
  final seeder = DataSeeder();
  await seeder.seedInitialData();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Todo',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Follows device setting

      home: const NavPage(), // Widget showcase for testing
    );
  }
}



