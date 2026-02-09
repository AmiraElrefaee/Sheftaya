import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_text_form_field.dart';

class AppDropdown extends StatefulWidget {
  final String? value;
  final List<String> items;
  final String hint;
  final ValueChanged<String?> onChanged;
  final bool hasError;
  final String? errorMessage;
  final double height;

  const AppDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint = 'اختار من القائمة',
    this.hasError = false,
    this.errorMessage,
    this.height = 48,
  });

  @override
  State<AppDropdown> createState() => _AppDropdownState();
}

class _AppDropdownState extends State<AppDropdown> {
  bool _isFocused = false;
  bool _isOtherSelected = false;
  final TextEditingController _otherController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.value != null && !widget.items.contains(widget.value)) {
      _isOtherSelected = true;
      _otherController.text = widget.value!;
    }
  }

  Color _getBorderColor() {
    if (widget.hasError) return ColorsManager.error;
    if (widget.value != null || _isFocused) return ColorsManager.primary;
    return ColorsManager.grey;
  }

  double _getBorderWidth() {
    if (widget.hasError || widget.value != null || _isFocused) return 2.w;
    return 1.w;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Dropdown
        Container(
          height: widget.height.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: _getBorderColor(),
              width: _getBorderWidth(),
            ),
          ),
          child: InkWell(
            onTap: _showDropdownMenu,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _isOtherSelected ? 'آخر' : widget.value ?? widget.hint,
                      textAlign: TextAlign.right,
                      style: TextStyles.font14BlackRegular.copyWith(
                        color: widget.value == null
                            ? ColorsManager.grey
                            : ColorsManager.black,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: _getBorderColor()),
                ],
              ),
            ),
          ),
        ),

        if (_isOtherSelected) ...[
          SizedBox(height: 12.h),
          Text('نوع المؤسسة', style: TextStyles.font14BlackRegular),
          SizedBox(height: 8.h),
          AppTextFormField(
            controller: _otherController,
            onChanged: (val) {
              widget.onChanged(val);
            },
            hintText: 'ادخل نوع المؤسسة',
          ),
        ],

        if (widget.hasError && widget.errorMessage != null) ...[
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Text(
              widget.errorMessage!,
              style: TextStyles.font12BlackRegular.copyWith(
                color: ColorsManager.error,
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showDropdownMenu() {
    setState(() => _isFocused = true);

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    showMenu<String>(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: Colors.white,
      elevation: 4,
      position: RelativeRect.fromLTRB(
        offset.dx - 8.w,
        offset.dy + size.height + 4.h,
        offset.dx + size.width + 8.w,
        offset.dy + size.height + 4.h + (widget.items.length * 48.h) + 16.h,
      ),
      items: widget.items.map((item) {
        return PopupMenuItem<String>(
          value: item,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Text(
            item,
            style: TextStyles.font14BlackRegular,
            textAlign: TextAlign.right,
          ),
        );
      }).toList(),
    ).then((selectedValue) {
      setState(() => _isFocused = false);

      if (selectedValue == null) return;

      if (selectedValue == 'آخر') {
        _isOtherSelected = true;
        _otherController.clear();
        widget.onChanged(null);
      } else {
        _isOtherSelected = false;
        widget.onChanged(selectedValue);
      }

      setState(() {});
    });
  }
}
