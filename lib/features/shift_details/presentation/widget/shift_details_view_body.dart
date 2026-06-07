import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/features/shift_details/presentation/widget/shift_job_summary_card.dart';
import 'package:sheftaya/features/shift_details/presentation/widget/shift_status_time_line.dart';

import '../../../../core/theme/colors_manager.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../managers/shift_cubit.dart';
import '../shift_timer_view.dart';
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
          final shift = state;
          final job = shift.item.job;

          return SingleChildScrollView(
            child: Column(
              children: [
                ShiftJobSummaryCard(
                  job: job,
                  startTime: job?.startDateTime != null
                      ? DateTime.parse(job!.startDateTime!)
                      : DateTime.now(),
                  price: (job?.pricePerHour?.amount ?? 0).toDouble(),
                ),
                SizedBox(height: 20.h),
                Text("يرجي تأكيد دخولك", style: TextStyles.font24BlackMedium),
                Text(
                  "لن يتم احتساب الوقت حتي يتم التأكيد من الطرفين",
                  style: TextStyles.font16BlackMedium.copyWith(color: ColorsManager.grey),
                ),
                SizedBox(height: 20.h),
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

  Widget _buildTimelineSection(ShiftLoaded shift) {
    final startTime = shift.item.job?.startDateTime != null
        ? DateTime.parse(shift.item.job!.startDateTime!)
        : DateTime.now();
    final timeStarted = DateTime.now().isAfter(startTime);

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
          // 1. وقت البدء
          ShiftStatusTimelineStep(
            title: "وقت البدء الساعة (${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')})",
            subTitle: timeStarted ? "تم بحلول الوقت الرسمي" : "لم يحن الوقت بعد",
            status: timeStarted ? ShiftStepStatus.completed : ShiftStepStatus.pending,
          ),

          // 2. في الطريق
          ShiftStatusTimelineStep(
            title: shift.role == UserRole.worker ? "أنت في الطريق" : "العامل في الطريق",
            subTitle: shift.status == ShiftStatus.onTheWay || shift.status == ShiftStatus.arrived || shift.status == ShiftStatus.arrivedApproved
                ? "تم التوجه إلى موقع العمل"
                : "لم يغادر بعد",
            status: shift.status == ShiftStatus.onTheWay || shift.status == ShiftStatus.arrived || shift.status == ShiftStatus.arrivedApproved
                ? ShiftStepStatus.completed
                : (shift.status == ShiftStatus.notStarted && timeStarted
                ? ShiftStepStatus.inProgress
                : ShiftStepStatus.pending),
          ),

          // 3. وصول العامل
          ShiftStatusTimelineStep(
            title: shift.role == UserRole.worker ? "وصولك" : "وصول العامل",
            subTitle: shift.isWorkerArrived
                ? "تم تأكيد الوصول"
                : (shift.status == ShiftStatus.onTheWay ? "في الطريق إليك" : "بانتظار التأكيد"),
            status: shift.isWorkerArrived
                ? ShiftStepStatus.completed
                : (shift.status == ShiftStatus.onTheWay
                ? ShiftStepStatus.inProgress
                : ShiftStepStatus.pending),
          ),

          // 4. تأكيد صاحب العمل
          ShiftStatusTimelineStep(
            title: "تأكيد صاحب العمل",
            subTitle: shift.isEmployerConfirmed
                ? "تم التأكيد من صاحب العمل"
                : (shift.isWorkerArrived ? "بانتظار التأكيد" : "برجاء الإنتظار..."),
            status: shift.isEmployerConfirmed
                ? ShiftStepStatus.completed
                : (shift.isWorkerArrived
                ? ShiftStepStatus.inProgress
                : ShiftStepStatus.pending),
          ),

          // 5. بدء العمل
          ShiftStatusTimelineStep(
            title: "بدء العمل",
            subTitle: shift.isEmployerConfirmed ? "جاهز للبدء" : "",
            status: shift.isEmployerConfirmed
                ? ShiftStepStatus.completed
                : ShiftStepStatus.pending,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, ShiftLoaded shift) {
    final cubit = context.read<ShiftCubit>();

    if (shift.status == ShiftStatus.arrivedApproved || shift.status == ShiftStatus.inProgress) {
      return AppTextButton(
        textStyle: TextStyles.font16BlackMedium.copyWith(color: Colors.white),
        backgroundColor: ColorsManager.primary,
        buttonText: "الانتقال لبدء العمل",
        onPressed: () {},
      );
    }

    // Worker
    if (shift.role == UserRole.worker) {
      if (shift.status == ShiftStatus.notStarted) {
        return AppTextButton(
          textStyle: TextStyles.font16BlackMedium.copyWith(color: Colors.white),
          backgroundColor: ColorsManager.primary,
          buttonText: "في الطريق",
          onPressed: () => cubit.workerOnTheWay(),
        );
      }

      if (shift.status == ShiftStatus.onTheWay) {
        return AppTextButton(
          textStyle: TextStyles.font16BlackMedium.copyWith(color: Colors.white),
          backgroundColor: ColorsManager.primary,
          buttonText: "تأكيد وصولي",
          onPressed: () => cubit.workerArrived(),
        );
      }

      if (shift.status == ShiftStatus.arrived) {
        return AppTextButton(
          textStyle: TextStyles.font16BlackMedium.copyWith(color: Colors.white),
          backgroundColor: const Color(0xffD9D9D9),
          buttonText: "بانتظار تأكيد صاحب العمل",
          onPressed: () {},
        );
      }
    }

    // Employer
    if (shift.role == UserRole.employer) {
      if (!shift.isWorkerArrived) {
        return AppTextButton(
          textStyle: TextStyles.font16BlackMedium.copyWith(color: Colors.white),
          backgroundColor: const Color(0xffD9D9D9),
          buttonText: "بانتظار وصول العامل",
          onPressed: () {},
        );
      }

      // ✅ عند الضغط على "تأكيد وصول العامل"، يفتح صفحة التايمر
      return AppTextButton(
        textStyle: TextStyles.font16BlackMedium.copyWith(color: Colors.white),
        backgroundColor: ColorsManager.primary,
        buttonText: "تأكيد وصول العامل",
        onPressed: () {
          cubit.approveArrival();
          // ✅ الانتقال إلى صفحة التايمر
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShiftTimerScreen(item: shift.item),
            ),
          );
        },
      );
    }

    return AppTextButton(
      textStyle: TextStyles.font16BlackMedium.copyWith(color: Colors.white),
      backgroundColor: const Color(0xffD9D9D9),
      buttonText: "جاري التحميل...",
      onPressed: () {},
    );
  }
}