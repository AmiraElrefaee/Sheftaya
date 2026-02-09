import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';

class CustomToggleButton extends StatefulWidget {
  final List<String> labels;
  final int initialIndex;
  final ValueChanged<int> onToggle;
  final double? width;
  final double? height;

  const CustomToggleButton({
    super.key,
    required this.labels,
    required this.onToggle,
    this.initialIndex = 0,
    this.width,
    this.height,
  });

  @override
  State<CustomToggleButton> createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 328.w,
      height: widget.height ?? 50.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: ColorsManager.lightGrey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: List.generate(
          widget.labels.length,
          (index) => _buildSegment(widget.labels[index], index),
        ),
      ),
    );
  }

  Widget _buildSegment(String text, int index) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          if (selectedIndex == index) return;

          setState(() {
            selectedIndex = index;
          });
          widget.onToggle(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? ColorsManager.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            text,
            style: TextStyles.font14BlackBold.copyWith(
              color: isSelected ? Colors.white : ColorsManager.primary,
            ),
          ),
        ),
      ),
    );
  }
}
