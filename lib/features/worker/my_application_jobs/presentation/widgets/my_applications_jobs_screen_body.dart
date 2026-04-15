import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                      _ApplicationsList(items: all, notice: null),
                      _ApplicationsList(
                        items: all
                            .where((e) => e.applicationStatus == 'pending')
                            .toList(),
                        notice:
                            '⚠️ سيتم إشعارك فور اتخاذ صاحب العمل قراراً بشأن طلبك',
                      ),
                      _ApplicationsList(
                        items: all
                            .where((e) => e.applicationStatus == 'completed')
                            .toList(),
                        notice: null,
                      ),
                      _ApplicationsList(
                        items: all
                            .where((e) => e.applicationStatus == 'rejected')
                            .toList(),
                        notice: null,
                      ),
                      _ApplicationsList(
                        items: all
                            .where(
                              (e) => [
                                'reportUnderReview',
                                'reportResolved',
                              ].contains(e.applicationStatus),
                            )
                            .toList(),
                        notice:
                            '⚠️ سيتم مراجعة الشكاوى والرد في أقرب وقت. يمكنك متابعة حالة طلبك هنا أو التواصل مع الدعم الفني.',
                      ),
                    ],
                  );
                },
                error: (msg) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48.r,
                        color: Colors.redAccent,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        msg,
                        style: TextStyles.font14BlackMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<MyJobsCubit>().fetchMyJobs(),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
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

// ─── قائمة التقديمات ──────────────────────────────────────────────────────

class _ApplicationsList extends StatelessWidget {
  final List<MyJobItem> items;
  final String? notice;

  const _ApplicationsList({required this.items, this.notice});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text('لا توجد تقديمات', style: TextStyles.font16SecondaryMedium),
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
          child: WorkerApplicationCard(item: item),
        );
      },
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
