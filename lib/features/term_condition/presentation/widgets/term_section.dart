import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/text_styles.dart';
import '../../data/model/term_content.dart';

class TermsSection extends StatelessWidget {
  final TermsContent content;

  const TermsSection({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content.title,
            style: TextStyles.font16PrimarySemiBold, // استخدمنا الـ Custom Style
          ),
          SizedBox(height: 8.h),
          ...content.points.map((point) => Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("• ", style: TextStyles.font14BlackRegular),
                Expanded(
                  child: Text(
                    point,
                    style: TextStyles.font14BlackRegular.copyWith(height: 1.5),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}