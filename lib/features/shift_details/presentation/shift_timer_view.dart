import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/features/worker/my_application_jobs/data/models/my_jobs_response.dart';

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

  // Default data (will be replaced with API data)
  late String _startTimeStr;
  late String _endTimeStr;
  late int _totalHours;
  late double _totalSalary;
  late double _hourlyRate;

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

        // ✅ حساب endDateTime
        DateTime endDateTime;
        if (job.endDateTime != null && job.endDateTime!.isNotEmpty) {
          endDateTime = DateTime.parse(job.endDateTime!);
        } else {
          endDateTime = baseStartTime.add(Duration(days: 30));
        }

        // ✅ حساب وقت البدء لليوم الحالي
        final todayStartTime = _getTodayStartTime(baseStartTime, now, endDateTime);

        // ✅ إذا كان اليوم الجديد لم يبدأ بعد
        if (todayStartTime == null) {
          _isShiftEnded = true;
          _totalHours = 0;
          _startTimeStr = 'انتهت الوظيفة';
          _endTimeStr = '-';
          _totalSalary = 0;
          _hourlyRate = 0;
          _elapsedDuration = Duration.zero;
          return;
        }

        // ✅ حساب وقت الانتهاء
        final todayEndTime = todayStartTime.add(Duration(hours: workHours));

        // ✅ إذا كان الوقت الحالي قبل وقت البدء
        if (now.isBefore(todayStartTime)) {
          _startTimeStr = _formatTime(todayStartTime);
          _endTimeStr = _formatTime(todayEndTime);
          _totalHours = workHours;
          _hourlyRate = hourlyRate;
          _totalSalary = _hourlyRate * _totalHours;
          _elapsedDuration = Duration.zero;
          _isShiftEnded = false;
          return;
        }

        // ✅ إذا كان الوقت الحالي في منتصف الشيفت
        if (now.isAfter(todayStartTime) && now.isBefore(todayEndTime)) {
          _startTimeStr = _formatTime(todayStartTime);
          _endTimeStr = _formatTime(todayEndTime);
          _totalHours = workHours;
          _hourlyRate = hourlyRate;
          _totalSalary = _hourlyRate * _totalHours;
          _elapsedDuration = now.difference(todayStartTime);
          _isShiftEnded = false;
          return;
        }

        // ✅ إذا انتهى الشيفت اليوم
        if (now.isAfter(todayEndTime)) {
          // ✅ التحقق من وجود يوم تالي
          final nextDayStart = todayStartTime.add(Duration(days: 1));
          if (nextDayStart.isBefore(endDateTime)) {
            // ✅ اليوم التالي لم يبدأ بعد، اعرض وقت البدء القادم
            _startTimeStr = _formatTime(nextDayStart);
            _endTimeStr = _formatTime(nextDayStart.add(Duration(hours: workHours)));
            _totalHours = workHours;
            _hourlyRate = hourlyRate;
            _totalSalary = _hourlyRate * _totalHours;
            _elapsedDuration = Duration.zero;
            _isShiftEnded = false;
            log('⏰ Next shift starts at: ${_startTimeStr}');
            return;
          } else {
            // ✅ الوظيفة انتهت تماماً
            _isShiftEnded = true;
            _totalHours = 0;
            _startTimeStr = 'انتهت الوظيفة';
            _endTimeStr = '-';
            _totalSalary = 0;
            _hourlyRate = 0;
            _elapsedDuration = Duration.zero;
            return;
          }
        }

        return;
      } catch (e) {
        log('❌ Error in _initJobData: $e');
      }
    }

    // Fallback defaults
    _startTimeStr = '02:00 مساءً';
    _endTimeStr = '06:00 مساءً';
    _totalHours = 4;
    _hourlyRate = 60;
    _totalSalary = 400;
    _elapsedDuration = Duration.zero;
  }

  /// ✅ حساب وقت البدء لليوم الحالي
  DateTime? _getTodayStartTime(DateTime baseStartTime, DateTime now, DateTime endDateTime) {
    // إذا كان الوقت الحالي بعد نهاية الوظيفة كلها
    if (now.isAfter(endDateTime)) {
      return null;
    }

    // حساب وقت البدء لليوم الحالي (نفس الوقت ولكن في اليوم الحالي)
    DateTime todayStart = DateTime(
      now.year,
      now.month,
      now.day,
      baseStartTime.hour,
      baseStartTime.minute,
      baseStartTime.second,
    );

    // إذا كان الوقت الحالي قبل وقت البدء اليوم، استخدم وقت البدء اليوم
    if (now.isBefore(todayStart)) {
      return todayStart;
    }

    // إذا كان الوقت الحالي بعد وقت البدء اليوم
    // تحقق من اليوم التالي
    DateTime nextDayStart = todayStart.add(Duration(days: 1));

    // إذا كان اليوم التالي لا يزال ضمن نطاق الوظيفة
    if (nextDayStart.isBefore(endDateTime)) {
      // إذا كان الوقت الحالي بعد نهاية الشيفت اليوم، استخدم اليوم التالي
      final todayEnd = todayStart.add(Duration(hours: baseStartTime.hour + 8)); // 8 ساعات افتراضية
      if (now.isAfter(todayEnd)) {
        return nextDayStart;
      }
      return todayStart;
    }

    // إذا لم يعد هناك أيام متبقية
    return null;
  }

  //------

  String _formatTime(DateTime time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    String period = time.hour >= 12 ? 'مساءً' : 'صباحاً';
    int displayHour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    return '$displayHour:$minute $period';
  }

  void _startTimer() {
    if (_isShiftEnded) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final maxDuration = Duration(hours: _totalHours);
      if (_elapsedDuration >= maxDuration) {
        timer.cancel();
        setState(() {
          _isShiftEnded = true;
          _elapsedDuration = maxDuration;
        });
      } else {
        setState(() {
          _elapsedDuration = Duration(seconds: _elapsedDuration.inSeconds + 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
  Widget build(BuildContext context) {
    final progress = _getProgress();
    final currentEarnings = _getCurrentEarnings();
    final isFullProgress = progress >= 1.0;

    return Scaffold(
      backgroundColor: ColorsManager.background, // خلفية رمادية فاتحة
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
              // ✅ الجزء الأبيض مع البوردر
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: ColorsManager.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: const Color(0xFFE5E5E5),
                    width: 1,
                  ),
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

                    // 📊 Info Grid - 2 columns
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
                    // زر إنهاء الشيفت
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: () {
                          _timer?.cancel();
                          // TODO: End shift action
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'إنهاء الشيفت',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorsManager.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // زر إلغاء الشيفت (يظهر فقط قبل اكتمال الشيفت)
                    if (!isFullProgress)
                      TextButton(
                        onPressed: () {
                          _timer?.cancel();
                          // TODO: Cancel shift action
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cancel_outlined,
                              color: ColorsManager.error,
                              size: 22.w,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'إلغاء الشيفت',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorsManager.error,
                              ),
                            ),
                          ],
                        ),
                      ),
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
        color: const Color(0xFFF3F4F6), // رمادي فاتح
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