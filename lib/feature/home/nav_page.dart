import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:task_todo_app/feature/home/home_page.dart';
import 'package:task_todo_app/shared/widgets/navigation/custom_bottom_nav.dart';

class NavPage extends StatefulWidget {
   const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  extendBody: true,
   body: _pages[_currentIndex],
   floatingActionButton: AppFab(onTap: () {
    // Handle FAB tap, e.g., navigate to task creation page
   }),
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