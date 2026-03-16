import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/features/publish_job/presentation/widgets/success_mesaage_section.dart';

import '../../../../core/widgets/custom_loading_indicator.dart';
import '../mangers/job_details_cubit/job_details_cubit.dart';
import 'action_button_section.dart';
import 'custom_app_bar.dart';
import 'custom_job_card.dart';

class JobPublishSuccessViewBody extends StatelessWidget {
  const JobPublishSuccessViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            CustomAppBar(
              title: 'تأكيد النشر',
              onTap: (){},
            ),
            verticalSpace(20),
            BlocBuilder<JobDetailsCubit, JobDetailsState>(
              builder: (context, state) {
                if (state is JobDetailsSuccess) {
                  return JobSummaryCard(job: state.job); // نمرر الـ job المستلم من الكيوبت
                } else if (state is JobDetailsError) {
                  return Text(state.message);
                }
                return const CustomLoadingIndicator();
              },
            ), // الجزء الخاص بالكارت العلوي
            verticalSpace(40),
            const SuccessMessageSection(), // الجزء الخاص بعلامة الصح والنص
            // const Spacer(),
           const SizedBox(height: 20,),
            const ActionButtonsSection(), // الجزء الخاص بالأزرار السفلية
            verticalSpace(20) // الأزرار
          ],
        ),
      ),
    );
  }
  Widget verticalSpace(double height) => SizedBox(height: height.h);
}
