import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/features/publish_job/presentation/widgets/job_publish_success_view_body.dart';

import 'mangers/job_details_cubit/job_details_cubit.dart';

class JobPublishSuccessScreen extends StatefulWidget {
  const JobPublishSuccessScreen({super.key, required this.jobId});
  final String jobId;

  @override
  State<JobPublishSuccessScreen> createState() => _JobPublishSuccessScreenState();
}

class _JobPublishSuccessScreenState extends State<JobPublishSuccessScreen> {
  @override
  void initState() {
    super.initState();

    context.read<JobDetailsCubit>().getJobDetails(widget.jobId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body:JobPublishSuccessViewBody() ,
    );
  }
}
