import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/core/di/service_locator.dart';
import 'package:sheftaya/features/setting/my_profile/logic/update_image_profile_cubit.dart';
import 'package:sheftaya/features/setting/my_profile/logic/update_profile_cubit.dart';
import 'widgets/profile_screen_body.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<UpdateImageProfileCubit>()),
        BlocProvider(create: (_) => getIt<UpdateProfileCubit>()),
      ],
      child: const ProfileScreenBody(),
    );
  }
}