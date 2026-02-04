import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';

class VerifyAccountScreenBody extends StatelessWidget {
  const VerifyAccountScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    // return BlocConsumer<VerifyAccountCubit, VerifyAccountState>(
    //   listener: (context, state) {
    //     state.maybeWhen(
    //       success: (data) async {
    //         final signupCubit = context.read<SignupCubit>();
    //         final userCubit = context.read<UserCubit>();
    //         final router = GoRouter.of(context);
    //         final scaffoldMessenger = ScaffoldMessenger.of(context);
    //         if (data != null && data.data != null) {
    //           final user = UserModel(
    //             id: data.data!.id ?? '',
    //             firstname: data.data!.firstName ?? '',
    //             lastname: data.data!.lastName ?? '',
    //             email: data.data!.email ?? '',
    //             role: data.data!.role,
    //             phone: data.data!.phone,
    //             token: data.token,
    //             profileImg: data.data!.profileImg,
    //             gender: data.data!.gender,
    //             birthday: data.data!.birthday,
    //             createFeedback: data.data!.createReport ?? false,
    //           );

    //           userCubit.setUser(user);
    //         }

    //         String? role = signupCubit.selectedRole;

    //         if (role == null || role.trim().isEmpty) {
    //           role = await SharedPrefHelper.getSecuredString(
    //             SharedPrefKeys.userRole,
    //           );
    //         }

    //         if (!context.mounted) return;
    //         role = role.trim();
    //         debugPrint('VerifyAccount: resolved role => "$role"');

    //         if (role == '') {
    //           router.go(AppRouter.kVolunteerHomeScreen);
    //           return;
    //         }
    //         if (role == '') {
    //           router.go(AppRouter.kBlindScreen);
    //           return;
    //         }
           

      //       scaffoldMessenger.showSnackBar(
      //         SnackBar(
      //           content: const Text('حدث خطأ في تحديد نوع المستخدم'),
      //           backgroundColor: ColorsManager.error,
      //         ),
      //       );
      //     },
      //     error: (error) {
      //       customSnackBar(context, error, ColorsManager.error);
      //     },
      //     orElse: () {},
      //   );
      // },
      // builder: (context, state) {
      //   final cubit = context.read<VerifyAccountCubit>();
      //   final isLoading = state.maybeWhen(
      //     loading: () => true,
      //     orElse: () => false,
      //   );

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
               // key: cubit.formKey,
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
                      //controller: cubit.otpController,
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
                        // if (cubit.formKey.currentState!.validate()) {
                        //   cubit.emitVerifyAccountStates();
                        // }
                      },
                     // isLoading: isLoading,
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
                            //context.read<SignupCubit>().emitSignupStates();
                            if (context.mounted) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.noHeader,
                                animType: AnimType.bottomSlide,
                                title: 'تم إرسال الرمز',
                                titleTextStyle: TextStyles.font16BlackBold
                                    .copyWith(fontSize: 20.sp),
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
      }
   // );
  }
//}
