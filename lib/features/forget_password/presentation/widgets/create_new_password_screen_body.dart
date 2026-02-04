import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:go_router/go_router.dart';
import 'package:sheftaya/core/constants/app_regex.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/core/widgets/custom_text_form_field.dart';

class CreateNewPasswordScreenBody extends StatefulWidget {
  const CreateNewPasswordScreenBody({super.key});

  @override
  State<CreateNewPasswordScreenBody> createState() =>
      _CreateNewPasswordScreenBodyState();
}

class _CreateNewPasswordScreenBodyState
    extends State<CreateNewPasswordScreenBody> {
  bool isPasswordObscureText = true;
  bool isConfirmPasswordObscureText = true;

  @override
  Widget build(BuildContext context) {
    // return BlocConsumer<CreateNewPasswordCubit, CreatePasswordState>(
    //   listener: (context, state) {
    //     state.maybeWhen(
    //       createNewPasswordsuccess: (message) {
    //         customSnackBar(context, message, ColorsManager.success);
    //         context.go(AppRouter.kLoginScreen);
    //       },
    //       createNewPassworderrorerror: (error) {
    //         customSnackBar(context, error, ColorsManager.error);
    //       },
    //       orElse: () {},
    //     );
    //   },
    //   builder: (context, state) {
    //     final cubit = context.read<CreateNewPasswordCubit>();
    //     final isLoading = state.maybeWhen(
    //       createNewPasswordloading: () => true,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إنشاء كلمة مرور جديدة',
                      style: TextStyles.font24BlackBold.copyWith(
                        fontSize: 44.sp,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Text('كلمه المرور', style: TextStyles.font14BlackRegular),
                    SizedBox(height: 8.h),
                    AppTextFormField(
                      //controller: cubit.newPasswordController,
                      hintText: 'ادخل كلمه مرورك',
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
                          isPasswordObscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'تاكيد كلمه المرور',
                      style: TextStyles.font14BlackRegular,
                    ),
                    SizedBox(height: 8.h),
                    AppTextFormField(
                     // controller: cubit.passwordConfirmController,
                      hintText: 'ادخل كلمه مرورك',
                      obscureText: isConfirmPasswordObscureText,
                      // validator:
                      //     (value) => AppRegex.validateConfirmPassword(
                      //       value,
                      //       cubit.newPasswordController.text,
                      //     ),
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
                    SizedBox(height: 32.h),
                    AppTextButton(
                      buttonText: 'تأكيد',
                      onPressed: () {
                        // if (cubit.formKey.currentState!.validate()) {
                        //   cubit.emitCreateNewPasswordStates();
                        // }
                      },
                     // isLoading: isLoading,
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
