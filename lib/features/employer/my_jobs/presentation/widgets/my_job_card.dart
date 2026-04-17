import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/features/worker/my_application_jobs/data/models/my_jobs_response.dart';

class EmployerJobCard extends StatelessWidget {
  final MyJobItem item;
  final VoidCallback? onTap;

  const EmployerJobCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final job = item.job;
    final imageUrl = job?.jobImages?.isNotEmpty == true
        ? job!.jobImages!.first
        : null;
    final company = job?.place ?? job?.companyDetails?.companyName ?? '';
    final title = job?.title ?? item.title ?? '';
    final rawStatus = item.jobStatus ?? job?.status ?? 'unknown';
    final statusInfo = _statusOf(rawStatus);
    final postedAt = _formatDate(job?.createdAt ?? item.postedAt);

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // صورة الوظيفة
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
          // البيانات
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyles.font16BlackBold),
                SizedBox(height: 2.h),
                if (company.isNotEmpty)
                  Text(
                    company,
                    style: TextStyles.font14BlackMedium.copyWith(
                      color: ColorsManager.darkGrey,
                    ),
                  ),

                if (postedAt.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    postedAt,
                    style: TextStyles.font12BlackMedium.copyWith(
                      color: ColorsManager.grey,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // باج الحالة
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: statusInfo.color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                statusInfo.label,
                style: TextStyles.font12BlackMedium.copyWith(
                  color: statusInfo.color,
                ),
              ),
            ),
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
      return 'منذ ${_relativeDays(dt)}';
    } catch (_) {
      return dateStr;
    }
  }

  String _relativeDays(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return '${diff.inHours} ساعة';
    return '${diff.inDays} يوم';
  }

  _StatusInfo _statusOf(String status) {
    switch (status) {
      case 'active':
        return _StatusInfo('نشط', ColorsManager.primary);
      case 'completed':
        return _StatusInfo('مكتملة', ColorsManager.success);
      case 'cancelled':
      case 'rejected':
        return _StatusInfo('ملغية', ColorsManager.error);
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
