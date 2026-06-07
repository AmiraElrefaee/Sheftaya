import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/features/worker/my_application_jobs/data/models/my_jobs_response.dart';

class ShiftTimerScreen extends StatefulWidget {
  final MyJobItem item;

  const ShiftTimerScreen({super.key, required this.item});

  @override
  State<ShiftTimerScreen> createState() => _ShiftTimerScreenState();
}

class _ShiftTimerScreenState extends State<ShiftTimerScreen> {
  late Duration _duration;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _calculateDuration();
  }

  void _calculateDuration() {
    final job = widget.item.job;
    if (job?.startDateTime != null && job?.dailyWorkHours != null) {
      final startTime = DateTime.parse(job!.startDateTime!);
      final endTime = startTime.add(Duration(hours: job.dailyWorkHours!));
      final now = DateTime.now();

      if (now.isAfter(endTime)) {
        _duration = Duration.zero;
      } else {
        _duration = endTime.difference(now);
      }
    } else {
      _duration = Duration(hours: 8);
    }
  }

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds <= 0) {
        timer.cancel();
        setState(() {
          _isRunning = false;
          _duration = Duration.zero;
        });
      } else {
        setState(() {
          _duration = Duration(seconds: _duration.inSeconds - 1);
        });
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _endShift() {
    _timer?.cancel();
    // TODO: إرسال إشارة إنهاء الوردية للـ Backend
    Navigator.pop(context);
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
    final job = widget.item.job;
    if (job?.dailyWorkHours == null) return 0;
    final totalSeconds = (job!.dailyWorkHours! * 3600);
    final elapsedSeconds = totalSeconds - _duration.inSeconds;
    return (elapsedSeconds / totalSeconds).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.item.job;
    final progress = _getProgress();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('تتبع وقت العمل', style: TextStyles.font18BlackBold),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // معلومات الوظيفة
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: ColorsManager.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  Text(
                    job?.title ?? 'الوظيفة',
                    style: TextStyles.font20BlackBold,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    job?.companyDetails?.companyName ?? job?.place ?? '',
                    style: TextStyles.font16BlackMedium.copyWith(
                      color: ColorsManager.darkGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),

            // Timer Circle
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 250.w,
                  height: 250.w,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8.w,
                    backgroundColor: ColorsManager.lightGrey,
                    color: ColorsManager.primary,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatDuration(_duration),
                      style: TextStyle(
                        fontSize: 48.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorsManager.primary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'الوقت المتبقي',
                      style: TextStyles.font14BlackMedium.copyWith(
                        color: ColorsManager.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 40.h),

            // الأزرار
            Row(
              children: [
                Expanded(
                  child: AppTextButton(
                    buttonText: _isRunning ? 'إيقاف مؤقت' : 'بدء العمل',
                    onPressed: _isRunning ? _pauseTimer : _startTimer,
                    backgroundColor: ColorsManager.primary,
                    textStyle: TextStyles.font16WhiteBold,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: AppTextButton(
                    buttonText: 'إنهاء الوردية',
                    onPressed: _endShift,
                    backgroundColor: ColorsManager.error,
                    textStyle: TextStyles.font16WhiteBold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}