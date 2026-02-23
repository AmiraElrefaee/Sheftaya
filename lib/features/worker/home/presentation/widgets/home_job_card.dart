import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/features/employer/home/data/models/job_model.dart';
import 'package:sheftaya/features/worker/service/saved_jobs_service.dart';

class HomeJobCard extends StatelessWidget {
  final JobModel job;

  const HomeJobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: ColorsManager.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: job.imageUrl != null && job.imageUrl!.isNotEmpty
                    ? Image.network(
                        job.imageUrl!,
                        height: 80.h,
                        width: 80.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _placeholder(),
                      )
                    : _placeholder(),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.title, style: TextStyles.font18BlackBold),
                    SizedBox(height: 2.h),
                    Text(
                      job.company,
                      style: TextStyles.font14BlackSemiBold.copyWith(
                        color: ColorsManager.darkGrey,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      job.postedAt,
                      style: TextStyles.font12BlackMedium.copyWith(
                        color: ColorsManager.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              FutureBuilder<bool>(
                future: SavedJobsService.isSaved(job.id),
                builder: (_, snapshot) {
                  final saved = snapshot.data ?? false;
                  return IconButton(
                    onPressed: () async {
                      await SavedJobsService.toggleJob(job);
                      (context as Element).markNeedsBuild();
                    },
                    icon: Icon(
                      size: 32.sp,
                      saved ? Icons.bookmark : Icons.bookmark_border,
                      color: ColorsManager.primary,
                    ),
                  );
                },
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Row(
            children: [
              Icon(
                FontAwesomeIcons.locationDot,
                size: 14.sp,
                color: ColorsManager.primary,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  job.location,
                  style: TextStyles.font14BlackMedium.copyWith(
                    color: ColorsManager.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _applicantsBadge(job.applicantsCount),
            ],
          ),

          SizedBox(height: 12.h),

          Wrap(
            alignment: WrapAlignment.spaceBetween,

            spacing: 6.w,
            runSpacing: 8.h,
            children: [
              _buildTag('${job.shiftHours} ساعات'),
              _buildTag(job.withoutExperience ? 'بدون خبرة' : 'خبرة مطلوبة'),
              _buildTag(job.shiftDate),
              _buildTag(job.shiftTime),
            ],
          ),

          SizedBox(height: 12.h),

          const Divider(color: ColorsManager.lightGrey, thickness: 1),

          SizedBox(height: 12.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 120.w,
                height: 40.h,
                child: AppTextButton(buttonText: 'التفاصيل', onPressed: () {}),
              ),

              Text(
                '${job.salary.toStringAsFixed(0)} ج',
                style: TextStyles.font20PrimaryBold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _applicantsBadge(int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: ColorsManager.lightGrey.withValues(alpha: .4),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.people_alt_outlined,
            size: 12.sp,
            color: ColorsManager.darkGrey,
          ),
          SizedBox(width: 4.w),
          Text(
            '$count متقدمين',
            style: TextStyles.font12BlackMedium.copyWith(
              color: ColorsManager.darkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: 80.h,
      width: 80.w,
      color: ColorsManager.lightGrey,
      child: const Icon(Icons.image, color: ColorsManager.grey),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: ColorsManager.lightGrey.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(text, style: TextStyles.font14BlackMedium),
    );
  }
}
