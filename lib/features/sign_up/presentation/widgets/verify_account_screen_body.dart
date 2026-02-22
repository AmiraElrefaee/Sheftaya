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
import 'package:sheftaya/features/sign_up/logic/verify_sign_up/verify_signup_cubit.dart';
import 'package:sheftaya/features/sign_up/logic/verify_sign_up/verify_signup_state.dart';

class VerifyAccountScreenBody extends StatelessWidget {
  final String role;
  const VerifyAccountScreenBody({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<VerifySignupCubit, VerifySignupState>(
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
                    if (role == 'employer') {
                      context.go(AppRouter.kEmployerHomeScreen);
                    } else {
                      context.go(AppRouter.kWorkerHomeScreen);
                    }
                  },
                ).show();
              },
              error: (msg) {
                customSnackBar(context, msg, ColorsManager.error);
              },
            );
          },
        ),
      ],
      child: BlocBuilder<VerifySignupCubit, VerifySignupState>(
        builder: (context, verifyState) {
          final verifyCubit = context.read<VerifySignupCubit>();
          final isLoading = verifyState is Loading;

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
                  key: verifyCubit.formKey,
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
                        controller: verifyCubit.otpController,
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
                          if (!isLoading) {
                            verifyCubit.emitVerifySignupStates();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
