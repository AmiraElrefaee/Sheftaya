import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_text_form_field.dart';

class AppMultiSelectDropdown extends StatefulWidget {
  final List<String> items;
  final List<String> selectedValues;
  final ValueChanged<List<String>> onChanged;
  final String hint;
  final bool hasError;
  final String? errorMessage;
  final double height;

  const AppMultiSelectDropdown({
    super.key,
    required this.items,
    required this.selectedValues,
    required this.onChanged,
    this.hint = 'اختار من القائمة',
    this.hasError = false,
    this.errorMessage,
    this.height = 48,
  });

  @override
  State<AppMultiSelectDropdown> createState() => _AppMultiSelectDropdownState();
}

class _AppMultiSelectDropdownState extends State<AppMultiSelectDropdown> {
  bool _isFocused = false;

  final TextEditingController _otherController = TextEditingController();
  bool showOtherField = false;

  Color _getBorderColor() {
    if (widget.hasError) return ColorsManager.error;
    if (widget.selectedValues.isNotEmpty || _isFocused) {
      return ColorsManager.primary;
    }
    return ColorsManager.grey;
  }

  double _getBorderWidth() {
    if (widget.hasError || widget.selectedValues.isNotEmpty || _isFocused) {
      return 2.w;
    }
    return 1.w;
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// Dropdown Box
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
                      widget.selectedValues.isEmpty
                          ? widget.hint
                          : widget.selectedValues.join(' ، '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyles.font14BlackRegular.copyWith(
                        color: widget.selectedValues.isEmpty
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

        /// Error message
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

        if (showOtherField) ...[
          SizedBox(height: 12.h),
          Text('الوظيفة الأخرى', style: TextStyles.font14BlackRegular),
          SizedBox(height: 8.h),
          AppTextFormField(
            controller: _otherController,
            hintText: 'مثال: شيف سوشي، منسق حفلات...',

            onChanged: (value) {
              final updated = [...widget.selectedValues];

              updated.remove('آخر');

              if (value.isNotEmpty) {
                updated.add(value);
              }

              widget.onChanged(updated);
            },
          ),
        ],
      ],
    );
  }

  void _showDropdownMenu() async {
    setState(() => _isFocused = true);

    final tempSelected = [...widget.selectedValues];

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    await showMenu(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: Colors.white,
      elevation: 4,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height + 4.h,
        offset.dx + size.width,
        offset.dy + size.height + 300.h,
      ),
      items: [
        ...widget.items.map((item) {
          return PopupMenuItem(
            enabled: false,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: StatefulBuilder(
              builder: (context, setInnerState) {
                final isSelected = tempSelected.contains(item);

                return InkWell(
                  onTap: () {
                    setInnerState(() {
                      if (isSelected) {
                        tempSelected.remove(item);
                      } else {
                        tempSelected.add(item);
                      }

                      if (item == 'آخر') {
                        showOtherField = tempSelected.contains('آخر');
                      }
                    });

                    widget.onChanged(tempSelected);
                  },
                  child: Row(
                    children: [
                      _CheckBox(isSelected: isSelected),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          item,
                          textAlign: TextAlign.right,
                          style: TextStyles.font14BlackRegular,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ],
    );

    setState(() => _isFocused = false);
  }
}

class _CheckBox extends StatelessWidget {
  final bool isSelected;

  const _CheckBox({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: isSelected ? ColorsManager.primary : ColorsManager.grey,
          width: 2,
        ),
        color: isSelected ? ColorsManager.primary : Colors.transparent,
      ),
      child: isSelected
          ? Icon(FontAwesomeIcons.check, size: 12.w, color: Colors.white)
          : null,
    );
  }
}
