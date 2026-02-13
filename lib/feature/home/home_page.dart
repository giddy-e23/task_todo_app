import 'package:flutter/material.dart';
import 'package:task_todo_app/core/theme/theme.dart';
import 'package:task_todo_app/shared/custom_app_background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomAppBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to TaskMaster",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.of( context).textPrimary,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Your ultimate task management app",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.of(context).textSecondary,
              ),
            ),])));
  }
}