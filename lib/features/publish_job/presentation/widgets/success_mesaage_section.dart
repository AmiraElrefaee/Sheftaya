import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/colors_manager.dart';
import '../../../../core/theme/text_styles.dart';

class SuccessMessageSection extends StatelessWidget {
  const SuccessMessageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset('assets/images/success.svg',
          height: 120.h,

        ),
        // CircleAvatar(
        //   radius: 50.r,
        //   backgroundColor: ColorsManager.success.withOpacity(0.1),
        //   child: Icon(Icons.check_circle, color: ColorsManager.success, size: 80.sp),
        // ),
        SizedBox(height: 24.h),
        Text('تم نشر وظيفتك بنجاح', style: TextStyles.font24BlackBold),
        SizedBox(height: 12.h),
        Text(
          'تابع الطلبات، راجع المتقدمين، واختار الأنسب من شاشة الوظائف. وسيتم إشعارك بكل جديد.',
          textAlign: TextAlign.center,
          style: TextStyles.font14BlackRegular.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}

