import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/features/worker/my_application_jobs/data/models/my_jobs_response.dart';
import 'package:sheftaya/features/worker/my_application_jobs/logic/my_jobs_cubit.dart';
import 'package:sheftaya/features/worker/my_application_jobs/logic/my_jobs_state.dart';
import 'my_job_card.dart';

class EmployerMyJobsScreenBody extends StatefulWidget {
  const EmployerMyJobsScreenBody({super.key});

  @override
  State<EmployerMyJobsScreenBody> createState() =>
      _EmployerMyJobsScreenBodyState();
}

class _EmployerMyJobsScreenBodyState extends State<EmployerMyJobsScreenBody>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MyJobsCubit>().fetchMyJobs();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _header(),
        Expanded(
          child: BlocBuilder<MyJobsCubit, MyJobsState>(
            builder: (context, state) {
              return state.when(
                initial: () => const Center(child: CircularProgressIndicator()),
                loading: () => const Center(child: CircularProgressIndicator()),
                success: (data) {
                  final all = data.data ?? [];
                  final active = all
                      .where(
                        (e) =>
                            (e.jobStatus ?? e.job?.status) == 'open' ||
                            (e.jobStatus ?? e.job?.status) == 'active',
                      )
                      .toList();
                  final completed = all
                      .where(
                        (e) => (e.jobStatus ?? e.job?.status) == 'completed',
                      )
                      .toList();
                  final reports = all
                      .where(
                        (e) => [
                          'reportUnderReview',
                          'reportResolved',
                        ].contains(e.jobStatus ?? e.job?.status),
                      )
                      .toList();

                  return TabBarView(
                    controller: _controller,
                    children: [
                      _JobsList(
                        items: all,
                        emptyTitle: 'لا توجد وظائف',
                        emptySubtitle: 'لم تنشر أي وظائف حتى الآن',
                      ),
                      _JobsList(
                        items: active,
                        emptyTitle: 'لا توجد وظائف نشطة',
                        emptySubtitle: 'ستظهر وظائفك النشطة هنا',
                        notice: '⚠️ سيتم إشعارك بطلبات العمال لاختيار الأنسب',
                      ),
                      _JobsList(
                        items: completed,
                        emptyTitle: 'لا توجد وظائف مكتملة',
                        emptySubtitle: 'ستظهر وظائفك المكتملة هنا',
                      ),
                      _JobsList(
                        items: reports,
                        emptyTitle: 'لا توجد بلاغات',
                        emptySubtitle: 'ستظهر البلاغات المقدمة هنا',
                        notice: '⚠️ سيتم مراجعة الشكاوى والرد في أقرب وقت.',
                      ),
                    ],
                  );
                },
                error: (msg) => _ErrorWidget(
                  msg: msg,
                  onRetry: () => context.read<MyJobsCubit>().fetchMyJobs(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 48.h),
          Text('وظائفي', style: TextStyles.font18BlackBold),
          SizedBox(height: 12.h),
          TabBar(
            controller: _controller,
            indicatorColor: ColorsManager.primary,
            labelColor: ColorsManager.primary,
            unselectedLabelColor: ColorsManager.grey,
            tabs: const [
              Tab(text: 'الكل'),
              Tab(text: 'منشورة'),
              Tab(text: 'مكتملة'),
              Tab(text: 'بلاغات'),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Jobs List ──────────────────────────────────────────────────────────────

class _JobsList extends StatelessWidget {
  final List<MyJobItem> items;
  final String emptyTitle;
  final String emptySubtitle;
  final String? notice;

  const _JobsList({
    required this.items,
    required this.emptyTitle,
    required this.emptySubtitle,
    this.notice,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyState(title: emptyTitle, subtitle: emptySubtitle);
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: items.length + (notice != null ? 1 : 0),
      itemBuilder: (_, index) {
        if (notice != null && index == 0) {
          return Column(
            children: [
              _NoticeCard(text: notice!),
              SizedBox(height: 12.h),
            ],
          );
        }
        final item = items[notice != null ? index - 1 : index];
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: EmployerJobCard(
            item: item,
            onTap: () {
              context.push(AppRouter.kEmployerJobDetailsScreen, extra: item);
            },
          ),
        );
      },
    );
  }
}

// ─── Empty State ────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EmptyState({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: ColorsManager.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.work_outline_rounded,
                size: 40.sp,
                color: ColorsManager.primary,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: TextStyles.font16BlackBold,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              style: TextStyles.font14BlackRegular.copyWith(
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

// ─── Error Widget ────────────────────────────────────────────────────────────

class _ErrorWidget extends StatelessWidget {
  final String msg;
  final VoidCallback onRetry;

  const _ErrorWidget({required this.msg, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48.r, color: Colors.redAccent),
          SizedBox(height: 12.h),
          Text(
            msg,
            style: TextStyles.font14BlackMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}

// ─── Notice Card ─────────────────────────────────────────────────────────────

class _NoticeCard extends StatelessWidget {
  final String text;
  const _NoticeCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorsManager.lightGrey.withValues(alpha: .4),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorsManager.lightGrey),
      ),
      child: Text(text, style: TextStyles.font12SecondarySemiBold),
    );
  }
}
