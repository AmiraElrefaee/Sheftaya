import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/features/notification/presentation/widgets/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onLongPress: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: notification.isNew
                  ? ColorsManager.primary
                  : ColorsManager.lightGrey,
              width: 1.2.w,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: ColorsManager.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.notifications_active_outlined,
                  color: ColorsManager.primary,
                  size: 22.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.font16BlackBold,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _formatDate(context, notification.date),
                          style: TextStyles.font12BlackRegular.copyWith(
                            color: ColorsManager.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      notification.body,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.font14BlackRegular.copyWith(
                        color: ColorsManager.darkGrey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        final minutes = diff.inMinutes;
        return minutes <= 0
            ? 'حالاً'
            : minutes == 1
            ? '1 دقيقة'
            : '$minutes دقيقة';
      }

      final hours = diff.inHours;
      return hours == 1 ? '1 ساعة' : '$hours ساعة';
    }

    return '${diff.inDays} يوم';
  }
}
