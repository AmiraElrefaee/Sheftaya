// lib/features/publish_job/presentation/widgets/section_institute_step_form.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/features/publish_job/presentation/widgets/section_image_upload.dart';

import '../../../../core/theme/colors_manager.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import 'custom_label_text.dart';

class InstitutionStepForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController taxController;
  final TextEditingController typeController;
  final Function(List<String>)? onImagesChanged;

  const InstitutionStepForm({
    super.key,
    required this.nameController,
    required this.addressController,
    required this.taxController,
    required this.typeController,
    this.onImagesChanged,
  });

  @override
  State<InstitutionStepForm> createState() => _InstitutionStepFormState();
}

class _InstitutionStepFormState extends State<InstitutionStepForm> {
  String? _selectedType;
  bool _showOtherField = false;
  final TextEditingController _otherTypeController = TextEditingController();

  final List<String> _institutionTypes = [
    'مطعم',
    'كافيه',
    'مخبز',
    'سوبر ماركت',
    'آخر',
  ];

  @override
  void dispose() {
    _otherTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("معلومات المؤسسة", style: TextStyles.font16BlackBold),
        SizedBox(height: 16.h),

        // ✅ اسم المؤسسة
        const CustomLabelText(text: 'اسم المؤسسة'),
        AppTextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'هذا الحقل مطلوب';
            }
            return null;
          },
          controller: widget.nameController,
          hintText: 'ادخل اسم مؤسستك',
        ),
        SizedBox(height: 16.h),

        // ✅ نوع المؤسسة - باستخدام DropdownButtonFormField
        const CustomLabelText(text: 'نوع المؤسسة'),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: ColorsManager.grey),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedType,
            isExpanded: true,
            hint: Text(
              'اختار نوع مؤسستك',
              style: TextStyles.font14BlackRegular.copyWith(
                color: ColorsManager.grey,
              ),
            ),
            items: _institutionTypes.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(
                  type,
                  style: TextStyles.font14BlackRegular,
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedType = newValue;
                widget.typeController.text = newValue ?? '';

                // ✅ إذا اختار "آخر"، أظهر الحقل الإضافي
                _showOtherField = newValue == 'آخر';

                // ✅ إذا لم يختر "آخر"، امسح الـ Other Controller
                if (newValue != 'آخر') {
                  _otherTypeController.clear();
                }
              });
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              suffixIcon: Icon(
                Icons.arrow_drop_down,
                color: ColorsManager.grey,
                size: 24.w,
              ),
            ),
          ),
        ),

        // ✅ إذا اختار "آخر"، أظهر TextField إضافي
        if (_showOtherField) ...[
          SizedBox(height: 12.h),
          const CustomLabelText(text: 'اكتب نوع المؤسسة'),
          AppTextFormField(
            controller: _otherTypeController,
            hintText: 'مثال: ورشة نجارة، مركز تدريب...',
            onChanged: (value) {
              widget.typeController.text = value;
            },
          ),
        ],

        SizedBox(height: 16.h),

        // ✅ عنوان المؤسسة
        const CustomLabelText(text: 'عنوان المؤسسة التفصيلي'),
        AppTextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'هذا الحقل مطلوب';
            }
            return null;
          },
          controller: widget.addressController,
          hintText: 'ادخل عنوان مؤسستك التفصيلي',
        ),
        SizedBox(height: 16.h),

        // ✅ الرقم الضريبي
        const CustomLabelText(text: 'الرقم الضريبي (إذا وجد)'),
        AppTextFormField(
          controller: widget.taxController,
          hintText: '000-000-000',
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.h),

        // ✅ صور المؤسسة
        const CustomLabelText(text: 'صور المؤسسة (اختياري)'),
        ImageUploadWidget(
          onImagesChanged: (images) {
            if (widget.onImagesChanged != null) {
              widget.onImagesChanged!(images);
            }
          },
        ),
      ],
    );
  }
}