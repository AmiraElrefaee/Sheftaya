import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/features/employer/home/presentation/widgets/home_job_card.dart';
import 'package:sheftaya/features/worker/my_application_jobs/logic/my_jobs_cubit.dart';
import 'package:sheftaya/features/worker/my_application_jobs/logic/my_jobs_state.dart';

class MyPostedJobsScreen extends StatefulWidget {
  const MyPostedJobsScreen({super.key});

  @override
  State<MyPostedJobsScreen> createState() => _MyPostedJobsScreenState();
}

class _MyPostedJobsScreenState extends State<MyPostedJobsScreen> {
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('وظائفي المنشورة', style: TextStyles.font18BlackBold),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<MyJobsCubit, MyJobsState>(
        builder: (context, state) {
          return state.when(
            initial: () => _buildLoading(),
            loading: () => _buildLoading(),
            error: (msg) => _buildError(context, msg),
            success: (data) {
              final jobs = (data.data ?? [])
                  .where(
                    (e) =>
                        (e.jobStatus ?? e.job?.status) == 'open' ||
                        (e.jobStatus ?? e.job?.status) == 'active',
                  )
                  .toList();

              if (jobs.isEmpty) {
                return _buildEmpty();
              }

              return ListView.separated(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                itemCount: jobs.length,
                separatorBuilder: (_, _) => SizedBox(height: 12.h),
                itemBuilder: (context, i) {
                  final item = jobs[i];
                  return HomeJobCard(
                    item: item,
                    onPressed: () {
                      context.push(
                        AppRouter.kEmployerJobDetailsScreen,
                        extra: item,
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(BuildContext context, String msg) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 44.r, color: Colors.redAccent),
            SizedBox(height: 10.h),
            Text(
              'فشل تحميل الوظائف',
              style: TextStyles.font14BlackBold,
            ),
            SizedBox(height: 8.h),
            Text(
              msg,
              style: TextStyles.font12BlackMedium.copyWith(
                color: ColorsManager.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: 160.w,
              child: AppTextButton(
                buttonText: 'إعادة المحاولة',
                buttonHeight: 40,
                onPressed: () => context.read<MyJobsCubit>().fetchMyJobs(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: ColorsManager.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.work_off_outlined,
                size: 34.sp,
                color: ColorsManager.primary,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              'لا توجد وظائف منشورة حالياً',
              style: TextStyles.font14BlackBold,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),
            Text(
              'ابدئي بنشر وظيفة جديدة لاستقبال طلبات العمال',
              style: TextStyles.font12BlackMedium.copyWith(
                color: ColorsManager.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}