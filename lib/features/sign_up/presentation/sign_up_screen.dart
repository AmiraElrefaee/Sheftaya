import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/features/sign_up/presentation/widgets/sign_up_screen_body.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return
    //  BlocProvider(
    //   create: (context) => getIt<SignupCubit>()..loadSavedUserData(),
    //   child: 
      const Scaffold(body: SignUpScreenBody());
    //);
  }
}
