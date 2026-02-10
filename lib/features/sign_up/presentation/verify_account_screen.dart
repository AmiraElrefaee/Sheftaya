import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/core/di/service_locator.dart';
import 'package:sheftaya/features/sign_up/logic/sign_up/sign_up_cubit.dart';
import 'package:sheftaya/features/sign_up/logic/verify_sign_up/verify_signup_cubit.dart';
import 'package:sheftaya/features/sign_up/presentation/widgets/verify_account_screen_body.dart';

class VerifyAccountScreen extends StatelessWidget {
  const VerifyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<VerifySignupCubit>()),
        BlocProvider(create: (context) => getIt<SignupCubit>()),
      ],
      child: const VerifyAccountScreenBody(),
    );
  }
}
