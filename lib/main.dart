import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_todo_app/feature/home/nav_page.dart';
import 'core/database/database.dart';
import 'core/di/injection.dart';
import 'core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  await AppDatabase.initialize();

  // Initialize dependency injection
  await initializeDependencies();

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



