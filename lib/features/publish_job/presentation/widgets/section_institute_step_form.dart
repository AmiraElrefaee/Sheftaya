import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/features/publish_job/presentation/widgets/section_image_upload.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import 'custom_label_text.dart';

class InstitutionStepForm extends StatelessWidget {
  final TextEditingController nameController, addressController, taxController;
  const InstitutionStepForm({super.key, required this.nameController, required this.addressController, required this.taxController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("معلومات المؤسسة", style: TextStyles.font16BlackBold),
        SizedBox(height: 16.h),
        const CustomLabelText(text: 'اسم المؤسسة'),
        AppTextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {return 'هذا الحقل مطلوب';}
              return null;},
            controller: nameController, hintText: 'ادخل اسم مؤسستك'),
        SizedBox(height: 16.h),
        const CustomLabelText(text: 'نوع المؤسسة'),
        AppDropdown(items: const ['مطعم', 'كافيه', 'آخر'], onChanged: (v) {}, hint: 'اختار نوع مؤسستك'),
        SizedBox(height: 16.h),
        const CustomLabelText(text: 'عنوان المؤسسة التفصيلي'),
        AppTextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'هذا الحقل مطلوب';}return null;},
            controller: addressController, hintText: 'ادخل عنوان مؤسستك التفصيلي'),
        SizedBox(height: 16.h),
        const CustomLabelText(text: 'الرقم الضريبي (إذا وجد)'),
        AppTextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'هذا الحقل مطلوب';}return null;},
            controller: taxController, hintText: '000-000-000', keyboardType: TextInputType.number),
        SizedBox(height: 16.h),
        const CustomLabelText(text: 'صور المؤسسة (اختياري)'),
        const ImageUploadWidget(),
      ],
    );
  }
}
