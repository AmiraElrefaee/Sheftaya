import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/features/publish_job/presentation/widgets/custom_app_bar.dart';
import 'package:sheftaya/features/shift_details/presentation/widget/shift_job_summary_card.dart';
import 'package:sheftaya/features/shift_details/presentation/widget/shift_status_time_line.dart';

import '../../../../core/theme/colors_manager.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import 'enums.dart';

class ShiftDetailsViewBody extends StatelessWidget {
  const ShiftDetailsViewBody({super.key});

  get role => null;

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      // padding: EdgeInsets.all(20.w),
      child: Column(
        children: [

          // _buildMapSection(),
          // SizedBox(height: 20.h),
          ShiftJobSummaryCard(),
          SizedBox(height: 20.h),
          Text("يرجي تأكيد دخولك", style: TextStyles.font24BlackMedium),
          Text("لن يتم احتساب الوقت حتي يتم التأكيد من الطرفين", style: TextStyles.font16BlackMedium.copyWith(color: ColorsManager.grey)),
          SizedBox(height: 20.h),
          _buildTimelineSection(),
          SizedBox(height: 40.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 34, vertical: 28),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              border: Border.all(
                color: Color(0xffD9D9D9),
                width: 1
              )
            ),
            child: Column(
              
              children: [
                AppTextButton(
                  textStyle:TextStyles.font16BlackMedium.copyWith(color: Colors.white),
                  backgroundColor: Color(0xffD9D9D9),
                  buttonText: "تأكيد وصولى",
                  onPressed: (){},

                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget _buildTimelineSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorsManager.lightGrey),
      ),
      child: Column(
        children: [
          ShiftStatusTimelineStep(
            title: "وقت البدء الساعة (2:00) مساءً",
            subTitle: "تم بحلول الوقت الرسمي",
            status: ShiftStepStatus.completed,
          ),
          ShiftStatusTimelineStep(
            title: role == UserRole.worker ? "وصولك" : "وصول العامل",
            subTitle: "تم تأكيد وصولك",
            status: ShiftStepStatus.completed,
          ),
          ShiftStatusTimelineStep(

            title: "تأكيد صاحب العمل",
            subTitle: "برجاء الإنتظار...",
            status: ShiftStepStatus.inProgress,
          ),
          ShiftStatusTimelineStep(
            title: "بدء العمل",
            subTitle: "",
            status: ShiftStepStatus.pending,
            isLast: true,
          ),
        ],
      ),
    );
  }

  // Widget _buildActionButton() {
  //   // منطق الزرار يختلف حسب حالة الـ Timeline
  //   return AppTextButton(
  //     buttonText: "تأكيد وصولي",
  //     onPressed: () {},
  //     backgroundColor: ColorsManager.primary,
  //   );
  // }



}
