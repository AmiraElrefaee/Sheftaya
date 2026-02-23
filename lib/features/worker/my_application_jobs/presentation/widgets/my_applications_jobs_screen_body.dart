import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/features/employer/home/data/models/job_model.dart';
import 'package:sheftaya/features/worker/my_application_jobs/presentation/widgets/worker_jobs_list.dart';

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<JobModel> _filter(JobStatus? status) {
    if (status == null) return workerJobs;
    return workerJobs.where((e) => e.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _header(),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: [
              WorkerJobsList(jobs: workerJobs),
              WorkerJobsList(
                jobs: workerJobs
                    .where(
                      (e) =>
                          e.status == JobStatus.active ||
                          e.status == JobStatus.accepted,
                    )
                    .toList(),
                infoNotice:
                    '​​⚠️ ​️ سيتم إشعارك فى حالة تم قبول طلبك من صاحب العمل',
              ),
              WorkerJobsList(jobs: _filter(JobStatus.completed)),
              WorkerJobsList(jobs: _filter(JobStatus.rejected)),
              WorkerJobsList(
                infoNotice:
                    '​​⚠️ ​️ سيتم مراجعة الشكاوى والرد فى اقرب وقت. يمكنك متابعة حالة طلبك هنا او التواصل مع الدعم الفني.',
                jobs: workerJobs
                    .where(
                      (e) =>
                          e.status == JobStatus.reportUnderReview ||
                          e.status == JobStatus.reportResolved,
                    )
                    .toList(),
              ),
            ],
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

final List<JobModel> workerJobs = const [
  JobModel(
    id: '1',
    title: 'نادل',
    company: 'Center Perk Cafe',
    location: 'بورفؤاد، شارع الجمهورية',
    salary: 400,
    postedAt: 'منذ 5 دقائق',
    status: JobStatus.active,
    applicantsCount: 4,
    imageUrl: 'https://images.unsplash.com/photo-1559925393-8be0ec4767c8',
    offersCount: 2,
  ),
  JobModel(
    id: '2',
    title: 'باريستا',
    company: 'Coffee House',
    location: 'بورسعيد، شارع طرح البحر',
    salary: 450,
    postedAt: 'منذ ساعتين',
    status: JobStatus.reportUnderReview,
    applicantsCount: 2,
    shiftTime: '2 ظهرا',
    shiftDate: '5 ديسمبر',
    shiftHours: 6,
    withoutExperience: false,
    offersCount: 0,
  ),
  JobModel(
    id: '3',
    title: 'كاشير',
    company: 'Market Plus',
    location: 'بورفؤاد، شارع الأمين',
    salary: 350,
    postedAt: 'منذ يوم',
    status: JobStatus.completed,
    applicantsCount: 6,
    shiftTime: '10 صباحا',
    shiftDate: '1 ديسمبر',
    shiftHours: 8,
    withoutExperience: false,
    offersCount: 5,
  ),
  JobModel(
    id: '4',
    title: 'عامل نظافة',
    company: 'Clean Co',
    location: 'بورسعيد، شارع النصر',
    salary: 300,
    postedAt: 'منذ 3 أيام',
    status: JobStatus.reportResolved,
    applicantsCount: 1,
    imageUrl: '',
    offersCount: 0,
  ),
  JobModel(
    id: '5',
    title: 'موظف',
    company: 'Center Perk Cafe',
    location: 'بورفؤاد، شارع الجمهورية',
    salary: 400,
    postedAt: 'منذ 5 دقائق',
    status: JobStatus.rejected,
    applicantsCount: 4,
    imageUrl: 'https://images.unsplash.com/photo-1559925393-8be0ec4767c8',
    offersCount: 2,
  ),
  JobModel(
    id: '3',
    title: 'كاشير',
    company: 'Market Plus',
    location: 'بورفؤاد، شارع الأمين',
    salary: 350,
    postedAt: 'منذ يوم',
    status: JobStatus.accepted,
    applicantsCount: 6,
    shiftTime: '10 صباحا',
    shiftDate: '1 ديسمبر',
    shiftHours: 8,
    withoutExperience: false,
    offersCount: 5,
  ),
];
