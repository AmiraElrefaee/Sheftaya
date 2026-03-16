import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/text_styles.dart';

class ImageUploadWidget extends StatelessWidget {
  const ImageUploadWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFD2D2D2), style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.upload_sharp, color: Colors.grey, size: 30.sp),
          Text("ارفع الملف هنا", style: TextStyles.font12BlackRegular.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }
}