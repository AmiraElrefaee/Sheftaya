import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/text_styles.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 32.h),
        Text(
          'إدارة وقتك بذكاء',
          style: TextStyles.font24PrimaryBold,
        ),
        SizedBox(height: 8.h),
        Text(
          'وظايف يومية بفرص حقيقية، تختار الشيفت المناسب وتشتغل حسب وقتك والتزاماتك.',
          style: TextStyles.font16BlackMedium,
        ),
        SizedBox(height: 32.h),
        SizedBox(
          height: 350.h,
          width: 350.w,
          child: Image.asset(
            'assets/images/onboarding1.png',
            
            height: 0.35.sh,  
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
