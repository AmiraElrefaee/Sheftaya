import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/features/shift_details/presentation/widget/enums.dart';
import 'package:sheftaya/features/worker/my_application_jobs/data/models/my_jobs_response.dart';

import '../../../../shift_details/data/model/shift_model.dart';

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

    final isActive = rawStatus == 'active' || rawStatus == 'open';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: statusInfo.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  statusInfo.label,
                  style: TextStyles.font12BlackBold.copyWith(
                    color: statusInfo.color,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildButton(
                  context: context,
                  text: 'عرض التفاصيل',
                  icon: Icons.visibility_outlined,
                  onPressed: () => _navigateToJobDetails(context),
                  isPrimary: false,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildButton(
                  context: context,
                  text: isActive ? 'بدء العمل' : 'عرض الوردية',
                  icon: isActive ? Icons.play_arrow_rounded : Icons.history_rounded,
                  onPressed: () => _navigateToShiftDetails(context),
                  isPrimary: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isPrimary
              ? ColorsManager.primary
              : ColorsManager.lightGrey.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: isPrimary ? Colors.white : ColorsManager.primary,
            ),
            SizedBox(width: 6.w),
            Text(
              text,
              style: TextStyles.font12BlackBold.copyWith(
                color: isPrimary ? Colors.white : ColorsManager.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToJobDetails(BuildContext context) {
    context.push(AppRouter.kEmployerJobDetailsScreen, extra: item);
  }

  void _navigateToShiftDetails(BuildContext context) {
    final job = item.job;
    final endDateTime = job?.endDateTime != null
        ? DateTime.parse(job!.endDateTime!)
        : null;

    // ✅ إذا انتهت الوظيفة بالكامل، اذهب للملخص مباشرة
    if (endDateTime != null && DateTime.now().isAfter(endDateTime)) {
      context.push(
        AppRouter.kShiftSummaryScreen,
        extra: item,
      );
      return;
    }

    // ✅ إذا لسه شغالة، اذهب لصفحة التفاصيل
    context.push(
      AppRouter.kShiftDetailsView,
      extra: {
        'item': item,
        'role': UserRole.employer,
      },
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
        return _StatusInfo('نشطة', ColorsManager.primary);
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