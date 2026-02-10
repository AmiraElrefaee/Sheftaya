import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/core/di/service_locator.dart';
import 'package:sheftaya/features/forget_password/logic/create_new_password_cubit/create_new_password_cubit.dart';
import 'package:sheftaya/features/forget_password/presentation/widgets/create_new_password_screen_body.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  final String resetToken;

  const CreateNewPasswordScreen({super.key, required this.resetToken});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreateNewPasswordCubit>(param1: resetToken),
      child: const CreateNewPasswordScreenBody(),
    );
  }
}
