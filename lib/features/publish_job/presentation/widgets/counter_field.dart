import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/colors_manager.dart';
import '../../../../core/theme/text_styles.dart';

class CounterFieldWidget extends StatefulWidget {
  final String label;
  final int initialValue;
  final Function(int) onChanged;

  const CounterFieldWidget({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<CounterFieldWidget> createState() => _CounterFieldWidgetState();
}

class _CounterFieldWidgetState extends State<CounterFieldWidget> {
  late int count;

  @override
  void initState() {
    super.initState();
    count = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: TextStyles.font12BlackRegular, textAlign: TextAlign.center),
        SizedBox(height: 8.h),
        Container(
          height: 48.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: ColorsManager.grey),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () => setState(() {
                    count++;
                    widget.onChanged(count);
                  }),

                  icon: SvgPicture.asset('assets/icon/plus.svg',
                  height: 12,
                  )),

              Text('$count', style: TextStyles.font14BlackBold),
              IconButton(
                onPressed: () => setState(() {
                  if (count > 1) count--;
                  widget.onChanged(count);
                }),
                icon: Icon(Icons.remove, size: 18.w, color: ColorsManager.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}