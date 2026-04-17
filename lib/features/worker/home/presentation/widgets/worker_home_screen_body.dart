import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
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
        final openIsLoading = _isLoading(openState);
        final openIsError = _isError(openState);
        final openErrorMessage = _errorMsg(openState);

        return SingleChildScrollView(
          child: Column(
            children: [
              HeaderWidget(jobs: openJobs),
              SizedBox(height: 12.h),

              // ── Recommendations ──────────────────────────────────────
              BlocBuilder<
                JobsRecommendationsCubit,
                JobsRecommendationsState<List<JobItem>>
              >(
                builder: (context, recState) {
                  final recJobs = recState.when(
                    initial: () => <JobItem>[],
                    loading: () => <JobItem>[],
                    success: (d) => d,
                    error: (_) => <JobItem>[],
                  );
                  final recLoading = recState.when(
                    initial: () => true,
                    loading: () => true,
                    success: (_) => false,
                    error: (_) => false,
                  );
                  final recError = recState.when(
                    initial: () => false,
                    loading: () => false,
                    success: (_) => false,
                    error: (_) => true,
                  );
                  final recMsg = recState.when(
                    initial: () => '',
                    loading: () => '',
                    success: (_) => '',
                    error: (e) => e,
                  );

                  return _Section(
                    title: 'وظائف مقترحة لك',
                    jobs: recJobs,
                    isLoading: recLoading,
                    isError: recError,
                    errorMessage: recMsg,
                    emptyTitle: 'لا توجد وظائف مقترحة',
                    emptySubtitle:
                        'أكمل ملفك الشخصي لتحصل على توصيات مناسبة لك',
                    emptyIcon: Icons.recommend_outlined,
                    onRetry: () => context
                        .read<JobsRecommendationsCubit>()
                        .fetchRecommendations(),
                  );
                },
              ),

              // ── Open Jobs ────────────────────────────────────────────
              _Section(
                title: 'وظائف حالية',
                jobs: openJobs,
                isLoading: openIsLoading,
                isError: openIsError,
                errorMessage: openErrorMessage,
                emptyTitle: 'لا توجد وظائف متاحة',
                emptySubtitle: 'تحقق لاحقاً لمشاهدة الوظائف الجديدة',
                emptyIcon: Icons.work_off_outlined,
                onRetry: () =>
                    context.read<OpenJobsCubit>().fetchOpenJobs(),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

  List<JobItem> _extractOpenJobs(OpenJobsState state) {
    return state.when(
      initial: () => [],
      loading: () => [],
      loadingMore: (prev, _) => prev.data ?? [],
      success: (data, _, _) => data.data ?? [],
      error: (_) => [],
    );
  }

  bool _isLoading(OpenJobsState state) => state.when(
        initial: () => true,
        loading: () => true,
        loadingMore: (_, _) => false,
        success: (_, _, _) => false,
        error: (_) => false,
      );

  bool _isError(OpenJobsState state) => state.when(
        initial: () => false,
        loading: () => false,
        loadingMore: (_, _) => false,
        success: (_, _, _) => false,
        error: (_) => true,
      );

  String _errorMsg(OpenJobsState state) => state.when(
        initial: () => '',
        loading: () => '',
        loadingMore: (_, _) => '',
        success: (_, _, _) => '',
        error: (msg) => msg,
      );
}

// ─── Reusable Section ────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String title;
  final List<JobItem> jobs;
  final bool isLoading;
  final bool isError;
  final String errorMessage;
  final String emptyTitle;
  final String emptySubtitle;
  final IconData emptyIcon;
  final VoidCallback onRetry;

  const _Section({
    required this.title,
    required this.jobs,
    required this.isLoading,
    required this.isError,
    required this.errorMessage,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.emptyIcon,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyles.font18BlackBold),
              if (jobs.isNotEmpty)
                TextButton(
                  onPressed: () => context.push(
                    AppRouter.kAllJobsScreen,
                    extra: {'jobs': jobs, 'title': title},
                  ),
                  child: Text('رؤية الكل',
                      style: TextStyles.font12SecondaryBold),
                ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _content(context),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _content(BuildContext context) {
    if (isLoading) {
      return Container(
        width: double.infinity,
        height: 120.h,
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
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: ColorsManager.lightGrey),
        ),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 40.r, color: Colors.redAccent),
            SizedBox(height: 8.h),
            Text('فشل تحميل الوظائف',
                style: TextStyles.font14BlackMedium),
            SizedBox(height: 12.h),
            SizedBox(
              width: 160.w,
              child: AppTextButton(
                buttonText: 'إعادة المحاولة',
                buttonHeight: 40,
                onPressed: onRetry,
              ),
            ),
          ],
        ),
      );
    }

    if (jobs.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: ColorsManager.lightGrey),
        ),
        child: Column(
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: ColorsManager.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(emptyIcon,
                  size: 30.sp, color: ColorsManager.primary),
            ),
            SizedBox(height: 12.h),
            Text(emptyTitle,
                style: TextStyles.font14BlackBold,
                textAlign: TextAlign.center),
            SizedBox(height: 6.h),
            Text(emptySubtitle,
                style: TextStyles.font12BlackRegular
                    .copyWith(color: ColorsManager.grey),
                textAlign: TextAlign.center),
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
              width: 340.w,
              child: HomeJobCard(job: jobs[i]),
            ),
          ),
        ),
      ),
    );
  }
}