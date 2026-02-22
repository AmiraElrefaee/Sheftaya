import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/features/employer/home/data/models/job_model.dart';

class MyJobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback? onTap;

  const MyJobCard({super.key, required this.job, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border(
          right: BorderSide(color: _statusColor(job.status), width: 6.w),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          /// Image
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

          /// Info
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

          StatusActionButton(status: job.status, onTap: onTap),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: 80.h,
      width: 80.w,
      decoration: BoxDecoration(
        color: ColorsManager.lightGrey,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: const Icon(Icons.image, color: ColorsManager.grey),
    );
  }

  Color _statusColor(JobStatus status) {
    switch (status) {
      case JobStatus.active:
        return ColorsManager.primary;
      case JobStatus.completed:
        return ColorsManager.success;
      case JobStatus.reportResolved:
        return ColorsManager.success;
      case JobStatus.reportUnderReview:
        return ColorsManager.warning;
    }
  }
}

class StatusActionButton extends StatelessWidget {
  final JobStatus status;
  final VoidCallback? onTap;

  const StatusActionButton({super.key, required this.status, this.onTap});

  @override
  Widget build(BuildContext context) {
    final data = _map(status);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: data.bg,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Text(
          data.text,
          style: TextStyles.font12BlackMedium.copyWith(color: data.color),
        ),
      ),
    );
  }

  _StatusData _map(JobStatus status) {
    switch (status) {
      case JobStatus.active:
        return _StatusData(
          'عرض التفاصيل',
          ColorsManager.primary.withValues(alpha: .12),
          ColorsManager.primary,
        );
      case JobStatus.completed:
        return _StatusData(
          'مكتملة',
          ColorsManager.success.withValues(alpha: .12),
          ColorsManager.success,
        );
      case JobStatus.reportUnderReview:
        return _StatusData(
          'بلاغ قيد المراجعة',
          ColorsManager.warning.withValues(alpha: .12),
          ColorsManager.warning,
        );
      case JobStatus.reportResolved:
        return _StatusData(
          'تم الحل',
          ColorsManager.success.withValues(alpha: .12),
          ColorsManager.success,
        );
    }
  }
}

class _StatusData {
  final String text;
  final Color bg;
  final Color color;

  _StatusData(this.text, this.bg, this.color);
}
