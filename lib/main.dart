import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_todo_app/feature/auth/bloc/bloc.dart';
import 'package:task_todo_app/feature/auth/presentation/pages/welcome.dart';
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
    return BlocProvider(
      create: (_) => AuthBloc()..add(const CheckAuthRequested()),
      child: MaterialApp(
        title: 'Task Todo',
        debugShowCheckedModeBanner: false,

        // Theme configuration
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // Follows device setting

        home: const AuthGate(),
      ),
    );
  }
}

/// Auth gate that shows appropriate screen based on auth state
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Show loading splash while checking auth
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Show home if authenticated
        if (state is Authenticated) {
          return const NavPage();
        }

        // Show welcome/login if not authenticated
        return const WelcomePage();
      },
    );
  }
}




