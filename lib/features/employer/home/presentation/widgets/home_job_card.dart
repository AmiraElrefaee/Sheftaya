import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/features/worker/my_application_jobs/data/models/my_jobs_response.dart';

class HomeJobCard extends StatelessWidget {
  final MyJobItem item;
  final VoidCallback? onPressed;

  const HomeJobCard({super.key, required this.item, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final job = item.job;

    final title = job?.title ?? item.title ?? 'وظيفة';
    final company =
        item.place ?? job?.companyDetails?.companyName ?? 'شركة غير محددة';

    final location = job?.location?.address ?? job?.place ?? 'الموقع غير محدد';

    final imageUrl = job?.jobImages?.isNotEmpty == true
        ? job!.jobImages!.first
        : null;

    final salary = job?.pricePerHour?.amount ?? 0;
    final workersCount = job?.requiredWorkers ?? 0;
    final hours = job?.dailyWorkHours ?? 0;

    final shiftDate = _formatDate(job?.startDateTime);
    final shiftTime = _formatTime(job?.startDateTime);

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
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
                    Text(title, style: TextStyles.font18BlackBold),
                    SizedBox(height: 2.h),
                    Text(
                      company,
                      style: TextStyles.font14BlackSemiBold.copyWith(
                        color: ColorsManager.darkGrey,
                      ),
                    ),
                  ],
                ),
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
                  location,
                  style: TextStyles.font14BlackMedium.copyWith(
                    color: ColorsManager.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 6.w,
            runSpacing: 8.h,
            children: [
              _buildTag('$hours ساعات'),
              _buildTag(shiftDate),
              _buildTag(shiftTime),
              _buildTag('$workersCount عمال'),
            ],
          ),
          SizedBox(height: 12.h),
          const Divider(color: ColorsManager.lightGrey, thickness: 1),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${salary.toStringAsFixed(0)} ج',
                style: TextStyles.font24PrimaryBold.copyWith(
                  color: ColorsManager.success,
                ),
              ),
              SizedBox(
                width: 120.w,
                height: 40.h,
                child: AppTextButton(
                  buttonText: 'التفاصيل',
                  onPressed: onPressed ?? () {},
                ),
              ),
            ],
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

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return 'تاريخ غير محدد';
    final dt = DateTime.tryParse(value)?.toLocal();
    if (dt == null) return 'تاريخ غير محدد';

    const months = [
      '',
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];

    return '${dt.day} ${months[dt.month]}';
  }

  String _formatTime(String? value) {
    if (value == null || value.isEmpty) return 'وقت غير محدد';
    final dt = DateTime.tryParse(value)?.toLocal();
    if (dt == null) return 'وقت غير محدد';

    final hour = dt.hour;
    final min = dt.minute.toString().padLeft(2, '0');
    final isAm = hour < 12;
    final h12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$h12:$min ${isAm ? 'ص' : 'م'}';
  }
}
