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
import 'package:sheftaya/features/worker/my_application_jobs/presentation/widgets/my_applications_job_card.dart';

class MyApplicationsJobsScreenBody extends StatefulWidget {
  const MyApplicationsJobsScreenBody({super.key});

  @override
  State<MyApplicationsJobsScreenBody> createState() =>
      _MyApplicationsJobsScreenBodyState();
}

class _MyApplicationsJobsScreenBodyState
    extends State<MyApplicationsJobsScreenBody>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 5, vsync: this);
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
                  return TabBarView(
                    controller: _controller,
                    children: [
                      _AppList(
                        items: all,
                        emptyTitle: 'لم تقدم على أي وظيفة',
                        emptySubtitle: 'ابحث عن وظائف وقدم عليها الآن',
                        emptyIcon: Icons.work_outline_rounded,
                      ),
                      _AppList(
                        items: all
                            .where(
                              (e) =>
                                  e.applicationStatus == 'pending' ||
                                  e.applicationStatus == 'accepted',
                            )
                            .toList(),
                        emptyTitle: 'لا توجد طلبات قيد الانتظار',
                        emptySubtitle:
                            'طلباتك المنتظرة قرار صاحب العمل ستظهر هنا',
                        emptyIcon: Icons.hourglass_empty_rounded,
                        notice:
                            '⚠️ سيتم إشعارك فور اتخاذ صاحب العمل قراراً بشأن طلبك',
                      ),
                      _AppList(
                        items: all
                            .where((e) => e.applicationStatus == 'completed')
                            .toList(),
                        emptyTitle: 'لا توجد وظائف مكتملة',
                        emptySubtitle: 'وظائفك المكتملة ستظهر هنا',
                        emptyIcon: Icons.check_circle_outline_rounded,
                      ),
                      _AppList(
                        items: all
                            .where((e) => e.applicationStatus == 'rejected')
                            .toList(),
                        emptyTitle: 'لا توجد طلبات مرفوضة',
                        emptySubtitle: 'ليس لديك طلبات مرفوضة حالياً',
                        emptyIcon: Icons.cancel_outlined,
                      ),
                      _AppList(
                        items: all
                            .where(
                              (e) => [
                                'reportUnderReview',
                                'reportResolved',
                              ].contains(e.applicationStatus),
                            )
                            .toList(),
                        emptyTitle: 'لا توجد بلاغات',
                        emptySubtitle: 'ليس لديك بلاغات مقدمة حالياً',
                        emptyIcon: Icons.report_outlined,
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
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 48.h),
          Text('تقديماتي', style: TextStyles.font18BlackBold),
          SizedBox(height: 12.h),
          TabBar(
            padding: EdgeInsets.zero,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            controller: _controller,
            indicatorColor: ColorsManager.primary,
            labelColor: ColorsManager.primary,
            unselectedLabelColor: ColorsManager.grey,
            labelPadding: EdgeInsets.symmetric(horizontal: 18.w),
            tabs: const [
              Tab(text: 'الكل'),
              Tab(text: 'قيد الانتظار'),
              Tab(text: 'مكتملة'),
              Tab(text: 'مرفوضة'),
              Tab(text: 'بلاغات'),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppList extends StatelessWidget {
  final List<MyJobItem> items;
  final String emptyTitle;
  final String emptySubtitle;
  final IconData emptyIcon;
  final String? notice;

  const _AppList({
    required this.items,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.emptyIcon,
    this.notice,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
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
                  emptyIcon,
                  size: 40.sp,
                  color: ColorsManager.primary,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                emptyTitle,
                style: TextStyles.font16BlackBold,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                emptySubtitle,
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
          padding: EdgeInsets.only(bottom: 16.h),
          child: WorkerApplicationCard(
            item: item,
            onTapDetails: _showDetails(context, item),
          ),
        );
      },
    );
  }

  VoidCallback? _showDetails(BuildContext context, MyJobItem item) {
    final jobId = item.job?.id ?? '';
    if (jobId.isEmpty) return null;

    if (item.applicationStatus != 'pending' &&
        item.applicationStatus != 'accepted') {
      return null;
    }

    return () {
      context.push(AppRouter.kJobDetailsScreen, extra: jobId);
    };
  }
}

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
