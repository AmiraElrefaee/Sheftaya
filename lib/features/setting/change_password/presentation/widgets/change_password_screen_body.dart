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
import 'package:sheftaya/features/setting/change_password/logic/change_password_cubit.dart';
import 'package:sheftaya/features/setting/change_password/logic/change_password_state.dart';

class ChangePasswordScreenBody extends StatefulWidget {
  const ChangePasswordScreenBody({super.key});

  @override
  State<ChangePasswordScreenBody> createState() =>
      _ChangePasswordScreenBodyState();
}

class _ChangePasswordScreenBodyState extends State<ChangePasswordScreenBody> {
  final _formKey = GlobalKey<FormState>();

  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _isOldPassObscure = true;
  bool _isNewPassObscure = true;
  bool _isConfirmPassObscure = true;

  @override
  void dispose() {
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<ChangePasswordCubit>().changePassword(
      currentPassword: _oldPassCtrl.text.trim(),
      newPassword: _newPassCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (_) {
            customSnackBar(
              context,
              'تم تغيير كلمة المرور بنجاح',
              ColorsManager.success,
            );
            GoRouter.of(context).pop();
          },
          error: (err) => customSnackBar(context, err, ColorsManager.error),
        );
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تغيير كلمة المرور',
                    style: TextStyles.font24BlackBold.copyWith(fontSize: 40.sp),
                  ),
                  SizedBox(height: 32.h),

                  // ── Current password ──
                  Text(
                    'كلمة المرور الحالية',
                    style: TextStyles.font14BlackRegular,
                  ),
                  SizedBox(height: 8.h),
                  AppTextFormField(
                    controller: _oldPassCtrl,
                    hintText: 'ادخل كلمة المرور الحالية',
                    obscureText: _isOldPassObscure,
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'كلمة المرور الحالية مطلوبة'
                        : null,
                    suffixIcon: GestureDetector(
                      onTap: () => setState(
                        () => _isOldPassObscure = !_isOldPassObscure,
                      ),
                      child: Icon(
                        _isOldPassObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // ── New password ──
                  Text(
                    'كلمة المرور الجديدة',
                    style: TextStyles.font14BlackRegular,
                  ),
                  SizedBox(height: 8.h),
                  AppTextFormField(
                    controller: _newPassCtrl,
                    hintText: 'ادخل كلمة المرور الجديدة',
                    obscureText: _isNewPassObscure,
                    validator: AppRegex.validatePassword,
                    suffixIcon: GestureDetector(
                      onTap: () => setState(
                        () => _isNewPassObscure = !_isNewPassObscure,
                      ),
                      child: Icon(
                        _isNewPassObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // ── Confirm password ──
                  Text(
                    'تأكيد كلمة المرور الجديدة',
                    style: TextStyles.font14BlackRegular,
                  ),
                  SizedBox(height: 8.h),
                  AppTextFormField(
                    controller: _confirmPassCtrl,
                    hintText: 'تأكيد كلمة المرور الجديدة',
                    obscureText: _isConfirmPassObscure,
                    validator: (v) =>
                        AppRegex.validateConfirmPassword(v, _newPassCtrl.text),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(
                        () => _isConfirmPassObscure = !_isConfirmPassObscure,
                      ),
                      child: Icon(
                        _isConfirmPassObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // ── Submit button ──
                  BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                    builder: (context, state) {
                      final isLoading = state.maybeWhen(
                        loading: () => true,
                        orElse: () => false,
                      );
                      return AppTextButton(
                        buttonText: 'تغيير كلمة المرور',
                        isLoading: isLoading,
                        onPressed: () => _submit(context),
                      );
                    },
                  ),
                  SizedBox(height: 16.h),

                  // ── Forgot password ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'نسيت كلمة المرور?',
                        style: TextStyles.font14BlackRegular.copyWith(
                          color: ColorsManager.grey,
                        ),
                      ),
                      InkWell(
                        onTap: () => GoRouter.of(
                          context,
                        ).push(AppRouter.kForgetPassScreen),
                        child: Text(
                          'استعادة كلمة المرور',
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
      ),
    );
  }
}
