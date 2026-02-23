import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/features/employer/home/data/models/job_model.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/header_widget.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/home_job_card.dart';

class WorkerHomeScreenBody extends StatefulWidget {
  const WorkerHomeScreenBody({super.key});

  @override
  State<WorkerHomeScreenBody> createState() => _WorkerHomeScreenBodyState();
}

class _WorkerHomeScreenBodyState extends State<WorkerHomeScreenBody> {
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
    ),
    JobModel(
      id: '2',
      title: 'باريستا',
      company: 'Coffee House',
      location: 'بورسعيد، شارع طرح البحر',
      salary: 450,
      postedAt: 'منذ ساعتين',
      status: JobStatus.reportUnderReview,
    ),
    JobModel(
      id: '3',
      title: 'كاشير',
      company: 'Market Plus',
      location: 'بورفؤاد، شارع الأمين',
      salary: 350,
      postedAt: 'منذ يوم',
      status: JobStatus.completed,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final suggested = jobs.take(2).toList();
    final current = jobs.toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          HeaderWidget(jobs: jobs),

          SizedBox(height: 12.h),

          _section(title: 'وظائف مقترحه لك', jobs: suggested),

          _section(title: 'وظائف حالية', jobs: current),

          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _section({required String title, required List<JobModel> jobs}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyles.font18BlackBold),
              TextButton(
                onPressed: () {
                  context.push(
                    AppRouter.kAllJobsScreen,
                    extra: {'jobs': jobs, 'title': title},
                  );
                },
                child: Text('رؤية الكل', style: TextStyles.font12SecondaryBold),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 332.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemBuilder: (_, i) => SizedBox(
              width: 332.w,
              child: HomeJobCard(job: jobs[i]),
            ),
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemCount: jobs.take(2).length,
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
