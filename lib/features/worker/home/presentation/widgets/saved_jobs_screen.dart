import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/features/employer/home/data/models/job_model.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/home_job_card.dart';
import 'package:sheftaya/features/worker/service/saved_jobs_service.dart';

class SavedJobsScreen extends StatelessWidget {
  const SavedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الوظائف المحفوظة', style: TextStyles.font18BlackBold),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<JobModel>>(
        future: SavedJobsService.getSavedJobs(),
        builder: (_, snapshot) {
          final jobs = snapshot.data ?? [];
          if (jobs.isEmpty) {
            return Center(
              child: Text(
                'لا توجد وظائف محفوظة',
                style: TextStyles.font18SecondaryBold,
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemBuilder: (_, i) => HomeJobCard(job: jobs[i]),
            separatorBuilder: (_, _) => SizedBox(height: 12.h),
            itemCount: jobs.length,
          );
        },
      ),
    );
  }
}
