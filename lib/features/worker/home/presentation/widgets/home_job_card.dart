import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/features/worker/service/saved_jobs_service.dart';

class HomeJobCard extends StatelessWidget {
  final dynamic job;
  final VoidCallback? onToggle;

  const HomeJobCard({super.key, required this.job, this.onToggle});

  String _formatDate() {
    final startDateTime = job.startDateTime;
    final dt = startDateTime != null
        ? DateTime.tryParse(startDateTime.toString())?.toLocal()
        : null;
    if (dt == null) return '';
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

  String _formatTime(String? isoString) {
    if (isoString == null) return '';
    final dt = DateTime.tryParse(isoString)?.toLocal();
    if (dt == null) return '';
    final hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final isAm = hour < 12;
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$hour12:$minute ${isAm ? 'ص' : 'م'}';
  }

  String _jobId() {
    try {
      return (job.id ?? '').toString();
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = job.jobImages != null && job.jobImages.isNotEmpty
        ? job.jobImages.first
        : null;
    final expLevel = job.experienceLevel ?? 'بدون خبرة';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: ColorsManager.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl.toString(),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      (job.title ?? '').toString(),
                      style: TextStyles.font18BlackBold,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      (job.place ?? '').toString(),
                      style: TextStyles.font14BlackSemiBold.copyWith(
                        color: ColorsManager.darkGrey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20.w),
              _SaveButton(job: job, onToggle: onToggle),
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
                  job.location?.address ?? 'جاري تحديد العنوان...',
                  style: TextStyles.font14BlackMedium.copyWith(
                    color: ColorsManager.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _applicantsBadge(job.requiredWorkers ?? 0),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 6.w,
            runSpacing: 8.h,
            children: [
              _buildTag('${job.dailyWorkHours ?? 0} ساعات'),
              _buildTag(expLevel),
              _buildTag(_formatDate()),
              _buildTag(_formatTime(job.startDateTime)),
            ],
          ),
          SizedBox(height: 12.h),
          const Divider(color: ColorsManager.lightGrey, thickness: 1),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${job.pricePerHour?.amount?.toStringAsFixed(0) ?? '0'} ج',
                style: TextStyles.font24PrimaryBold.copyWith(
                  color: ColorsManager.success,
                ),
              ),
              SizedBox(
                width: 120.w,
                height: 40.h,
                child: AppTextButton(
                  buttonText: 'التفاصيل',
                  onPressed: () => context.push(
                    AppRouter.kJobDetailsScreen,
                    extra: _jobId(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
    height: 80.h,
    width: 80.w,
    color: ColorsManager.lightGrey,
    child: const Icon(Icons.business, color: ColorsManager.grey),
  );

  Widget _buildTag(String text) => Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
    decoration: BoxDecoration(
      color: ColorsManager.lightGrey.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Text(text, style: TextStyles.font14BlackMedium),
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
          '$count عمال مطلوبين',
          style: TextStyles.font12BlackMedium.copyWith(
            color: ColorsManager.darkGrey,
          ),
        ),
      ],
    ),
  );
}

class _SaveButton extends StatefulWidget {
  final dynamic job;
  final VoidCallback? onToggle;
  const _SaveButton({required this.job, this.onToggle});
  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  @override
  void didUpdateWidget(covariant _SaveButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final id = (widget.job.id ?? '').toString();
    final status = await SavedJobsService.isSaved(id);
    if (mounted) setState(() => isSaved = status);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        setState(() => isSaved = !isSaved);
        await SavedJobsService.toggleJobItem(widget.job);
        if (widget.onToggle != null) widget.onToggle!();
      },
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: Icon(
          isSaved ? Icons.bookmark : Icons.bookmark_border,
          key: ValueKey<bool>(isSaved),
          size: 32.sp,
          color: ColorsManager.primary,
        ),
      ),
    );
  }
}
