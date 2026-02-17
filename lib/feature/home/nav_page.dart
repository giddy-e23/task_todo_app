import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:task_todo_app/feature/home/home_page.dart';
import 'package:task_todo_app/feature/profile/profile_page.dart';
import 'package:task_todo_app/feature/projects/add_project_page.dart';
import 'package:task_todo_app/feature/projects/projects_page.dart';
import 'package:task_todo_app/feature/tasks/tasks_page.dart';
import 'package:task_todo_app/shared/widgets/navigation/custom_bottom_nav.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int _currentIndex = 0;
  
  // Key to force refresh of pages when task is created
  Key _pageKey = UniqueKey();

  void _navigateToTasks() {
    setState(() => _currentIndex = 1);
  }

  List<Widget> get _pages => [
    HomePage(key: _pageKey, onViewTasks: _navigateToTasks),
    TasksPage(key: ValueKey('tasks_$_pageKey')),
    ProjectsPage(key: ValueKey('projects_$_pageKey')),
    const ProfilePage(),
  ];

  Future<void> _onFabTap() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddProjectPage()),
    );
    
    // If a task was created, refresh the current page
    if (result == true && mounted) {
      setState(() {
        _pageKey = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  extendBody: true,
   body: _pages[_currentIndex],
   floatingActionButton: AppFab(onTap: _onFabTap),
   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
   bottomNavigationBar: CustomBottomNavBar(
     currentIndex: _currentIndex,
     onTap: (index) => setState(() => _currentIndex = index),
     items: [
       NavItem(icon: IconsaxPlusLinear.home, activeIcon: IconsaxPlusBold.home, label: 'Home'),
       NavItem(icon: IconsaxPlusLinear.calendar, activeIcon: IconsaxPlusBold.calendar, label: 'Tasks'),
       NavItem(icon: IconsaxPlusLinear.document_text, activeIcon: IconsaxPlusBold.document_text, label: 'Projects'),
       NavItem(icon: IconsaxPlusLinear.profile_2user, activeIcon: IconsaxPlusBold.profile_2user, label: 'Profile'),
     ],
   ),
 );
  }
}