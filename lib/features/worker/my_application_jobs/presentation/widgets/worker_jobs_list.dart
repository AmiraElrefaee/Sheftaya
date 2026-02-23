import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/features/employer/home/data/models/job_model.dart';
import 'package:sheftaya/features/worker/my_application_jobs/presentation/widgets/my_applications_job_card.dart';

class WorkerJobsList extends StatelessWidget {
  final List<JobModel> jobs;
  final String? infoNotice;

  const WorkerJobsList({super.key, required this.jobs, this.infoNotice});

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return Center(
        child: Text('لا توجد وظائف', style: TextStyles.font18SecondaryBold),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: jobs.length + (infoNotice != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (infoNotice != null && index == 0) {
          return Column(
            children: [
              InfoNotice(text: infoNotice!),
              SizedBox(height: 12.h),
            ],
          );
        }

        final job = jobs[infoNotice != null ? index - 1 : index];
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: MyApplicationsJobCard(job: job),
        );
      },
    );
  }
}

class InfoNotice extends StatelessWidget {
  final String text;

  const InfoNotice({super.key, required this.text});

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
