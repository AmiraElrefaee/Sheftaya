import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/constants/user_model.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_text_form_field.dart';

class ProfileDataView extends StatelessWidget {
  final UserModel user;
  const ProfileDataView({required this.user, super.key});

  Widget label(String key) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(key, style: TextStyles.font14BlackRegular),
    );
  }

  Widget readOnlyField(String? value, {int maxLines = 1}) {
    return AppTextFormField(
      controller: TextEditingController(text: value ?? '-'),
      hintText: '',
      maxLines: maxLines,
      enabled: false,
    );
  }

  Widget chipsFromList(List<String>? items) {
    final list = items ?? [];
    if (list.isEmpty) {
      return Text('-', style: TextStyles.font14BlackRegular);
    }

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: list.map((s) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: ColorsManager.primary.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: ColorsManager.primary.withValues(alpha: 0.18),
            ),
          ),
          child: Text(s, style: TextStyles.font14PrimaryRegular),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTeacher = (user.role ?? '').toLowerCase() == 'teacher';
    final isStudent = (user.role ?? '').toLowerCase() == 'student';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// Names
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  label('profile.first_name'),
                  readOnlyField(user.firstname),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  label('profile.last_name'),
                  readOnlyField(user.lastname),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        /// Email
        label('profile.email'),
        readOnlyField(user.email),

        SizedBox(height: 16.h),

        /// Phone
        label('profile.phone'),
        readOnlyField(user.phone),

        SizedBox(height: 24.h),

        /// ================= Teacher =================
        // if (isTeacher) ...[
        //   label('profile.education_system'),
        //   chipsFromList(user.educationSystem),
        //   SizedBox(height: 16.h),

        //   label('profile.academic_stages'),
        //   chipsFromList(user.academicStages),
        //   SizedBox(height: 16.h),

        //   label('profile.subjects'),
        //   chipsFromList(user.subjects),
        //   SizedBox(height: 16.h),

        //   label('profile.school'),
        //   readOnlyField(user.school),
        //   SizedBox(height: 16.h),

        //   label('profile.experience_years'),
        //   readOnlyField(
        //     user.experienceYears != null
        //         ? "${user.experienceYears} ${'profile.years'.tr()}"
        //         : null,
        //   ),
        //   SizedBox(height: 16.h),

        //   label('profile.price_per_hour'),
        //   readOnlyField(
        //     user.pricePerHour != null
        //         ? "${user.pricePerHour} ${'profile.egp'.tr()}"
        //         : null,
        //   ),
        //   SizedBox(height: 16.h),

        //   label('profile.bio'),
        //   readOnlyField(user.bio, maxLines: 4),
        //   SizedBox(height: 16.h),
        // ],

        // /// ================= Student =================
        // if (isStudent) ...[
        //   label('profile.education_system'),
        //   readOnlyField(user.studentEducationSystem),
        //   SizedBox(height: 16.h),

        //   label('profile.grade'),
        //   readOnlyField(user.studentGrade),
        //   SizedBox(height: 16.h),

        //   label('profile.school'),
        //   readOnlyField(user.studentSchool),
        //   SizedBox(height: 16.h),
        // ],
      ],
    );
  }
}
