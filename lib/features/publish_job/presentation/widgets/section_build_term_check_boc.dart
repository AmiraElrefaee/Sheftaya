import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/app/router.dart';

import '../../../../core/theme/colors_manager.dart';
import '../../../../core/theme/text_styles.dart';

class SectionBuildTermCheckBoc extends StatefulWidget {
  final ValueChanged<bool>? onChanged; // ✅ إضافة الـ Callback

  const SectionBuildTermCheckBoc({
    super.key,
    this.onChanged,
  });

  @override
  State<SectionBuildTermCheckBoc> createState() =>
      _SectionBuildTermCheckBocState();
}

class _SectionBuildTermCheckBocState extends State<SectionBuildTermCheckBoc> {
  bool agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: ColorsManager.lightGrey.withValues(alpha: 0.2),
        border: Border.all(color: const Color(0xffD2D2D2)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.info, color: ColorsManager.primary, size: 20.w),
              SizedBox(width: 3),
              InkWell(
                onTap: () {
                  context.push(AppRouter.kTermCondtionView);
                },
                child: Text(
                  'سياسة الدفع وشروط نشر الوظائف',
                  style: TextStyles.font12BlackRegular.copyWith(
                    color: ColorsManager.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 12,
                height: 12,
                child: Transform.scale(
                  scale: 0.6,
                  child: Checkbox(
                    value: agreeToTerms,
                    activeColor: ColorsManager.primary,
                    checkColor: Colors.white,
                    side: BorderSide(color: ColorsManager.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    onChanged: (val) {
                      setState(() {
                        agreeToTerms = val ?? false;
                      });
                      // ✅ إعلام الـ Parent بتغير الحالة
                      widget.onChanged?.call(agreeToTerms);
                    },
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'اوافق علي سياسة الدفع وشروط نشر الوظائف',
                style: TextStyles.font12BlackRegular.copyWith(
                  color: ColorsManager.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}