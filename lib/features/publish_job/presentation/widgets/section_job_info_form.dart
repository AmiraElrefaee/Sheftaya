import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/features/publish_job/presentation/widgets/section_build_term_check_boc.dart';
import 'package:sheftaya/features/publish_job/presentation/widgets/section_date.dart';
import 'package:sheftaya/features/publish_job/presentation/widgets/section_experience_salary.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import 'counter_field.dart';
import 'custom_label_text.dart';

class JobInfoStepForm extends StatelessWidget {
  final TextEditingController titleController, locationController, salaryController, detailsController, reqController, dateController, timeController;
  final Function(int) onDaysChanged, onHoursChanged, onWorkersChanged;
  final Function(String?) onExperienceChanged;
  final Function(double lat, double lng) onLocationSelected;
  final ValueChanged<bool>? onTermsChanged; // ✅ إضافة الـ Callback

  const JobInfoStepForm({
    super.key,
    required this.titleController,
    required this.locationController,
    required this.salaryController,
    required this.detailsController,
    required this.reqController,
    required this.dateController,
    required this.timeController,
    required this.onDaysChanged,
    required this.onHoursChanged,
    required this.onWorkersChanged,
    required this.onExperienceChanged,
    required this.onLocationSelected,
    this.onTermsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Text("معلومات الوظيفة", style: TextStyles.font16BlackBold),
        SizedBox(height: 16.h),
        const CustomLabelText(text: 'عنوان الوظيفة'),
        AppTextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'هذا الحقل مطلوب';
            }
            return null;
          },
          controller: titleController,
          hintText: 'مثال: عامل كافيه',
        ),
        SizedBox(height: 16.h),
        const CustomLabelText(text: 'موقع العمل'),
        AppTextFormField(
          readOnly: true,
          onTap: () async {
            final result = await context.push(AppRouter.kMapPickerScreen);
            if (result != null && result is Map<String, dynamic>) {
              locationController.text = result['address'];
              onLocationSelected(result['lat'], result['lng']);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'هذا الحقل مطلوب';
            }
            return null;
          },
          controller: locationController,
          hintText: 'اضغط لتحديد موقع العمل على الخريطة',
          suffixIcon: Icon(Icons.location_on, color: Colors.red),
        ),
        SizedBox(height: 16.h),
        SectionDate(
          dateController: dateController,
          timeController: timeController,
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: CounterFieldWidget(
                label: 'عدد الأيام',
                initialValue: 1,
                onChanged: onDaysChanged,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CounterFieldWidget(
                label: 'عدد الساعات اليومية',
                initialValue: 1,
                onChanged: onHoursChanged,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CounterFieldWidget(
                label: 'عدد العمال',
                initialValue: 1,
                onChanged: onWorkersChanged,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        sectionExpericeAndSalay(
          salaryController: salaryController,
          onExperienceChanged: onExperienceChanged,
        ),
        SizedBox(height: 16.h),
        const CustomLabelText(text: 'تفاصيل الوظيفة'),
        AppTextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'هذا الحقل مطلوب';
            }
            return null;
          },
          controller: detailsController,
          hintText: 'اكتب تفاصيل الوظيفة',
          maxLines: 4,
        ),
        SizedBox(height: 16.h),
        const CustomLabelText(text: 'متطلبات الوظيفة'),
        AppTextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'هذا الحقل مطلوب';
            }
            return null;
          },
          controller: reqController,
          hintText: 'اكتب متطلبات الوظيفة',
          maxLines: 4,
        ),
        SizedBox(height: 20.h),
        SectionBuildTermCheckBoc(
          onChanged: onTermsChanged, // ✅ تمرير الـ Callback
        ),
      ],
    );
  }
}