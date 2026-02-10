import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/features/sign_up/logic/sign_up/sign_up_cubit.dart';
import 'package:sheftaya/features/sign_up/logic/verify_sign_up/verify_signup_cubit.dart';
import 'package:sheftaya/features/sign_up/logic/verify_sign_up/verify_signup_state.dart';

class VerifyAccountScreenBody extends StatelessWidget {
  const VerifyAccountScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifySignupCubit, VerifySignupState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (data) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.scale,
              title: 'تم تفعيل الحساب',
              desc: 'تم تأكيد حسابك بنجاح',
              btnOkText: 'استمرار',
              btnOkOnPress: () {
                // Navigator.pushReplacement...
              },
            ).show();
          },
          error: (msg) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: ColorsManager.error,
              ),
            );
          },
        );
      },
      builder: (context, state) {
        final cubit = context.read<VerifySignupCubit>();
        final isLoading = state is Loading;

        final defaultPinTheme = PinTheme(
          width: 55.w,
          height: 55.h,
          textStyle: TextStyles.font16BlackRegular,
          decoration: BoxDecoration(
            color: const Color(0xffe5e9ef),
            borderRadius: BorderRadius.circular(10.r),
          ),
        );

        final focusedPinTheme = defaultPinTheme.copyWith(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: ColorsManager.primary, width: 2),
          ),
        );

        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
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
                      'لقد أرسلنا رمز التحقق إلى بريدك الإلكتروني',
                      style: TextStyles.font14BlackRegular,
                    ),
                    SizedBox(height: 32.h),

                    Pinput(
                      controller: cubit.otpController,
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'رمز التحقق مطلوب';
                        }
                        if (value.length < 6) {
                          return 'الرمز يجب أن يكون 6 أرقام';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 32.h),

                    AppTextButton(
                      buttonText: 'تأكيد',
                      isLoading: isLoading,
                      onPressed: () {
                        cubit.emitVerifySignupStates();
                      },
                    ),

                    SizedBox(height: 16.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('لم يصلك رمز التحقق؟'),
                        InkWell(
                          onTap: () async {
                            context.read<SignupCubit>().emitSignupStates();
                            if (!context.mounted) return;
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              title: 'تم الإرسال',
                              desc: 'تم إرسال رمز جديد لبريدك',
                              btnOkOnPress: () {},
                            ).show();
                          },
                          child: Text(
                            ' إعادة الإرسال',
                            style: TextStyles.font14PrimaryBold.copyWith(
                              decoration: TextDecoration.underline,
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
