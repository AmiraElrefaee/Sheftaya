import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/colors_manager.dart';
import '../../../../core/theme/text_styles.dart';
import '../mangers/job_details_cubit/job_details_cubit.dart';

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: () {
            final state = context.read<JobDetailsCubit>().state;
            if (state is JobDetailsSuccess) {
              // ✅ التعديل: نمرر الـ job كـ extra عشان نعدله مش ننشره
              context.push(
                AppRouter.kPublishJobView,
                extra: state.job, // ✅ تمرير الـ job للتعديل
              );
            }
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: ColorsManager.primary,
              width: 2,
            ),
            minimumSize: Size(289.w, 48.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Text(
            'تعديل الوظيفة',
            style: TextStyles.font16BlackBold.copyWith(
              color: ColorsManager.primary,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        OutlinedButton(
          onPressed: () {
            context.go(AppRouter.kEmployerHomeScreen);
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: ColorsManager.primary,
              width: 2,
            ),
            minimumSize: Size(289.w, 48.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Text(
            'العوده إلى الرئيسية',
            style: TextStyles.font16PrimarySemiBold.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}