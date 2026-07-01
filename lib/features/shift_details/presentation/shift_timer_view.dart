import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/features/worker/my_application_jobs/data/models/my_jobs_response.dart';

import '../../../app/router.dart';
import 'managers/shift_cubit.dart';



class ShiftTimerScreen extends StatefulWidget {
  final MyJobItem item;

  const ShiftTimerScreen({super.key, required this.item});

  @override
  State<ShiftTimerScreen> createState() => _ShiftTimerScreenState();
}

class _ShiftTimerScreenState extends State<ShiftTimerScreen> {
  Duration _elapsedDuration = Duration.zero;
  Timer? _timer;
  bool _isShiftEnded = false;
  bool _isShiftEnding = false; // ✅ لمنع تكرار الضغط

  // Data
  late String _startTimeStr;
  late String _endTimeStr;
  late int _totalHours;
  late double _totalSalary;
  late double _hourlyRate;
  late DateTime _todayStartTime;
  late DateTime _todayEndTime;

  @override
  void initState() {
    super.initState();
    _initJobData();
    _startTimer();
  }

  void _initJobData() {
    final job = widget.item.job;

    if (job?.startDateTime != null && job?.dailyWorkHours != null) {
      try {
        final baseStartTime = DateTime.parse(job!.startDateTime!);
        final now = DateTime.now();
        final workHours = job.dailyWorkHours ?? 4;
        final hourlyRate = (job.pricePerHour?.amount ?? 60).toDouble();

        // ✅ حساب وقت البدء لليوم الحالي
        _todayStartTime = DateTime(
          now.year,
          now.month,
          now.day,
          baseStartTime.hour,
          baseStartTime.minute,
          baseStartTime.second,
        );

        // ✅ وقت الانتهاء اليوم
        _todayEndTime = _todayStartTime.add(Duration(hours: workHours));

        // ✅ التحقق من انتهاء الوظيفة بالكامل
        final endDateTime = job.endDateTime != null && job.endDateTime!.isNotEmpty
            ? DateTime.parse(job.endDateTime!)
            : _todayStartTime.add(Duration(days: 30));

        // ✅ إذا كان الوقت الحالي بعد نهاية الوظيفة كلها
        if (now.isAfter(endDateTime)) {
          _isShiftEnded = true;
          _totalHours = 0;
          _startTimeStr = 'انتهت الوظيفة';
          _endTimeStr = '-';
          _totalSalary = 0;
          _hourlyRate = 0;
          _elapsedDuration = Duration.zero;
          _goToShiftSummary(isFinalDay: true);
          return;
        }

        // ✅ إذا كان اليوم التالي لا يزال ضمن نطاق الوظيفة
        final nextDayStart = _todayStartTime.add(Duration(days: 1));
        final isLastDay = nextDayStart.isAfter(endDateTime) || nextDayStart.isAtSameMomentAs(endDateTime);

        // ✅ إذا انتهى اليوم الحالي
        if (now.isAfter(_todayEndTime)) {
          _isShiftEnded = true;
          _elapsedDuration = Duration(hours: workHours);
          _totalHours = workHours;
          _hourlyRate = hourlyRate;
          _totalSalary = _hourlyRate * _totalHours;
          _startTimeStr = _formatTime(_todayStartTime);
          _endTimeStr = _formatTime(_todayEndTime);

          // ✅ اذهب إلى ملخص اليوم مع تحديد إذا كان آخر يوم
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _goToShiftSummary(isFinalDay: isLastDay);
          });
          return;
        }

        // ✅ إذا كان الوقت الحالي قبل وقت البدء
        if (now.isBefore(_todayStartTime)) {
          _startTimeStr = _formatTime(_todayStartTime);
          _endTimeStr = _formatTime(_todayEndTime);
          _totalHours = workHours;
          _hourlyRate = hourlyRate;
          _totalSalary = _hourlyRate * _totalHours;
          _elapsedDuration = Duration.zero;
          _isShiftEnded = false;
          return;
        }

        // ✅ الوقت الحالي في منتصف الشيفت
        _startTimeStr = _formatTime(_todayStartTime);
        _endTimeStr = _formatTime(_todayEndTime);
        _totalHours = workHours;
        _hourlyRate = hourlyRate;
        _totalSalary = _hourlyRate * _totalHours;
        _elapsedDuration = now.difference(_todayStartTime);
        _isShiftEnded = false;
        return;
      } catch (e) {
        log('❌ Error in _initJobData: $e');
      }
    }

    // Fallback
    _todayStartTime = DateTime.now();
    _todayEndTime = DateTime.now().add(Duration(hours: 4));
    _startTimeStr = '02:00 مساءً';
    _endTimeStr = '06:00 مساءً';
    _totalHours = 4;
    _hourlyRate = 60;
    _totalSalary = 400;
    _elapsedDuration = Duration.zero;
  }

  void _startTimer() {
    if (_isShiftEnded) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final maxDuration = Duration(hours: _totalHours);

      // ✅ تحقق من انتهاء اليوم
      if (DateTime.now().isAfter(_todayEndTime)) {
        timer.cancel();
        setState(() {
          _isShiftEnded = true;
          _elapsedDuration = maxDuration;
        });
        _goToShiftSummary(isFinalDay: false);
        return;
      }

      // ✅ تحقق من انتهاء الوظيفة بالكامل
      final job = widget.item.job;
      if (job?.endDateTime != null) {
        final endDateTime = DateTime.parse(job!.endDateTime!);
        if (DateTime.now().isAfter(endDateTime)) {
          timer.cancel();
          setState(() {
            _isShiftEnded = true;
          });
          _goToShiftSummary(isFinalDay: true);
          return;
        }
      }

      setState(() {
        _elapsedDuration = Duration(seconds: _elapsedDuration.inSeconds + 1);
      });
    });
  }

  // ✅ الانتقال إلى ملخص اليوم
  void _goToShiftSummary({required bool isFinalDay}) {
    if (_isShiftEnding) return;
    _isShiftEnding = true;

    // ✅ حساب البيانات
    final totalEarnings = _totalSalary;
    final platformFee = totalEarnings * 0.02;
    final netEarnings = totalEarnings - platformFee;

    // ✅ احفظ الحالة في SharedPreferences (سيتم في الـ Cubit)
    final cubit = context.read<ShiftCubit>();
    if (isFinalDay) {
      cubit.markShiftCompleted();
    }

    // ✅ اذهب إلى صفحة الملخص
    context.pushReplacement(
      AppRouter.kShiftSummaryScreen,
      extra: {
        'item': widget.item,
        'isFinalDay': isFinalDay,
        'totalDays': 1,
        'totalHours': _totalHours,
        'totalEarnings': totalEarnings,
        'platformFee': platformFee,
        'netEarnings': netEarnings,
      },
    );
  }

  String _formatTime(DateTime time) {
    int hour = time.hour;
    int minute = time.minute;
    String period = hour >= 12 ? 'مساءً' : 'صباحاً';
    int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  double _getProgress() {
    final totalSeconds = _totalHours * 3600;
    if (totalSeconds == 0) return 0.0;
    return (_elapsedDuration.inSeconds / totalSeconds).clamp(0.0, 1.0);
  }

  double _getCurrentEarnings() {
    final totalSeconds = _totalHours * 3600;
    if (totalSeconds == 0) return 0.0;
    return (_elapsedDuration.inSeconds / totalSeconds) * _totalSalary;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _getProgress();
    final currentEarnings = _getCurrentEarnings();
    final isFullProgress = progress >= 1.0;

    // ✅ إذا انتهى اليوم وتم الانتقال، لا تعرض الصفحة
    if (_isShiftEnded) {
      return Scaffold(
        backgroundColor: ColorsManager.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: 20.h),
              Text(
                'جاري الانتقال إلى الملخص...',
                style: TextStyles.font16BlackMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: ColorsManager.background,
      appBar: AppBar(
        backgroundColor: ColorsManager.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: ColorsManager.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'تأكيد الوصول',
          style: TextStyles.font18BlackBold,
        ),
        centerTitle: true,
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: ColorsManager.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ⏱️ Timer Circle
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 220.w,
                            height: 220.w,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 18.w,
                              backgroundColor: const Color(0xFFF3F4F6),
                              color: ColorsManager.primary,
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'الوقت المنقضي',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: ColorsManager.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                _formatDuration(_elapsedDuration),
                                style: TextStyle(
                                  fontSize: 38.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsManager.black,
                                  fontFeatures: const [FontFeature.tabularFigures()],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // 💰 الأجر الحالي
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'الأجر الحالي: ',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: ColorsManager.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          currentEarnings.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorsManager.green,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'جنيه',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorsManager.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 28.h),

                    // 📊 Info Grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 2.3,
                      children: [
                        _buildInfoCard('وقت البدء', _startTimeStr),
                        _buildInfoCard('وقت الانتهاء', _endTimeStr),
                        _buildInfoCard('عدد ساعات الشيفت', '$_totalHours ساعات'),
                        _buildInfoCard('المبلغ المتفق عليه', '${_totalSalary.toInt()} جنيه'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // ✅ الأزرار السفلية
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: _isShiftEnded ? null : () {
                          _timer?.cancel();
                          // ✅ عند الضغط على إنهاء الشيفت مبكراً، اذهب للملخص
                          _goToShiftSummary(isFinalDay: false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isShiftEnded ? ColorsManager.grey : ColorsManager.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _isShiftEnded ? 'تم الانتهاء' : 'إنهاء الشيفت',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorsManager.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              color: const Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 15.sp,
              color: ColorsManager.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}