import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/text_styles.dart';

class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 32.h),
        Text('ربط موثوق بين الطرفين', style: TextStyles.font24PrimaryBold),
        SizedBox(height: 8.h),
        Text(
          'ربط مباشر بين أصحاب الشغل والعمالة اليومية، بآلية واضحة تضمن الالتزام والجودة.',
          style: TextStyles.font16BlackMedium,
        ),
        SizedBox(height: 32.h),
        SizedBox(
          height: 350.h,
          width: 350.w,
          child: Image.asset(
            'assets/images/onboarding3.png',
            height: 0.35.sh,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
