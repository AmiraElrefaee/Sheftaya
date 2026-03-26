import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/features/employer/home/data/models/job_model.dart';
import 'package:sheftaya/features/worker/home/data/models/all_jobs/open_jobs_response.dart';
import 'package:sheftaya/features/worker/home/logic/all_jobs/open_jobs_cubit.dart';
import 'package:sheftaya/features/worker/home/logic/all_jobs/open_jobs_state.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/header_widget.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/home_job_card.dart';

class WorkerHomeScreenBody extends StatefulWidget {
  const WorkerHomeScreenBody({super.key});

  @override
  State<WorkerHomeScreenBody> createState() => _WorkerHomeScreenBodyState();
}

class _WorkerHomeScreenBodyState extends State<WorkerHomeScreenBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenJobsCubit, OpenJobsState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
          success: (data) {
            final jobs =
                data.data?.map((openJob) => openJob.toJobModel()).toList() ??
                [];

            if (jobs.isEmpty) {
              return Center(
                child: Text(
                  'لا يوجد وظائف متاحة حالياً',
                  style: TextStyles.font16BlackMedium,
                ),
              );
            }

            final suggested = jobs.take(2).toList();
            final current = jobs.toList();

            return SingleChildScrollView(
              child: Column(
                children: [
                  HeaderWidget(jobs: jobs),
                  SizedBox(height: 12.h),
                  _section(title: 'وظائف مقترحه لك', jobs: suggested),
                  _section(title: 'وظائف حالية', jobs: current),
                  SizedBox(height: 12.h),
                ],
              ),
            );
          },
          error: (message) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'فشل تحميل الوظائف: $message',
                    style: TextStyles.font16BlackMedium,
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<OpenJobsCubit>().fetchOpenJobs(),
                    child: const Text('أعد المحاولة'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _section({required String title, required List<JobModel> jobs}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyles.font18BlackBold),
              TextButton(
                onPressed: () {
                  context.push(
                    AppRouter.kAllJobsScreen,
                    extra: {'jobs': jobs, 'title': title},
                  );
                },
                child: Text('رؤية الكل', style: TextStyles.font12SecondaryBold),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: List.generate(
              jobs.take(2).length,
              (i) => Padding(
                padding: EdgeInsets.only(
                  right: i == jobs.take(2).length - 1 ? 0 : 12.w,
                ),
                child: SizedBox(
                  width: 380.w,
                  child: HomeJobCard(job: jobs[i]),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
