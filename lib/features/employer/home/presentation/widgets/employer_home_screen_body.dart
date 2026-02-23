import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/features/employer/home/data/models/job_model.dart';
import 'package:sheftaya/features/employer/home/presentation/widgets/empty_state_widget.dart';
import 'package:sheftaya/features/employer/home/presentation/widgets/header_widget.dart';
import 'package:sheftaya/features/employer/home/presentation/widgets/home_job_card.dart';

class EmployerHomeScreenBody extends StatefulWidget {
  const EmployerHomeScreenBody({super.key});

  @override
  State<EmployerHomeScreenBody> createState() => _EmployerHomeScreenBodyState();
}

class _EmployerHomeScreenBodyState extends State<EmployerHomeScreenBody> {
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderWidget(),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: AppTextButton(
                buttonText: 'نشر وظيفة جديده',
                onPressed: () {},
              ),
            ),
            SizedBox(height: 12.h),
            if (jobs.isEmpty)
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
                        context.push(
                          AppRouter.kMyPostedJobsScreen,
                          extra: jobs,
                        );
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
                      .map(
                        (j) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: HomeJobCard(job: j),
                        ),
                      )
                      .take(2)
                      .toList(),
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ],
        ),
      ),
    );
  }
}
