import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/core/di/service_locator.dart';
import 'package:sheftaya/features/forget_password/logic/verify_password_cubit/verify_password_cubit.dart';
import 'package:sheftaya/features/forget_password/presentation/widgets/verify_password_screen_body.dart';

class VerifyPasswordScreen extends StatelessWidget {
  final String email;

  const VerifyPasswordScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VerifyPasswordCubit>(param1: email),
      child: const VerifyPasswordScreenBody(),
    );
  }
}
