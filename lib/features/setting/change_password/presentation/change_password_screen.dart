import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/core/di/service_locator.dart';
import 'package:sheftaya/features/setting/change_password/logic/change_password_cubit.dart';
import 'package:sheftaya/features/setting/change_password/presentation/widgets/change_password_screen_body.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<ChangePasswordCubit>(),
        child: ChangePasswordScreenBody(),
      ),
    );
  }
}
