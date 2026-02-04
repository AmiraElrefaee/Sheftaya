import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/constants/app_regex.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/core/widgets/custom_text_form_field.dart';

class SignUpScreenBody extends StatefulWidget {
  const SignUpScreenBody({super.key});

  @override
  State<SignUpScreenBody> createState() => _SignUpScreenBodyState();
}

class _SignUpScreenBodyState extends State<SignUpScreenBody> {
  bool isPasswordObscureText = true;
  bool isConfirmPasswordObscureText = true;
  bool userTypeHasError = false;
  bool genderHasError = false;
  DateTime? selectedDate;

  // Future<void> _selectDate(BuildContext context, SignupCubit cubit) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //     locale: const Locale('ar', 'EG'),
  //     builder: (context, child) {
  //       return Theme(
  //         data: Theme.of(context).copyWith(
  //           colorScheme: Theme.of(
  //             context,
  //           ).colorScheme.copyWith(primary: ColorsManager.primary),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       selectedDate = picked;
  //     });
  //     cubit.updateDateOfBirth(picked.day, picked.month, picked.year);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // return BlocConsumer<SignupCubit, SignupState>(
    //   listener: (context, state) {
    //     state.maybeWhen(
    //       success: (data) {
    //         context.push(AppRouter.kVerifyAccountScreen);
    //       },
    //       error: (error) {
    //         customSnackBar(context, error, ColorsManager.error);
    //       },
    //       orElse: () {},
    //     );
    //   },
    //   builder: (context, state) {
    //     final cubit = context.read<SignupCubit>();
    //     final isLoading = state.maybeWhen(
    //       loading: () => true,
    //       orElse: () => false,
    //     );

        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0.w),
              child: Form(
                //key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                      onTap: () {
                        GoRouter.of(
                          context,
                        ).push(AppRouter.kVerifyAccountScreen);
                      },
                      child: Text(
                        'إنشاء حساب',
                        style: TextStyles.font24BlackBold.copyWith(
                          fontSize: 40,
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'الاسم الاول',
                                style: TextStyles.font14BlackRegular,
                              ),
                              SizedBox(height: 8.h),
                              AppTextFormField(
                                //controller: cubit.firstNameController,
                                hintText: 'ادخل اسمك',
                                validator:
                                    (value) =>
                                        AppRegex.validateFirstName(value),
                                width: double.infinity,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'اسم العائلة',
                                style: TextStyles.font14BlackRegular,
                              ),
                              SizedBox(height: 8.h),
                              AppTextFormField(
                                //controller: cubit.lastNameController,
                                hintText: 'ادخل اسم العائلة',
                                validator:
                                    (value) => AppRegex.validateLastName(value),
                                width: double.infinity,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'البريد الالكتروني',
                      style: TextStyles.font14BlackRegular,
                    ),
                    SizedBox(height: 8.h),
                    AppTextFormField(
                     // controller: cubit.emailController,
                      hintText: 'ادخل بريدك الالكتروني',
                      validator: (value) => AppRegex.validateEmail(value),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    
                    SizedBox(height: 16.h),
                    Text('تاريخ الميلاد', style: TextStyles.font14BlackRegular),
                    SizedBox(height: 8.h),
                    AppTextFormField(
                     // controller: cubit.dateOfBirthController,
                      hintText: 'سنة/ شهر/ يوم',
                      validator: (value) => AppRegex.validateDateOfBirth(value),
                      readOnly: true,
                     // onTap: () => _selectDate(context, cubit),
                      suffixIcon: Icon(Icons.calendar_today, size: 20.w),
                    ),
                    SizedBox(height: 16.h),
                    Text('رقم الهاتف', style: TextStyles.font14BlackRegular),
                    SizedBox(height: 8.h),
                    AppTextFormField(
                     // controller: cubit.phoneController,
                      hintText: '000-0000-0000',
                      validator: (value) => AppRegex.validatePhoneNumber(value),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16.h),
                    Text('كلمه المرور', style: TextStyles.font14BlackRegular),
                    SizedBox(height: 8.h),
                    _PasswordField(
                     // controller: cubit.passwordController,
                      isObscure: isPasswordObscureText,
                      onToggle: () {
                        setState(() {
                          isPasswordObscureText = !isPasswordObscureText;
                        });
                      },
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'تاكيد كلمه المرور',
                      style: TextStyles.font14BlackRegular,
                    ),
                    SizedBox(height: 8.h),
                    _PasswordField(
                     // controller: cubit.passwordConfirmController,
                      isObscure: isConfirmPasswordObscureText,
                      onToggle: () {
                        setState(() {
                          isConfirmPasswordObscureText =
                              !isConfirmPasswordObscureText;
                        });
                      },
                    //  confirmPassword: cubit.passwordController.text,
                    ),
                
                   
                    SizedBox(height: 32.h),
                    AppTextButton(
                      buttonText: 'سجل الآن',
                      onPressed: () {
                        //final isValid = cubit.formKey.currentState!.validate();
                        
                        setState(() {
                        });

                         // cubit.emitSignupStates();
                        
                      },
                      //isLoading: isLoading,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'لديك حساب بالفعل؟ ',
                          style: TextStyles.font14BlackRegular,
                        ),
                        InkWell(
                          onTap: () {
                            context.go(AppRouter.kLoginScreen);
                          },
                          child: Text(
                            'سجل الدخول',
                            style: TextStyles.font14PrimaryBold.copyWith(
                              decoration: TextDecoration.underline,
                              decorationColor: ColorsManager.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    //);
  }
//}

class _PasswordField extends StatelessWidget {
  final TextEditingController? controller;
  final bool isObscure;
  final VoidCallback onToggle;
  final String? confirmPassword;

  const _PasswordField({
     this.controller,
    required this.isObscure,
    required this.onToggle,
    this.confirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      hintText: 'ادخل كلمه مرورك',
      obscureText: isObscure,
      validator:
          confirmPassword != null
              ? (value) =>
                  AppRegex.validateConfirmPassword(value, confirmPassword)
              : (value) => AppRegex.validatePassword(value),
      suffixIcon: InkWell(
        onTap: onToggle,
        child: Icon(
          size: 20.w,
          isObscure ? Icons.visibility_off : Icons.visibility,
        ),
      ),
    );
  }
}
