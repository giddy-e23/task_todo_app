import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:task_todo_app/feature/auth/presentation/pages/welcome.dart';
import 'package:task_todo_app/feature/home/nav_page.dart';
import 'package:task_todo_app/feature/widgets_page.dart';
import 'core/theme/theme.dart';
import 'feature/showcase/presentation/pages/showcase_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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



