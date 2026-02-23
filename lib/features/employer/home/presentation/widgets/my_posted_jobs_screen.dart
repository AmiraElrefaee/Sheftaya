import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/features/employer/home/data/models/job_model.dart';
import 'package:sheftaya/features/employer/home/presentation/widgets/home_job_card.dart';

class MyPostedJobsScreen extends StatelessWidget {
  final List<JobModel> jobs;

  const MyPostedJobsScreen({super.key, required this.jobs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('وظائفى المنشوره', style: TextStyles.font18BlackBold),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        itemBuilder: (_, i) => HomeJobCard(job: jobs[i]),
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemCount: jobs.length,
      ),
    );
  }
}
