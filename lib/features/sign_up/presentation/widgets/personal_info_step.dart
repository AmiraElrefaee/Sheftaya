import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_text_form_field.dart';
import 'package:sheftaya/core/widgets/app_dropdown.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';

class PersonalInfoStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;
  final List<String> governorates;
  final String? selectedGovernorate;
  final ValueChanged<String?> onGovernorateChanged;
  final DateTime? selectedDate;
  final TextEditingController dateController;
  final ValueChanged<DateTime> onPickDate;

  const PersonalInfoStep({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.passwordConfirmController,
    required this.governorates,
    required this.selectedGovernorate,
    required this.onGovernorateChanged,
    required this.selectedDate,
    required this.dateController,
    required this.onPickDate,
  });

  Future<void> _showDatePicker(BuildContext context) async {
    final initial = DateTime.now().subtract(const Duration(days: 365 * 25));
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: ColorsManager.primary),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: ColorsManager.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) onPickDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.only(bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 8.h),
            Text(
              'المعلومات الشخصية',
              style: TextStyles.font16BlackBold.copyWith(fontSize: 20.sp),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('الاسم الاول', style: TextStyles.font14BlackRegular),
                      SizedBox(height: 8.h),
                      AppTextFormField(
                        controller: firstNameController,
                        hintText: 'ادخل الاسم الاول',
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'هذا الحقل مطلوب';
                          }
                          if (v.trim().length < 2) return 'ادخل اسم صحيح';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('اسم العائلة', style: TextStyles.font14BlackRegular),
                      SizedBox(height: 8.h),
                      AppTextFormField(
                        controller: lastNameController,
                        hintText: 'ادخل اسم العائلة',
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'هذا الحقل مطلوب';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text('البريد الالكتروني', style: TextStyles.font14BlackRegular),
            SizedBox(height: 8.h),
            AppTextFormField(
              controller: emailController,
              hintText: 'ادخل بريدك الالكتروني',
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'هذا الحقل مطلوب';
                if (!RegExp(
                  r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}$',
                ).hasMatch(v)) {
                  return 'بريد غير صالح';
                }
                return null;
              },
            ),
            SizedBox(height: 12.h),
            Text('المحافظة', style: TextStyles.font14BlackRegular),
            SizedBox(height: 8.h),
            AppDropdown(
              items: governorates,
              value: selectedGovernorate,
              hint: 'اختر محافظتك',
              onChanged: onGovernorateChanged,
            ),
            SizedBox(height: 12.h),
            Text(
              'تاريخ الميلاد (إختيارى)',
              style: TextStyles.font14BlackRegular,
            ),
            SizedBox(height: 8.h),
            AppTextFormField(
              controller: dateController,
              hintText: selectedDate == null
                  ? 'يوم/شهر/سنة'
                  : '${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}',
              readOnly: true,
              onTap: () => _showDatePicker(context),
              validator: (v) {
                if (selectedDate == null) return 'هذا الحقل مطلوب';
                return null;
              },
              suffixIcon: Icon(
                Icons.calendar_today,
                size: 20.w,
                color: ColorsManager.grey,
              ),
            ),
            SizedBox(height: 12.h),
            Text('رقم الهاتف (إختيارى)', style: TextStyles.font14BlackRegular),
            SizedBox(height: 8.h),
            AppTextFormField(
              controller: phoneController,
              hintText: '000-0000-0000',
              keyboardType: TextInputType.phone,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'هذا الحقل مطلوب';
                if (!RegExp(r'^[0-9+\-\s]{7,15}$').hasMatch(v)) {
                  return 'رقم غير صالح';
                }
                return null;
              },
            ),
            SizedBox(height: 12.h),
            Text('كلمة المرور', style: TextStyles.font14BlackRegular),
            SizedBox(height: 8.h),
            AppTextFormField(
              controller: passwordController,
              hintText: 'ادخل كلمة المرور',
              obscureText: true,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'هذا الحقل مطلوب';
                if (v.length < 6) return 'الحد الأدنى 6 أحرف';
                return null;
              },
            ),
            SizedBox(height: 12.h),
            Text('تأكيد كلمة المرور', style: TextStyles.font14BlackRegular),
            SizedBox(height: 8.h),
            AppTextFormField(
              controller: passwordConfirmController,
              hintText: 'اعد ادخال كلمة المرور',
              obscureText: true,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'هذا الحقل مطلوب';
                if (v != passwordController.text) {
                  return 'كلمات المرور غير متطابقة';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
