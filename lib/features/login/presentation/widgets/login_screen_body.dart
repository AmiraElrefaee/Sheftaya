import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/constants/app_regex.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/font_weight_helper.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/core/widgets/custom_text_form_field.dart';

class LoginScreenBody extends StatelessWidget {
  const LoginScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    // return BlocConsumer<LoginCubit, LoginState>(
    //   listener: (context, state) {
    //     state.maybeWhen(
    //       success: (data) {
    //         final user = context.read<UserCubit>().state.user;
    //         if (user!.role == "") {
    //           context.go(AppRouter.);
    //         }else {
    //           context.go(AppRouter.);
    //         }
    //       },
    //       error: (error) {
    //         customSnackBar(context, error, ColorsManager.error);
    //       },
    //       orElse: () {},
    //     );
    //   },
    //   builder: (context, state) {
    //     final cubit = context.read<LoginCubit>();
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
            // key: cubit.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'مرحبًا،\nأهلاً بعودتك',
                  style: TextStyles.font24BlackBold.copyWith(fontSize: 44.sp),
                ),
                SizedBox(height: 32.h),
                Text('البريد الإلكتروني', style: TextStyles.font14BlackRegular),
                SizedBox(height: 8.h),
                AppTextFormField(
                  // controller: cubit.emailController,
                  hintText: 'ادخل البريد الالكتروني',
                  validator: (value) => AppRegex.validateEmail(value),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.h),
                Text('كلمة المرور', style: TextStyles.font14BlackRegular),
                SizedBox(height: 8.h),

                _PasswordField(
                  //cubit: cubit
                ),
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      GoRouter.of(context).push(AppRouter.kForgetPassScreen);
                    },
                    child: Text(
                      'نسيت كلمة المرور؟',
                      style: TextStyles.font12PrimaryBold.copyWith(
                        fontWeight: FontWeightHelper.semiBold,
                        decoration: TextDecoration.underline,
                        decorationColor: ColorsManager.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                AppTextButton(
                  buttonText: 'تسجيل الدخول',
                  onPressed: () {
                    // if (cubit.formKey.currentState!.validate()) {
                    //   cubit.emitLoginStates();
                    // }
                  },
                  //isLoading: isLoading,
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ليس لديك حساب؟ ',
                      style: TextStyles.font14BlackRegular.copyWith(
                        color: ColorsManager.grey,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        GoRouter.of(context).push(AppRouter.kSignUpScreen);
                      },
                      child: Text(
                        'سجل الآن',
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

  // );
}
//}

class _PasswordField extends StatefulWidget {
  //final LoginCubit cubit;

  const _PasswordField(
    //  {required this.cubit}
  );

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool isPasswordObscureText = true;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      //controller: widget.cubit.passwordController,
      hintText: 'ادخل كلمة المرور',
      obscureText: isPasswordObscureText,
      validator: (value) => AppRegex.validatePassword(value),
      suffixIcon: InkWell(
        onTap: () {
          setState(() {
            isPasswordObscureText = !isPasswordObscureText;
          });
        },
        child: Icon(
          size: 20.w,
          isPasswordObscureText ? Icons.visibility_off : Icons.visibility,
        ),
      ),
    );
  }
}
