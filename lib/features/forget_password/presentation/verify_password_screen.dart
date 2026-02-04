import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/features/forget_password/presentation/widgets/verify_password_screen_body.dart';

class VerifyPasswordScreen extends StatelessWidget {
  const VerifyPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return
    //  MultiBlocProvider(
    //   providers: [
    //     BlocProvider(create: (context) => getIt<VerifyPasswordCubit>()),
    //     BlocProvider(create: (context) => getIt<ForgetPasswordCubit>()),
    //   ],
    //   child:
    const VerifyPasswordScreenBody();
    //);
  }
}
