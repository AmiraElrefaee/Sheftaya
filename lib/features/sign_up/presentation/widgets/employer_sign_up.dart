import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/app_dropdown.dart';
import 'package:sheftaya/core/widgets/custom_text_form_field.dart';
import 'package:sheftaya/core/widgets/app_multi_select_dropdown.dart';
import 'package:sheftaya/features/sign_up/presentation/widgets/upload_tile.dart';

class EmployerSignUp extends StatelessWidget {
  final TextEditingController institutionNameController;
  final String? institutionType;
  final ValueChanged<String?> onTypeChanged;
  final List<String> availableJobs;
  final ValueChanged<List<String>> onAvailableJobsChanged;
  final List<String> sampleJobs;
  final TextEditingController institutionAddressController;
  final TextEditingController taxNumberController;
  final VoidCallback onPickInstitutionImages;

  const EmployerSignUp({
    super.key,
    required this.institutionNameController,
    required this.institutionType,
    required this.onTypeChanged,
    required this.availableJobs,
    required this.onAvailableJobsChanged,
    required this.sampleJobs,
    required this.institutionAddressController,
    required this.taxNumberController,
    required this.onPickInstitutionImages,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> institutionTypes = [
      'شركة',
      'مزرعة',
      'ورشة',
      'محل تجاري',
      'مطعم',
      'كافيه',
      'فندق',
      'مصنع',
      'مخزن',
      'آخر',
    ];

    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'معلومات المؤسسة',
            style: TextStyles.font16BlackBold.copyWith(fontSize: 20.sp),
          ),
          SizedBox(height: 12.h),

          Text('اسم المؤسسة', style: TextStyles.font14BlackRegular),
          SizedBox(height: 8.h),
          AppTextFormField(
            controller: institutionNameController,
            hintText: 'ادخل اسم مؤسستك',
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'هذا الحقل مطلوب';
              return null;
            },
          ),

          SizedBox(height: 12.h),
          Text('نوع المؤسسة', style: TextStyles.font14BlackRegular),
          SizedBox(height: 8.h),

          AppDropdown(
            items: institutionTypes,
            value: institutionType,
            hint: 'اختر نوع المؤسسة',
            onChanged: (value) {
              onTypeChanged(value);
            },
          ),

          SizedBox(height: 12.h),
          Text('الوظائف المتاحة لديك', style: TextStyles.font14BlackRegular),
          SizedBox(height: 8.h),
          AppMultiSelectDropdown(
            items: sampleJobs,
            selectedValues: availableJobs,
            hint: 'اختر الوظائف المتاحة لديك',
            onChanged: onAvailableJobsChanged,
          ),

          SizedBox(height: 12.h),
          Text('عنوان المؤسسة التفصيلي', style: TextStyles.font14BlackRegular),
          SizedBox(height: 8.h),
          AppTextFormField(
            controller: institutionAddressController,
            hintText: 'ادخل عنوان المؤسسة التفصيلي',
            maxLines: 2,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'هذا الحقل مطلوب';
              return null;
            },
          ),

          SizedBox(height: 12.h),
          Text('الرقم الضريبي (اذا وجد)', style: TextStyles.font14BlackRegular),
          SizedBox(height: 8.h),
          AppTextFormField(
            controller: taxNumberController,
            hintText: '000-000-000',
            validator: (v) => null,
          ),

          SizedBox(height: 12.h),
          Text('صور المؤسسة (اختياري)', style: TextStyles.font14BlackRegular),
          SizedBox(height: 8.h),
          UploadTile(
            label: 'ارفع صور المؤسسة',
            onPick: onPickInstitutionImages,
            acceptPdf: false,
          ),
        ],
      ),
    );
  }
}
