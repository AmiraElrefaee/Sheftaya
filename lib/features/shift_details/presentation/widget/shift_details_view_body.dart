import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/features/shift_details/presentation/widget/shift_job_summary_card.dart';
import 'package:sheftaya/features/shift_details/presentation/widget/shift_status_time_line.dart';

import '../../../../core/theme/colors_manager.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/model/shift_model.dart';
import '../managers/shift_cubit.dart';
import 'enums.dart';

class ShiftDetailsViewBody extends StatelessWidget {
  final UserRole role;

  const ShiftDetailsViewBody({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShiftCubit, ShiftState>(
      builder: (context, state) {
        if (state is ShiftLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ShiftLoaded) {
          final shift = state.shift;
          return SingleChildScrollView(
            child: Column(
              children: [
                // تمرير بيانات الشفت للكارت العلوي
                 ShiftJobSummaryCard(),
                SizedBox(height: 20.h),
                Text("يرجي تأكيد دخولك", style: TextStyles.font24BlackMedium),
                Text(
                  "لن يتم احتساب الوقت حتي يتم التأكيد من الطرفين",
                  style: TextStyles.font16BlackMedium.copyWith(color: ColorsManager.grey),
                ),
                SizedBox(height: 20.h),
                // تمرير البيانات للـ Timeline
                _buildTimelineSection(shift),
                SizedBox(height: 40.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 34.w, vertical: 28.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.white,
                    border: Border.all(color: const Color(0xffD9D9D9), width: 1),
                  ),
                  child: Column(
                    children: [
                      _buildActionButton(context, shift),
                    ],
                  ),
                )
              ],
            ),
          );
        } else if (state is ShiftError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text("حدث خطأ ما"));
      },
    );
  }

  Widget _buildTimelineSection(ShiftModel shift) {
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
            title: "وقت البدء الساعة (${shift.startTime.hour}:${shift.startTime.minute})",
            subTitle: "تم بحلول الوقت الرسمي",
            status: ShiftStepStatus.completed,
          ),
          ShiftStatusTimelineStep(
            title: role == UserRole.worker ? "وصولك" : "وصول العامل",
            subTitle: shift.isWorkerArrived ? "تم تأكيد الوصول" : "بانتظار التأكيد",
            status: shift.isWorkerArrived ? ShiftStepStatus.completed : ShiftStepStatus.inProgress,
          ),
          ShiftStatusTimelineStep(
            title: "تأكيد صاحب العمل",
            subTitle: shift.isEmployerConfirmed ? "تم التأكيد من صاحب العمل" : "برجاء الإنتظار...",
            status: shift.isEmployerConfirmed
                ? ShiftStepStatus.completed
                : (shift.isWorkerArrived ? ShiftStepStatus.inProgress : ShiftStepStatus.pending),
          ),
          ShiftStatusTimelineStep(
            title: "بدء العمل",
            subTitle: (shift.isWorkerArrived && shift.isEmployerConfirmed) ? "جاهز للبدء" : "",
            status: (shift.isWorkerArrived && shift.isEmployerConfirmed)
                ? ShiftStepStatus.completed
                : ShiftStepStatus.pending,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, ShiftModel shift) {
    bool isFullyConfirmed = shift.isWorkerArrived && shift.isEmployerConfirmed;

    // الحالة 1: تم التأكيد من الطرفين (زرار بدء العمل)
    if (isFullyConfirmed) {
      return AppTextButton(
        textStyle: TextStyles.font16BlackMedium.copyWith(color: Colors.white),
        backgroundColor: ColorsManager.primary,
        buttonText: "الانتقال لبدء العمل",
        onPressed: () {
          // الانتقال لصفحة الـ Timer
        },
      );
    }

    // الحالة 2: العامل داس تأكيد وبانتظار صاحب العمل (زرار مطفأ)
    if (role == UserRole.worker && shift.isWorkerArrived) {
      return AppTextButton(
        textStyle: TextStyles.font16BlackMedium.copyWith(color: Colors.white),
        backgroundColor: const Color(0xffD9D9D9),
        buttonText: "بانتظار صاحب العمل",
        onPressed: () {}, // Disabled
      );
    }

    // الحالة 3: زرار التأكيد الفعلي (للعامل أو صاحب العمل)
    return AppTextButton(
      textStyle: TextStyles.font16BlackMedium.copyWith(color: Colors.white),
      backgroundColor: ColorsManager.primary,
      buttonText: role == UserRole.worker ? "تأكيد وصولى" : "تأكيد وصول العامل",
      onPressed: () {
        context.read<ShiftCubit>().confirmArrival(shift.id, role);
      },
    );
  }
}