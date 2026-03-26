import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors_manager.dart';
import '../../../../core/theme/text_styles.dart';
import 'enums.dart';

class ShiftStatusTimelineStep extends StatelessWidget {
  final String title;
  final String subTitle;
  final ShiftStepStatus status;
  final bool isLast;

  const ShiftStatusTimelineStep({
    required this.title,
    required this.subTitle,
    required this.status,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _buildStatusIcon(),
            if (!isLast) Container(width: 2.w, height: 30.h, color: _getLineColor()),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyles.font16BlackBold),
              Text(subTitle, style: TextStyles.font12BlackMedium.copyWith(color: _getSubTitleColor())),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIcon() {
    if (status == ShiftStepStatus.completed) {
      return Icon(Icons.check_circle, color: ColorsManager.green, size: 24.w);
    } else if (status == ShiftStepStatus.inProgress) {
      return Container(
        width: 24.w, height: 24.w,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ColorsManager.green, width: 2)),
      );
    }
    return Container(
      width: 24.w, height: 24.w,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ColorsManager.grey, width: 2)),
    );
  }

  Color _getLineColor() => status == ShiftStepStatus.completed ? ColorsManager.green : ColorsManager.lightGrey;
  Color _getSubTitleColor() => status == ShiftStepStatus.completed ? ColorsManager.grey : ColorsManager.green;
}