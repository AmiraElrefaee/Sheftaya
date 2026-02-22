import 'package:flutter/material.dart';
import 'package:sheftaya/features/employer/home/presentation/widgets/bottom_nav.dart';
import 'package:sheftaya/features/employer/home/presentation/widgets/employer_home_screen_body.dart';
import 'package:sheftaya/features/employer/home/presentation/widgets/placeholder_screen.dart';
import 'package:sheftaya/features/employer/my_jobs/presentation/my_jobs_screen.dart';

class EmployerHomeScreen extends StatefulWidget {
  const EmployerHomeScreen({super.key});

  @override
  State<EmployerHomeScreen> createState() => _EmployerHomeScreenBodyState();
}

class _EmployerHomeScreenBodyState extends State<EmployerHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const EmployerHomeScreenBody(),
    EmployerMyJobsScreen(),
    PlaceholderScreen(label: 'الجوائز'),
    PlaceholderScreen(label: 'الإعدادات'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
