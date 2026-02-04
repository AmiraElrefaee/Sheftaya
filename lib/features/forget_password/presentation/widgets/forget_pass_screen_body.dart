import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/constants/app_regex.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/utils/snackbar.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/core/widgets/custom_text_form_field.dart';
import 'package:sheftaya/features/forget_password/logic/forget_password_cubit/forget_password_cubit.dart';
import 'package:sheftaya/features/forget_password/logic/forget_password_cubit/forget_password_state.dart';

class ForgetPassScreenBody extends StatelessWidget {
  const ForgetPassScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        state.maybeWhen(
          success: (data) {
            context.push(AppRouter.kVerifyPasswordScreen);
          },
          error: (error) {
            customSnackBar(context, error, ColorsManager.error);
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = context.read<ForgetPasswordCubit>();
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0.w),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'هل نسيت كلمة المرور؟',
                      style: TextStyles.font24BlackBold.copyWith(
                        fontSize: 44.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'لا تقلق! فقط أدخل بريدك الإلكتروني المرتبط بحسابك وسنرسل لك كود التحقق لإعادة تعيين كلمة المرور.',
                      style: TextStyles.font14BlackRegular,
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      'البريد الالكتروني',
                      style: TextStyles.font14BlackRegular,
                    ),
                    SizedBox(height: 8.h),
                    AppTextFormField(
                      controller: cubit.emailController,
                      hintText: 'ادخل بريدك الالكتروني',
                      validator: (value) => AppRegex.validateEmail(value),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 32.h),
                    AppTextButton(
                      buttonText: 'تأكيد',
                      onPressed: () {
                        if (cubit.formKey.currentState!.validate()) {
                          cubit.emitForgetPasswordStates();
                        }
                      },
                      isLoading: isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
