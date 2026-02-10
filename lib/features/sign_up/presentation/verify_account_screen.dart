import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/core/di/service_locator.dart';
import 'package:sheftaya/features/sign_up/logic/sign_up/sign_up_cubit.dart';
import 'package:sheftaya/features/sign_up/logic/verify_sign_up/verify_signup_cubit.dart';
import 'package:sheftaya/features/sign_up/presentation/widgets/verify_account_screen_body.dart';

class VerifyAccountScreen extends StatelessWidget {
  final String role;

  const VerifyAccountScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<VerifySignupCubit>()),
        BlocProvider(create: (_) => getIt<SignupCubit>()),
      ],
      child: VerifyAccountScreenBody(role: role),
    );
  }
}

