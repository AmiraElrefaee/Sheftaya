import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/core/di/service_locator.dart';
import 'package:sheftaya/features/worker/home/logic/all_jobs/open_jobs_cubit.dart';
import 'package:sheftaya/features/worker/home/logic/job_recommendation/job_recommendation_cubit.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/bottom_nav.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/worker_home_screen_body.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/saved_jobs_screen.dart';
import 'package:sheftaya/features/worker/my_application_jobs/presentation/my_applications_jobs_screen.dart';

class WorkerHomeScreen extends StatelessWidget {
  const WorkerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OpenJobsCubit>(create: (_) => getIt<OpenJobsCubit>()),
        BlocProvider<JobsRecommendationsCubit>(
          create: (_) => getIt<JobsRecommendationsCubit>(),
        ),
      ],
      child: const _WorkerHomeScreenShell(),
    );
  }
}

class _WorkerHomeScreenShell extends StatefulWidget {
  const _WorkerHomeScreenShell();

  @override
  State<_WorkerHomeScreenShell> createState() => _WorkerHomeScreenShellState();
}

class _WorkerHomeScreenShellState extends State<_WorkerHomeScreenShell> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<OpenJobsCubit>().fetchOpenJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const WorkerHomeScreenBody(),
      const MyApplicationsJobsScreen(),
      const SavedJobsScreen(),
      const Center(child: Text('الإعدادات')),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNav(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
      ),
    );
  }
}
