import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/text_styles.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/empty_state.png'),
          SizedBox(height: 24.h),
          Text(
            'انشر وظيفتك بسهولة وابدأ في استقبال طلبات العمال في دقائق',
            style: TextStyles.font20PrimaryBold,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
