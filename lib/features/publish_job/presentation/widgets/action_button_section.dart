import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors_manager.dart';
import '../../../../core/theme/text_styles.dart';

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // زرار تعديل الوظيفة
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: ColorsManager.primary,
                width: 2
            ),
            minimumSize: Size(289.w, 48.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          ),
          child: Text('تعديل الوظيفة', style: TextStyles.font16BlackBold.copyWith(
            color: ColorsManager.primary
          )),
        ),
        SizedBox(height: 12.h),

        OutlinedButton(
          onPressed: () {},

          style: OutlinedButton.styleFrom(

            side: const BorderSide(color: ColorsManager.primary
            ,width: 2
            ),
            minimumSize: Size(289.w, 48.h),
            shape: RoundedRectangleBorder(

                borderRadius: BorderRadius.circular(16.r)),

          ),
          child: Text('العوده الى الرئيسية', style: TextStyles.font16PrimarySemiBold.copyWith(

            fontWeight: FontWeight.bold
          )),
        ),
      ],
    );
  }
}