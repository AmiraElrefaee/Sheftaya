import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/features/worker/home/data/models/all_jobs/jobs_response.dart';
import 'package:sheftaya/features/worker/home/logic/all_jobs/open_jobs_cubit.dart';
import 'package:sheftaya/features/worker/home/logic/all_jobs/open_jobs_state.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/header_widget.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/home_job_card.dart';

class WorkerHomeScreenBody extends StatelessWidget {
  const WorkerHomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenJobsCubit, OpenJobsState>(
      builder: (context, state) {
        final jobs = state.maybeWhen(
          success: (data, page, hasNextPage) => data.data ?? <JobItem>[],
          loadingMore: (previous, nextPage) => previous.data ?? <JobItem>[],
          orElse: () => <JobItem>[],
        );

        return SingleChildScrollView(
          child: Column(
            children: [
              HeaderWidget(jobs: jobs),
              SizedBox(height: 12.h),
              _section(
                context,
                state: state,
                title: 'وظائف مقترحه لك',
                jobs: jobs.take(2).toList(),
                emptyMessage: 'لا توجد وظائف مقترحة حالياً',
              ),
              _section(
                context,
                state: state,
                title: 'وظائف حالية',
                jobs: jobs,
                emptyMessage: 'لا توجد وظائف حالية',
              ),
              SizedBox(height: 12.h),
            ],
          ),
        );
      },
    );
  }

  Widget _section(
    BuildContext context, {
    required OpenJobsState state,
    required String title,
    required List<JobItem> jobs,
    required String emptyMessage,
  }) {
    final hasJobs = jobs.isNotEmpty;
    final isLoading = state.maybeWhen(
      initial: () => true,
      loading: () => true,
      orElse: () => false,
    );
    final isError = state.maybeWhen(error: (_) => true, orElse: () => false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyles.font18BlackBold),
              if (hasJobs)
                TextButton(
                  onPressed: () {
                    context.push(
                      AppRouter.kAllJobsScreen,
                      extra: {'jobs': jobs, 'title': title},
                    );
                  },
                  child: Text(
                    'رؤية الكل',
                    style: TextStyles.font12SecondaryBold,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _sectionCard(
            context,
            state: state,
            jobs: jobs,
            emptyMessage: emptyMessage,
            isLoading: isLoading,
            isError: isError,
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget _sectionCard(
    BuildContext context, {
    required OpenJobsState state,
    required List<JobItem> jobs,
    required String emptyMessage,
    required bool isLoading,
    required bool isError,
  }) {
    if (isLoading) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: ColorsManager.lightGrey),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (isError) {
      final message = state.when(
        initial: () => '',
        loading: () => '',
        loadingMore: (_, _) => '',
        success: (_, _, _) => '',
        error: (message) => message,
      );
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: ColorsManager.lightGrey),
        ),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 34.r, color: Colors.redAccent),
            SizedBox(height: 10.h),
            Text(
              'فشل تحميل الوظائف',
              style: TextStyles.font16BlackMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),
            Text(
              message,
              style: TextStyles.font12BlackMedium.copyWith(
                color: ColorsManager.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: () => context.read<OpenJobsCubit>().fetchOpenJobs(),
              child: const Text('أعد المحاولة'),
            ),
          ],
        ),
      );
    }

    if (jobs.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: ColorsManager.lightGrey),
        ),
        child: Column(
          children: [
            Icon(Icons.work_outline, size: 34.r, color: ColorsManager.grey),
            SizedBox(height: 10.h),
            Text(
              emptyMessage,
              style: TextStyles.font16BlackMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          jobs.length,
          (i) => Padding(
            padding: EdgeInsets.only(right: i == jobs.length - 1 ? 0 : 12.w),
            child: SizedBox(
              width: 380.w,
              child: HomeJobCard(job: jobs[i]),
            ),
          ),
        ),
      ),
    );
  }
}
