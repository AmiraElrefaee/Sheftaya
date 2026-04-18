import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/features/worker/my_application_jobs/data/models/my_jobs_response.dart';

class WorkerApplicationCard extends StatelessWidget {
  final MyJobItem item;
  final VoidCallback? onTapDetails;

  const WorkerApplicationCard({
    super.key,
    required this.item,
    this.onTapDetails,
  });

  @override
  Widget build(BuildContext context) {
    final job = item.job;
    final imageUrl = job?.jobImages?.isNotEmpty == true
        ? job!.jobImages!.first
        : null;
    final company = job?.place ?? '';
    final title = job?.title ?? '';
    final appliedAt = _formatDate(item.appliedAt);
    final statusInfo = _statusOf(item.applicationStatus);
    final showDetailsButton = _canShowDetailsButton(item.applicationStatus);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.lightGrey,
            blurRadius: 4.r,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          right: BorderSide(color: statusInfo.color, width: 6.w),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        height: 72.h,
                        width: 72.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _placeholder(),
                      )
                    : _placeholder(),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, style: TextStyles.font16BlackBold),
                    SizedBox(height: 2.h),
                    if (company.isNotEmpty)
                      Text(company, style: TextStyles.font14BlackMedium),
                    if (appliedAt.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        appliedAt,
                        style: TextStyles.font12BlackMedium.copyWith(
                          color: ColorsManager.darkGrey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: statusInfo.color.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      statusInfo.label,
                      style: TextStyles.font12BlackBold.copyWith(
                        color: statusInfo.color,
                      ),
                    ),
                  ),
                  if (showDetailsButton && onTapDetails != null) ...[
                    SizedBox(height: 4.h),
                    SizedBox(
                      width: 76.w,
                      child: AppTextButton(
                        borderRadius: 8.r,
                        buttonText: 'التفاصيل',
                        textStyle: TextStyles.font12WhiteBold,
                        buttonHeight: 20.h,
                        onPressed: onTapDetails!,
                        backgroundColor: ColorsManager.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
    height: 72.h,
    width: 72.w,
    decoration: BoxDecoration(
      color: ColorsManager.lightGrey,
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: const Icon(Icons.business, color: ColorsManager.grey),
  );

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      String relativeDays(DateTime dt) {
        final diff = DateTime.now().difference(dt);
        if (diff.inMinutes < 60) return '${diff.inMinutes} دقيقة';
        if (diff.inHours < 24) return '${diff.inHours} ساعة';
        return '${diff.inDays} يوم';
      }

      return 'منذ ${relativeDays(dt)}';
    } catch (_) {
      return dateStr;
    }
  }

  bool _canShowDetailsButton(String? status) {
    switch (status) {
      case 'pending':
      case 'accepted':
        return true;
      default:
        return false;
    }
  }

  _StatusInfo _statusOf(String? status) {
    switch (status) {
      case 'pending':
        return _StatusInfo('قيد الانتظار', ColorsManager.primary);
      case 'accepted':
        return _StatusInfo('تم القبول', ColorsManager.success);
      case 'rejected':
        return _StatusInfo('مرفوضة', ColorsManager.error);
      case 'completed':
        return _StatusInfo('مكتملة', ColorsManager.success);
      case 'reportUnderReview':
        return _StatusInfo('بلاغ قيد المراجعة', ColorsManager.warning);
      case 'reportResolved':
        return _StatusInfo('تم الحل', ColorsManager.success);
      default:
        return _StatusInfo('غير معروف', ColorsManager.grey);
    }
  }
}

class _StatusInfo {
  final String label;
  final Color color;
  _StatusInfo(this.label, this.color);
}
