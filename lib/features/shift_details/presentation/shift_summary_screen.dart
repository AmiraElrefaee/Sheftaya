import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/features/worker/my_application_jobs/data/models/my_jobs_response.dart';

class ShiftSummaryScreen extends StatelessWidget {
  final MyJobItem item;
  final bool isFinalDay;
  final int totalDays;
  final int totalHours;
  final double totalEarnings;
  final double platformFee;
  final double netEarnings;

  const ShiftSummaryScreen({
    super.key,
    required this.item,
    required this.isFinalDay,
    required this.totalDays,
    required this.totalHours,
    required this.totalEarnings,
    required this.platformFee,
    required this.netEarnings,
  });

  // ✅ Factory لليوم الواحد
  factory ShiftSummaryScreen.fromToday(MyJobItem item) {
    final job = item.job;
    final dailyHours = job?.dailyWorkHours ?? 0;
    final hourlyRate = (job?.pricePerHour?.amount ?? 0).toDouble();

    final totalHours = dailyHours;
    final totalEarnings = totalHours * hourlyRate;
    final platformFee = totalEarnings * 0.02;
    final netEarnings = totalEarnings - platformFee;

    return ShiftSummaryScreen(
      item: item,
      isFinalDay: false,
      totalDays: 1,
      totalHours: totalHours,
      totalEarnings: totalEarnings,
      platformFee: platformFee,
      netEarnings: netEarnings,
    );
  }

  // ✅ Factory للملخص النهائي (جميع الأيام)
  factory ShiftSummaryScreen.fromAllDays(MyJobItem item) {
    final job = item.job;
    final dailyHours = job?.dailyWorkHours ?? 0;
    final hourlyRate = (job?.pricePerHour?.amount ?? 0).toDouble();

    int totalDays = 0;
    if (job?.startDateTime != null && job?.endDateTime != null) {
      final start = DateTime.parse(job!.startDateTime!);
      final end = DateTime.parse(job.endDateTime!);
      totalDays = end.difference(start).inDays + 1;
    }

    final totalHours = totalDays * dailyHours;
    final totalEarnings = totalHours * hourlyRate;
    final platformFee = totalEarnings * 0.02;
    final netEarnings = totalEarnings - platformFee;

    return ShiftSummaryScreen(
      item: item,
      isFinalDay: true,
      totalDays: totalDays,
      totalHours: totalHours,
      totalEarnings: totalEarnings,
      platformFee: platformFee,
      netEarnings: netEarnings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🟢 الجزء العلوي
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 50.h,
                      bottom: 28.h,
                      left: 16.w,
                      right: 16.w,
                    ),
                    decoration: BoxDecoration(
                      color: ColorsManager.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24.r),
                        bottomRight: Radius.circular(24.r),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: const Color(0xffD9D9D),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 100.w,
                          height: 100.w,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/success.svg',
                              width: 100.w,
                              height: 100.w,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          isFinalDay ? '🎉 تم الانتهاء من جميع الأيام!' : '✅ تم الانتهاء من اليوم',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1C1C1C),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          isFinalDay
                              ? 'تم الانتهاء من جميع أيام العمل. يرجى مراجعة التفاصيل النهائية.'
                              : 'تم الانتهاء من اليوم الحالي. يمكنك الراحة حتى اليوم التالي.',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF7A7A7A),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8.h,
                    right: 8.w,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: ColorsManager.black),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  children: [
                    SizedBox(height: 4.h),

                    // 📊 بطاقة تفاصيل الحساب
                    CustomPaint(
                      painter: TicketPainter(),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                        child: Column(
                          children: [
                            // ✅ إذا كان الملخص النهائي، أظهر عدد الأيام
                            if (isFinalDay) ...[
                              _buildSummaryRow(
                                label: 'عدد الأيام',
                                value: '$totalDays يوم',
                              ),
                              _buildDivider(),
                            ],

                            _buildSummaryRow(
                              label: 'عدد الساعات',
                              value: '$totalHours ساعات',
                            ),
                            _buildSummaryRow(
                              label: 'سعر الساعة',
                              value: '${(totalEarnings / totalHours).toStringAsFixed(0)} ج.م',
                            ),
                            _buildSummaryRow(
                              label: 'المبلغ الإجمالي',
                              value: '${totalEarnings.toStringAsFixed(0)} ج.م',
                            ),

                            _buildDivider(),

                            // 🔴 عمولة التطبيق
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDECEC),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFD93025),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          isFinalDay ? 'عمولة التطبيق (إجمالي)' : 'عمولة التطبيق (عامل)',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: const Color(0xFFD93025),
                                          ),
                                        ),
                                        Text(
                                          '-${platformFee.toStringAsFixed(0)} ج.م',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFFD93025),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 💰 صافي المبلغ المستحق
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isFinalDay ? 'صافي المبلغ الإجمالي:' : 'صافي المبلغ المستحق:',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: const Color(0xFF7A7A7A),
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        '${netEarnings.toStringAsFixed(0)} ج.م',
                                        style: TextStyle(
                                          fontSize: 28.sp,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF4DCE1F),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 14.w),
                                    decoration: BoxDecoration(
                                      color: const Color(0x5176FF45),
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check,
                                          size: 18.w,
                                          color: const Color(0xFF2DA102),
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          isFinalDay ? 'اكتمل العمل' : 'حساب مؤكد',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF2DA102),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // 🔵 الزر
                    AppTextButton(
                      buttonText: isFinalDay ? 'العودة للرئيسية' : 'العودة للتفاصيل',
                      buttonHeight: 50,
                      borderRadius: 14.r,
                      onPressed: () {
                        // ✅ إذا كان نهائياً، اذهب للرئيسية
                        if (isFinalDay) {
                          context.go('/home');
                        } else {
                          // ✅ إذا كان يوم عادي، ارجع لصفحة التفاصيل
                          context.pop();
                        }
                      },
                      backgroundColor: const Color(0xff3C93F7),
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorsManager.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow({required String label, required String value}) {
    return SizedBox(
      height: 42.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF7A7A7A),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1C1C1C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Divider(
        color: const Color(0xFFEEEEEE),
        height: 1.h,
        thickness: 1,
      ),
    );
  }
}

// 🎨 TicketPainter (نفسه)
class TicketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorsManager.white
      ..style = PaintingStyle.fill;

    final path = Path();

    const double radius = 16.0;
    const double notchRadius = 10.0;
    final double notchY = size.height * 0.52;

    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    path.arcToPoint(Offset(size.width, radius), radius: const Radius.circular(radius));

    path.lineTo(size.width, notchY - notchRadius);
    path.arcToPoint(
      Offset(size.width, notchY + notchRadius),
      radius: const Radius.circular(notchRadius),
      clockwise: false,
    );
    path.lineTo(size.width, size.height - radius);

    path.arcToPoint(
      Offset(size.width - radius, size.height),
      radius: const Radius.circular(radius),
    );
    path.lineTo(radius, size.height);
    path.arcToPoint(
      Offset(0, size.height - radius),
      radius: const Radius.circular(radius),
    );

    path.lineTo(0, notchY + notchRadius);
    path.arcToPoint(
      Offset(0, notchY - notchRadius),
      radius: const Radius.circular(notchRadius),
      clockwise: false,
    );
    path.lineTo(0, radius);
    path.arcToPoint(
      Offset(radius, 0),
      radius: const Radius.circular(radius),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}