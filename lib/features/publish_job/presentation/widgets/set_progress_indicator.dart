import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors_manager.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final VoidCallback? onStepOneTap;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    this.onStepOneTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // تحديد عرض مخصص (مثلاً 70% من عرض الشاشة) ليكون في المنتصف
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: 100.w,
      ), // هذه المساحة هي التي تجعل الخط في المنتصف وبحجم "التلتربع"
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;

          return SizedBox(
            height: 14.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. الخط الخلفي الرمادي (الرفيع)
                Container(
                  height: 2.h,
                  width: maxWidth,
                  decoration: BoxDecoration(
                    color: ColorsManager.lightGrey.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // 2. الخط الملون المتحرك
                Positioned(
                  right: 0, // لضمان البدء من اليمين (Directionality)
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 2.h,
                    // إذا كنا في الخطوة الأولى، الخط يملأ نصف المسافة بين الدائرتين
                    width: currentStep == 1 ? (maxWidth / 2) : maxWidth,
                    decoration: BoxDecoration(
                      color: ColorsManager.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // 3. الدوائر التفاعلية
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // الدائرة الأولى
                      GestureDetector(
                        onTap: onStepOneTap,
                        child: _progressDot(true),
                      ),
                      // الدائرة الثانية
                      _progressDot(currentStep == 2),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _progressDot(bool active) {
    return Container(
      width: 12.w, // حجم الدائرة كما في الصورة (أصغر قليلاً)
      height: 12.w,
      decoration: BoxDecoration(
        color: active
            ? ColorsManager.primary
            : ColorsManager.lightGrey.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
    );
  }
}
