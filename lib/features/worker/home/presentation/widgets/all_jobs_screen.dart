import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/home_job_card.dart';

class AllJobsScreen extends StatelessWidget {
  final String title;
  final List<dynamic> jobs;

  const AllJobsScreen({super.key, required this.title, required this.jobs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyles.font18BlackBold),
        centerTitle: true,
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
