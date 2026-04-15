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
import 'package:sheftaya/features/worker/home/logic/job_recommendation/job_recommendation_cubit.dart';
import 'package:sheftaya/features/worker/home/logic/job_recommendation/jobs_recommendations_state.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/header_widget.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/home_job_card.dart';

class WorkerHomeScreenBody extends StatefulWidget {
  const WorkerHomeScreenBody({super.key});

  @override
  State<WorkerHomeScreenBody> createState() => _WorkerHomeScreenBodyState();
}

class _WorkerHomeScreenBodyState extends State<WorkerHomeScreenBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<JobsRecommendationsCubit>().fetchRecommendations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenJobsCubit, OpenJobsState>(
      builder: (context, openState) {
        final openJobs = _extractOpenJobs(openState);
        final openIsLoading = _isOpenJobsLoading(openState);
        final openIsError = _isOpenJobsError(openState);
        final openErrorMessage = _extractOpenJobsErrorMessage(openState);

        return SingleChildScrollView(
          child: Column(
            children: [
              HeaderWidget(jobs: openJobs),
              SizedBox(height: 12.h),

              BlocBuilder<
                JobsRecommendationsCubit,
                JobsRecommendationsState<List<JobItem>>
              >(
                builder: (context, recState) {
                  final recommendedJobs = _extractRecommendedJobs(recState);
                  final recIsLoading = _isRecommendedJobsLoading(recState);
                  final recIsError = _isRecommendedJobsError(recState);
                  final recErrorMessage = _extractRecommendedJobsErrorMessage(
                    recState,
                  );

                  return _section(
                    context,
                    title: 'وظائف مقترحه لك',
                    jobs: recommendedJobs,
                    emptyMessage: 'لا توجد وظائف مقترحة حالياً',
                    isLoading: recIsLoading,
                    isError: recIsError,
                    errorMessage: recErrorMessage,
                    onRetry: () => context
                        .read<JobsRecommendationsCubit>()
                        .fetchRecommendations(),
                  );
                },
              ),

              _section(
                context,
                title: 'وظائف حالية',
                jobs: openJobs,
                emptyMessage: 'لا توجد وظائف حالية',
                isLoading: openIsLoading,
                isError: openIsError,
                errorMessage: openErrorMessage,
                onRetry: () => context.read<OpenJobsCubit>().fetchOpenJobs(),
              ),

              SizedBox(height: 12.h),
            ],
          ),
        );
      },
    );
  }

  List<JobItem> _extractOpenJobs(OpenJobsState state) {
    return state.when(
      initial: () => <JobItem>[],
      loading: () => <JobItem>[],
      loadingMore: (previous, nextPage) => previous.data ?? <JobItem>[],
      success: (data, page, hasNextPage) => data.data ?? <JobItem>[],
      error: (message) => <JobItem>[],
    );
  }

  bool _isOpenJobsLoading(OpenJobsState state) {
    return state.when(
      initial: () => true,
      loading: () => true,
      loadingMore: (previous, nextPage) => false,
      success: (data, page, hasNextPage) => false,
      error: (message) => false,
    );
  }

  bool _isOpenJobsError(OpenJobsState state) {
    return state.when(
      initial: () => false,
      loading: () => false,
      loadingMore: (previous, nextPage) => false,
      success: (data, page, hasNextPage) => false,
      error: (message) => true,
    );
  }

  String _extractOpenJobsErrorMessage(OpenJobsState state) {
    return state.when(
      initial: () => '',
      loading: () => '',
      loadingMore: (previous, nextPage) => '',
      success: (data, page, hasNextPage) => '',
      error: (message) => message,
    );
  }

  List<JobItem> _extractRecommendedJobs(
    JobsRecommendationsState<List<JobItem>> state,
  ) {
    return state.when(
      initial: () => <JobItem>[],
      loading: () => <JobItem>[],
      success: (data) => data,
      error: (error) => <JobItem>[],
    );
  }

  bool _isRecommendedJobsLoading(
    JobsRecommendationsState<List<JobItem>> state,
  ) {
    return state.when(
      initial: () => true,
      loading: () => true,
      success: (data) => false,
      error: (error) => false,
    );
  }

  bool _isRecommendedJobsError(JobsRecommendationsState<List<JobItem>> state) {
    return state.when(
      initial: () => false,
      loading: () => false,
      success: (data) => false,
      error: (error) => true,
    );
  }

  String _extractRecommendedJobsErrorMessage(
    JobsRecommendationsState<List<JobItem>> state,
  ) {
    return state.when(
      initial: () => '',
      loading: () => '',
      success: (data) => '',
      error: (error) => error,
    );
  }

  Widget _section(
    BuildContext context, {
    required String title,
    required List<JobItem> jobs,
    required String emptyMessage,
    required bool isLoading,
    required bool isError,
    required String errorMessage,
    required VoidCallback onRetry,
  }) {
    final hasJobs = jobs.isNotEmpty;

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
            jobs: jobs,
            emptyMessage: emptyMessage,
            isLoading: isLoading,
            isError: isError,
            errorMessage: errorMessage,
            onRetry: onRetry,
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget _sectionCard({
    required List<JobItem> jobs,
    required String emptyMessage,
    required bool isLoading,
    required bool isError,
    required String errorMessage,
    required VoidCallback onRetry,
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
              errorMessage,
              style: TextStyles.font12BlackMedium.copyWith(
                color: ColorsManager.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: onRetry,
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
            padding: EdgeInsets.only(left: i == jobs.length - 1 ? 0 : 16.w),
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
