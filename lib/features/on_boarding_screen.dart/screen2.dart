import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/text_styles.dart';

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 32.h),
        Text('فرص متاحة وقت ما تحتاجها', style: TextStyles.font24PrimaryBold),
        SizedBox(height: 8.h),
        Text(
          'شغل يومي قريب منك، توصلك الفرص فور توفرها وتبدأ من غير تعقيد.',
          style: TextStyles.font16BlackMedium,
        ),
        SizedBox(height: 32.h),
        SizedBox(
          height: 350.h,
          width: 350.w,
          child: Image.asset(
            'assets/images/onboarding2.png',
            height: 0.35.sh,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
