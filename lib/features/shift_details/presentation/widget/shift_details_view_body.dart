import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/features/shift_details/presentation/widget/shift_job_summary_card.dart';
import 'package:sheftaya/features/shift_details/presentation/widget/shift_status_time_line.dart';

import '../../../../app/router.dart';
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
    // ✅ استخدم اليوم الحالي بدلاً من التاريخ الثابت
    final baseStartTime = shift.item.job?.startDateTime != null
        ? DateTime.parse(shift.item.job!.startDateTime!)
        : DateTime.now();

    // ✅ احسب وقت البدء لليوم الحالي
    final now = DateTime.now();
    final todayStartTime = DateTime(
      now.year,
      now.month,
      now.day,
      baseStartTime.hour,
      baseStartTime.minute,
      baseStartTime.second,
    );

    // ✅ الوقت الحالي بالنسبة لوقت البدء اليوم
    final timeStarted = now.isAfter(todayStartTime);

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
            title: "وقت البدء الساعة (${todayStartTime.hour}:${todayStartTime.minute.toString().padLeft(2, '0')})",
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

    // ✅ التحقق من انتهاء الوظيفة
    final endDateTime = shift.item.job?.endDateTime != null
        ? DateTime.parse(shift.item.job!.endDateTime!)
        : null;

    if (endDateTime != null && DateTime.now().isAfter(endDateTime)) {
      return AppTextButton(
        textStyle: TextStyles.font16BlackMedium.copyWith(color: Colors.white),
        backgroundColor: const Color(0xffD9D9D9),
        buttonText: "انتهت الوردية",
        onPressed: () {},
      );
    }

    // ✅ التحقق من وقت البدء اليوم
    final startDateTime = shift.item.job?.startDateTime != null
        ? DateTime.parse(shift.item.job!.startDateTime!)
        : null;

    if (startDateTime != null) {
      final now = DateTime.now();
      final todayStart = DateTime(
        now.year,
        now.month,
        now.day,
        startDateTime.hour,
        startDateTime.minute,
        startDateTime.second,
      );

      if (now.isBefore(todayStart) && shift.status == ShiftStatus.notStarted) {
        return SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffD9D9D9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "سيتم تفعيل الزر في وقت بدء العمل",
                  style: TextStyles.font14BlackMedium.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "(${todayStart.hour}:${todayStart.minute.toString().padLeft(2, '0')})",
                  style: TextStyles.font14BlackMedium.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      // ✅ إذا كانت الحالة arrivedApproved أو inProgress
      if (shift.status == ShiftStatus.arrivedApproved || shift.status == ShiftStatus.inProgress) {
        return AppTextButton(
          textStyle: TextStyles.font16BlackMedium.copyWith(color: Colors.white),
          backgroundColor: ColorsManager.primary,
          buttonText: "الانتقال لبدء العمل",
          onPressed: () {
            context.push(AppRouter.kShiftTimerScreen, extra: shift.item);
          },
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

        if (shift.status == ShiftStatus.arrived) {
          return AppTextButton(
            textStyle: TextStyles.font16BlackMedium.copyWith(color: Colors.white),
            backgroundColor: ColorsManager.primary,
            buttonText: "تأكيد وصول العامل",
            onPressed: () {
              cubit.approveArrival();
              context.push(AppRouter.kShiftTimerScreen, extra: shift.item);
            },
          );
        }

        if (shift.status == ShiftStatus.arrivedApproved) {
          return AppTextButton(
            textStyle: TextStyles.font16BlackMedium.copyWith(color: Colors.white),
            backgroundColor: ColorsManager.primary,
            buttonText: "بدء العمل",
            onPressed: () {
              cubit.startShift();
              context.push(AppRouter.kShiftTimerScreen, extra: shift.item);
            },
          );
        }

        if (shift.status == ShiftStatus.inProgress) {
          return AppTextButton(
            textStyle: TextStyles.font16BlackMedium.copyWith(color: Colors.white),
            backgroundColor: ColorsManager.primary,
            buttonText: "إنهاء الوردية",
            onPressed: () => cubit.endShift(),
          );
        }
      }
    }

    // ✅ return في النهاية (لأي حالة لم تغطيها الشروط السابقة)
    return AppTextButton(
      textStyle: TextStyles.font16BlackMedium.copyWith(color: Colors.white),
      backgroundColor: const Color(0xffD9D9D9),
      buttonText: "جاري التحميل...",
      onPressed: () {},
    );
  }}