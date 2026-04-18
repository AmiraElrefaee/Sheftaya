import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/features/employer/home/presentation/widgets/empty_state_widget.dart';
import 'package:sheftaya/features/employer/home/presentation/widgets/header_widget.dart';
import 'package:sheftaya/features/employer/home/presentation/widgets/home_job_card.dart';
import 'package:sheftaya/features/worker/my_application_jobs/data/models/my_jobs_response.dart';
import 'package:sheftaya/features/worker/my_application_jobs/logic/my_jobs_cubit.dart';
import 'package:sheftaya/features/worker/my_application_jobs/logic/my_jobs_state.dart';

class EmployerHomeScreenBody extends StatefulWidget {
  const EmployerHomeScreenBody({super.key});

  @override
  State<EmployerHomeScreenBody> createState() => _EmployerHomeScreenBodyState();
}

class _EmployerHomeScreenBodyState extends State<EmployerHomeScreenBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MyJobsCubit>().fetchMyJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MyJobsCubit, MyJobsState>(
        builder: (context, state) {
          return state.when(
            initial: () => _buildBody(context, [], isLoading: true),
            loading: () => _buildBody(context, [], isLoading: true),
            success: (data) {
              final jobs = (data.data ?? [])
                  .where(
                    (e) =>
                        (e.jobStatus ?? e.job?.status) == 'open' ||
                        (e.jobStatus ?? e.job?.status) == 'active',
                  )
                  .toList();

              return _buildBody(context, jobs);
            },
            error: (msg) => _buildBody(context, [], errorMsg: msg),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    List<MyJobItem> jobs, {
    bool isLoading = false,
    String? errorMsg,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const HeaderWidget(),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: AppTextButton(
              buttonText: 'نشر وظيفة جديده',
              onPressed: () {
                GoRouter.of(context).push(AppRouter.kPublishJobView);
              },
            ),
          ),
          SizedBox(height: 12.h),
          if (isLoading)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                height: 120.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
            )
          else if (errorMsg != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 40.r,
                      color: Colors.redAccent,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'فشل تحميل الوظائف',
                      style: TextStyles.font14BlackMedium,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      errorMsg,
                      style: TextStyles.font12BlackMedium.copyWith(
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: 160.w,
                      child: AppTextButton(
                        buttonText: 'إعادة المحاولة',
                        buttonHeight: 40,
                        onPressed: () {
                          context.read<MyJobsCubit>().fetchMyJobs();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (jobs.isEmpty)
            const EmptyStateWidget()
          else ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('وظائفى المنشوره', style: TextStyles.font18BlackBold),
                  TextButton(
                    onPressed: () {
                      context.push(AppRouter.kMyPostedJobsScreen, extra: jobs);
                    },
                    child: Text(
                      'رؤيه الكل',
                      style: TextStyles.font12SecondaryBold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: jobs
                    .take(2)
                    .map(
                      (job) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: HomeJobCard(
                          item: job,
                          onPressed: () => GoRouter.of(context).push(
                            AppRouter.kEmployerJobDetailsScreen,
                            extra: job,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
