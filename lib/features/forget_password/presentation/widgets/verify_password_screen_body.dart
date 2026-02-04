import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/utils/snackbar.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/features/forget_password/logic/forget_password_cubit/forget_password_cubit.dart';
import 'package:sheftaya/features/forget_password/logic/verify_password_cubit/verify_password_cubit.dart';
import 'package:sheftaya/features/forget_password/logic/verify_password_cubit/verify_password_state.dart';


class VerifyPasswordScreenBody extends StatelessWidget {
  const VerifyPasswordScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyPasswordCubit, VerifyPasswordState>(
      listener: (context, state) {
        state.maybeWhen(
          success: (data) {
            context.push(AppRouter.kCreateNewPasswordScreen);
          },
          error: (error) {
            customSnackBar(context, error, ColorsManager.error);
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = context.read<VerifyPasswordCubit>();
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        final defaultPinTheme = PinTheme(
          width: 55.w,
          height: 55.h,
          textStyle: TextStyles.font16BlackRegular,
          decoration: BoxDecoration(
            color: const Color(0xffe5e9ef),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xffe5e9ef), width: 2),
          ),
        );

        final focusedPinTheme = defaultPinTheme.copyWith(
          decoration: BoxDecoration(
            color: const Color(0xffe5e9ef),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: ColorsManager.primary, width: 2),
          ),
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
                      'رمز التحقق من حسابك',
                      style: TextStyles.font24BlackBold.copyWith(
                        fontSize: 44.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'لقد أرسلنا رمز التحقق إلى بريدك الإلكتروني. يرجى إدخال الرمز أدناه للتحقق من حسابك.',
                      style: TextStyles.font14BlackRegular,
                    ),
                    SizedBox(height: 32.h),
                    Pinput(
                      controller: cubit.otpField,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'رمز التحقق مطلوب';
                        }
                        if (value.length < 6) {
                          return 'الرمز يجب أن يتكون من 6 أرقام';
                        }
                        return null;
                      },
                      length: 6,
                      showCursor: true,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                    ),
                    SizedBox(height: 32.h),
                    AppTextButton(
                      buttonText: 'تأكيد',
                      onPressed: () {
                        if (cubit.formKey.currentState!.validate()) {
                          cubit.emitVerifyPasswordStates();
                        }
                      },
                      isLoading: isLoading,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'لم يصلك رمز التحقق؟',
                          style: TextStyles.font14BlackRegular,
                        ),
                        InkWell(
                          onTap: () async {
                           await context
                               .read<ForgetPasswordCubit>()
                               .emitForgetPasswordStates();
                            if (context.mounted) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.bottomSlide,
                                title: 'تم إرسال الرمز',
                                titleTextStyle: TextStyles.font16BlackBold.copyWith(
                                  fontSize: 20.sp,
                                ),
                                desc:
                                    'تم إرسال رمز التحقق الجديد إلى بريدك الإلكتروني',
                                descTextStyle: TextStyles.font14BlackRegular,
                                btnOkText: 'حسناً',
                                btnOkOnPress: () {},
                                btnOkColor: ColorsManager.primary,
                                dismissOnBackKeyPress: true,
                                dismissOnTouchOutside: true,
                                width: 400,
                               padding: EdgeInsets.all(20.w),
              dialogBorderRadius: BorderRadius.circular(20.r),
                                showCloseIcon: false,
                                buttonsTextStyle: TextStyles.font14WhiteBold,
                                dialogBackgroundColor: Colors.white,
                                customHeader: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 100,
                                ),
                              ).show();
                            }
                          },
                          child: Text(
                            'إعادة الإرسال',
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
      },
    );
  }
}
