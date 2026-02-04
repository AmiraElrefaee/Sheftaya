import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/features/sign_up/presentation/widgets/verify_account_screen_body.dart';

class VerifyAccountScreen extends StatelessWidget {
  const VerifyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return
    //  MultiBlocProvider(
    //   providers: [
    //     BlocProvider(create: (context) => getIt<VerifyAccountCubit>()),
    //     BlocProvider(create: (context) => getIt<SignupCubit>()),
    //   ],
    //   child:
    const VerifyAccountScreenBody();
    // );
  }
}
