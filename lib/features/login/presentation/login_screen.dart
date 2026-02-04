import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:sheftaya/app/router.dart';
// import 'package:sheftaya/core/constants/shared_pref_helper.dart';
// import 'package:sheftaya/core/constants/shared_pref_keys.dart';
// import 'package:sheftaya/core/constants/user_cubit.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/features/login/presentation/widgets/login_screen_body.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // _checkToken();
  }

  // Future<void> _checkToken() async {
  //   final userCubit = context.read<UserCubit>();
  //   final token = await SharedPrefHelper.getSecuredString(
  //     SharedPrefKeys.userToken,
  //   );
  //   if (token.isEmpty) {
  //     if (!mounted) return;
  //     setState(() => _isLoading = false);
  //     return;
  //   }
  //   while (userCubit.state.isLoading || userCubit.state.user == null) {
  //     await Future.delayed(const Duration(milliseconds: 200));
  //     if (!mounted) return;
  //   }

  //   if (!mounted) return;
  //   final role = userCubit.state.user!.role ?? '';

  //   if (role == "") {
  //     GoRouter.of(context).pushReplacement(AppRouter.);
  //   else {
  //     GoRouter.of(context).pushReplacement(AppRouter.);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  color: ColorsManager.primary,
                ),
              ),
              SizedBox(height: 20.h),
              Text('جاري التحميل...', style: TextStyles.font16PrimaryBold),
            ],
          ),
        ),
      );
    }

    return
    // BlocProvider(
    //   create: (context) => getIt<LoginCubit>(),
    //   child: const
    LoginScreenBody();
    //);
  }
}
