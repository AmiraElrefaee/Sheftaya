import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/core/di/service_locator.dart';
import 'package:sheftaya/features/employer/home/presentation/widgets/bottom_nav.dart';
import 'package:sheftaya/features/employer/home/presentation/widgets/employer_home_screen_body.dart';
import 'package:sheftaya/features/employer/my_jobs/presentation/my_jobs_screen.dart';
import 'package:sheftaya/features/publish_job/presentation/mangers/job_publish_cubit/job_publish_cubit.dart';
import 'package:sheftaya/features/publish_job/presentation/publish_job_view.dart';
import 'package:sheftaya/features/setting/presentation/setting_screen.dart';
import 'package:sheftaya/features/worker/my_application_jobs/logic/my_jobs_cubit.dart';

class EmployerHomeScreen extends StatefulWidget {
  const EmployerHomeScreen({super.key});

  @override
  State<EmployerHomeScreen> createState() => _EmployerHomeScreenState();
}

class _EmployerHomeScreenState extends State<EmployerHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MyJobsCubit>(
          create: (_) => getIt<MyJobsCubit>()..fetchMyJobs(),
        ),
        BlocProvider(create: (context) => getIt<JobPublishCubit>()),
      ],
      child: Builder(
        builder: (ctx) {
          final screens = [
            const EmployerHomeScreenBody(),
            EmployerMyJobsScreen(),
            PublishJobView(),
            const SettingScreen(),
          ];

          return Scaffold(
            body: IndexedStack(index: _currentIndex, children: screens),
            bottomNavigationBar: BottomNav(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
            ),
          );
        },
      ),
    );
  }
}
