import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/features/publish_job/presentation/widgets/publish_job_view_body.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/theme/colors_manager.dart';
import '../../../core/theme/text_styles.dart';
import 'mangers/job_publish_cubit/job_publish_cubit.dart';

class PublishJobView extends StatelessWidget {
  const PublishJobView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      

      backgroundColor: ColorsManager.background,

      body: BlocProvider(
        create: (context) => getIt<JobPublishCubit>(),
        child: const PublishJobViewBody(),
      ),
    );
  }
}
