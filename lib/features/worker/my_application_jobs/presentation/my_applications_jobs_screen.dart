import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/core/di/service_locator.dart';
import 'package:sheftaya/features/worker/my_application_jobs/logic/my_jobs_cubit.dart';
import 'widgets/my_applications_jobs_screen_body.dart';

class MyApplicationsJobsScreen extends StatelessWidget {
  const MyApplicationsJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyJobsCubit>(
      create: (_) => getIt<MyJobsCubit>(),
      child: const MyApplicationsJobsScreenBody(),
    );
  }
}