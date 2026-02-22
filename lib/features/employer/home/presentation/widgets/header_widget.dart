import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
        border: BorderDirectional(
          bottom: BorderSide(color: ColorsManager.lightGrey),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 32.h),
          Row(
            children: [
              CircleAvatar(
                radius: 28.h,
                backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('اهلاً, ندى', style: TextStyles.font18BlackSemiBold),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.locationDot,
                        size: 16.sp,
                        color: ColorsManager.primary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'بورسعيد , بورفؤاد ..',
                        style: TextStyles.font14BlackSemiBold.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: ColorsManager.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_outlined,
                    size: 24.sp,
                    color: ColorsManager.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
