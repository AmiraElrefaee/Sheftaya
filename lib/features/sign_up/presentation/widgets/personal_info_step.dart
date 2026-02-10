import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/constants/app_regex.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_text_form_field.dart';
import 'package:sheftaya/core/widgets/app_dropdown.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';

class PersonalInfoStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;
  final TextEditingController dateController;
  final List<String> governorates;
  final String? selectedGovernorate;
  final ValueChanged<String?> onGovernorateChanged;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onPickDate;
  final bool showGovernorateError; 

  const PersonalInfoStep({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.passwordConfirmController,
    required this.dateController,
    required this.governorates,
    required this.selectedGovernorate,
    required this.onGovernorateChanged,
    required this.selectedDate,
    required this.onPickDate,
    this.showGovernorateError = false, 
  });

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep> {
  bool isPasswordObscureText = true;
  bool isConfirmPasswordObscureText = true;

  Future<void> _showDatePicker(BuildContext context) async {
    final initial = DateTime.now().subtract(const Duration(days: 365 * 25));

    final picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? initial,
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

    if (picked != null) {
      widget.onPickDate(picked);
      widget.dateController.text =
          '${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
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
                        controller: widget.firstNameController,
                        hintText: 'ادخل الاسم الاول',
                        validator: AppRegex.validateFirstName,
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
                        controller: widget.lastNameController,
                        hintText: 'ادخل اسم العائلة',
                        validator: AppRegex.validateLastName,
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
              controller: widget.emailController,
              hintText: 'ادخل بريدك الالكتروني',
              keyboardType: TextInputType.emailAddress,
              validator: AppRegex.validateEmail,
            ),
            SizedBox(height: 12.h),
            Text('المحافظة', style: TextStyles.font14BlackRegular),
            SizedBox(height: 8.h),
            AppDropdown(
              items: widget.governorates,
              value: widget.selectedGovernorate,
              hint: 'اختر محافظتك',
              onChanged: widget.onGovernorateChanged,
              hasError: widget.showGovernorateError,
              errorMessage: 'المحافظة مطلوبة',
            ),

            SizedBox(height: 12.h),
            Text(
              'تاريخ الميلاد (إختياري)',
              style: TextStyles.font14BlackRegular,
            ),
            SizedBox(height: 8.h),
            AppTextFormField(
              controller: widget.dateController,
              hintText: widget.selectedDate == null
                  ? 'يوم/شهر/سنة'
                  : widget.dateController.text,
              readOnly: true,
              validator: (value) => null,
              onTap: () => _showDatePicker(context),
              suffixIcon: Icon(
                Icons.calendar_today,
                size: 20.w,
                color: ColorsManager.grey,
              ),
            ),
            SizedBox(height: 12.h),
            Text('رقم الهاتف (إختياري)', style: TextStyles.font14BlackRegular),
            SizedBox(height: 8.h),
            AppTextFormField(
              controller: widget.phoneController,
              hintText: 'ادخل رقم الهاتف',
              keyboardType: TextInputType.phone,
              validator: AppRegex.validateOptionalPhone,
            ),
            SizedBox(height: 12.h),
            Text('كلمة المرور', style: TextStyles.font14BlackRegular),
            SizedBox(height: 8.h),
            AppTextFormField(
              controller: widget.passwordController,
              hintText: 'ادخل كلمة المرور',
              obscureText: isPasswordObscureText,
              validator: AppRegex.validatePassword,
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    isPasswordObscureText = !isPasswordObscureText;
                  });
                },
                child: Icon(
                  size: 20.w,
                  isPasswordObscureText
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Text('تأكيد كلمة المرور', style: TextStyles.font14BlackRegular),
            SizedBox(height: 8.h),
            AppTextFormField(
              controller: widget.passwordConfirmController,
              hintText: 'اعد ادخال كلمة المرور',
              obscureText: isConfirmPasswordObscureText,
              validator: (v) => AppRegex.validateConfirmPassword(
                v,
                widget.passwordController.text,
              ),
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    isConfirmPasswordObscureText =
                        !isConfirmPasswordObscureText;
                  });
                },
                child: Icon(
                  size: 20.w,
                  isConfirmPasswordObscureText
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
