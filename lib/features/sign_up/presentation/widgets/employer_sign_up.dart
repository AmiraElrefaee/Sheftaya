import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/app_dropdown.dart';
import 'package:sheftaya/core/widgets/custom_text_form_field.dart';
import 'package:sheftaya/core/widgets/app_multi_select_dropdown.dart';

class EmployerSignUp extends StatelessWidget {
  final TextEditingController institutionNameController;
  final String? institutionType;
  final ValueChanged<String?> onTypeChanged;
  final List<String> availableJobs;
  final ValueChanged<List<String>> onAvailableJobsChanged;
  final List<String> sampleJobs;
  final TextEditingController institutionAddressController;
  final TextEditingController taxNumberController;
  final List<String> institutionGovernorates;
  final String? institutiSelectedGovernorate;
  final ValueChanged<String?> institutionOnGovernorateChanged;

  final List<File> institutionImages;
  final VoidCallback onPickInstitutionImages;
  final ValueChanged<int> onRemoveInstitutionImage;

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
    required this.institutionGovernorates,
    this.institutiSelectedGovernorate,
    required this.institutionOnGovernorateChanged,
    required this.institutionImages,
    required this.onPickInstitutionImages,
    required this.onRemoveInstitutionImage,
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
          Container(
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey, width: 1.w),
            ),
            child: Text(
              '⚠️ إذا كنت صاحب مؤسسة، يرجى تزويدنا بمعلومات عن مؤسستك لتتمكن من نشر الوظائف المتاحة لديك.',
              style: TextStyles.font12PrimarySemiBold,
            ),
          ),
          SizedBox(height: 16.h),
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
            onChanged: onTypeChanged,
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
          Text('اين تقع مؤسستك', style: TextStyles.font14BlackRegular),
          SizedBox(height: 8.h),
          AppDropdown(
            items: institutionGovernorates,
            value: institutiSelectedGovernorate,
            hint: 'اختر المحافظة',
            onChanged: institutionOnGovernorateChanged,
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
          _EmployerImagesSection(
            images: institutionImages,
            onPickImages: onPickInstitutionImages,
            onRemoveImage: onRemoveInstitutionImage,
          ),
        ],
      ),
    );
  }
}

class _EmployerImagesSection extends StatelessWidget {
  final List<File> images;
  final VoidCallback onPickImages;
  final ValueChanged<int> onRemoveImage;

  const _EmployerImagesSection({
    required this.images,
    required this.onPickImages,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('صور المؤسسة (إختياري)', style: TextStyles.font14BlackRegular),
        SizedBox(height: 8.h),
        Row(
          children: [
            InkWell(
              onTap: onPickImages,
              child: Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.add_a_photo, size: 30.sp),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: SizedBox(
                height: 60.w,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final file = images[index];
                    return Stack(
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.w,
                          margin: EdgeInsets.only(right: 8.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            image: DecorationImage(
                              image: FileImage(file),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -5,
                          right: -5,
                          child: GestureDetector(
                            onTap: () => onRemoveImage(index),
                            child: CircleAvatar(
                              radius: 10.r,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close, size: 14.sp, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
