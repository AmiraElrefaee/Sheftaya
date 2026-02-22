import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/features/employer/home/data/models/job_model.dart';
import 'jobs_list.dart';

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
    _controller = TabController(length: 4, vsync: this);
    super.initState();
  }

  List<JobModel> _filter(JobStatus? status) {
    if (status == null) return jobs;
    return jobs.where((e) => e.status == status).toList();
  }

  List<JobModel> get _reports => jobs
      .where(
        (e) =>
            e.status == JobStatus.reportUnderReview ||
            e.status == JobStatus.reportResolved,
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _header(),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: [
              JobsList(jobs: jobs),
              JobsList(
                jobs: _filter(JobStatus.active),
                infoNotice: '⚠️ سيتم إشعارك بطلبات العمال لاختيار الأنسب لك',
              ),
              JobsList(jobs: _filter(JobStatus.completed)),
              JobsList(
                jobs: _reports,
                infoNotice:
                    '​​⚠️ ​️ سيتم مراجعة الشكاوى والرد فى اقرب وقت. يمكنك متابعة حالة طلبك هنا او التواصل مع الدعم الفني.',
              ),
            ],
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

final List<JobModel> jobs = const [
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
    status: JobStatus.reportResolved,
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
    title: 'نظافة',
    company: 'Clean Co',
    location: 'بورسعيد، شارع النصر',
    salary: 300,
    postedAt: 'منذ 3 أيام',
    status: JobStatus.reportUnderReview,
    applicantsCount: 1,
    imageUrl: '',
    offersCount: 0,
  ),
];
