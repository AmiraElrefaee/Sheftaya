import 'package:flutter/material.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/bottom_nav.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/worker_home_screen_body.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/saved_jobs_screen.dart';
import 'package:sheftaya/features/worker/my_application_jobs/presentation/my_applications_jobs_screen.dart';

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  int currentIndex = 0;

  final screens = const [
    WorkerHomeScreenBody(),
    MyApplicationsJobsScreen(),
    SavedJobsScreen(),
    Center(child: Text('الإعدادات')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNav(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
      ),
    );
  }
}
