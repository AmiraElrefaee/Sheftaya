import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/utils/snackbar.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/core/widgets/default_user_image.dart';
import 'package:sheftaya/features/employer/my_jobs/data/models/job_applications_response.dart';
import 'package:sheftaya/features/employer/my_jobs/logic/job_applications_cubit.dart';
import 'package:sheftaya/features/employer/my_jobs/logic/job_applications_state.dart';

class JobApplicationsScreen extends StatefulWidget {
  final String jobId;

  const JobApplicationsScreen({super.key, required this.jobId});

  @override
  State<JobApplicationsScreen> createState() => _JobApplicationsScreenState();
}

class _JobApplicationsScreenState extends State<JobApplicationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<JobApplicationsCubit>().fetchApplicationsForJob(
        widget.jobId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JobApplicationsCubit, JobApplicationsState>(
      listener: (context, state) {
        if (state is Error) {
          customSnackBar(context, state.message, ColorsManager.error);
        }
      },
      builder: (context, state) {
        final applications = state is Success
            ? (state.data.data ?? <JobApplicationItem>[])
            : <JobApplicationItem>[];

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('طلبات العمال', style: TextStyles.font18BlackBold),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () => context.pop(),
              ),
            ),
            body: _buildBody(context, state, applications),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    JobApplicationsState state,
    List<JobApplicationItem> applications,
  ) {
    if (state is! Success) {
      return const Center(child: CircularProgressIndicator());
    }

    if (applications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 72.r,
              color: ColorsManager.lightGrey,
            ),
            SizedBox(height: 16.h),
            Text(
              'لا توجد طلبات عمال حتى الآن',
              style: TextStyles.font16BlackMedium.copyWith(
                color: ColorsManager.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Text(
            'العمال المتاحون (${applications.length})',
            style: TextStyles.font18BlackBold,
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: applications.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) => _WorkerCard(
              item: applications[index],
              onAccept: () async {
                final appId = applications[index].id;
                if (appId == null || appId.isEmpty) {
                  customSnackBar(
                    context,
                    'معرّف الطلب غير موجود',
                    ColorsManager.error,
                  );
                  return;
                }

                await context.read<JobApplicationsCubit>().acceptWorker(
                  jobId: widget.jobId,
                  applicationId: appId,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _WorkerCard extends StatelessWidget {
  final JobApplicationItem item;
  final VoidCallback onAccept;

  const _WorkerCard({required this.item, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    final worker = item.workerId;
    final profile = item.workerProfile;

    final fullName = [
      worker?.firstName ?? '',
      worker?.lastName ?? '',
    ].where((part) => part.trim().isNotEmpty).join(' ').trim();

    final name = fullName.isNotEmpty ? fullName : 'عامل';
    final imageUrl = worker?.profileImage;
    final city = worker?.city ?? 'غير محدد';
    final experience = profile?.experienceYears != null
        ? '${profile!.experienceYears} سنة'
        : 'غير محددة';
    final createdAt = _formatDate(item.createdAt);
    final status = item.status ?? 'غير معروف';
    final arrivalStatus = item.arrivalStatus ?? 'غير محدد';

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorsManager.lightGrey, width: 1.w),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 56.w,
                    height: 56.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return DefaultUserImg(
                        containerWidth: 56,
                        containerHeight: 56,
                      );
                    },
                  )
                : DefaultUserImg(containerWidth: 56, containerHeight: 56),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyles.font16BlackBold),
                SizedBox(height: 4.h),
                Text(
                  city,
                  style: TextStyles.font12BlackMedium.copyWith(
                    color: ColorsManager.grey,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'الخبرة: $experience',
                  style: TextStyles.font12BlackMedium.copyWith(
                    color: ColorsManager.grey,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'الحالة: $status',
                  style: TextStyles.font12BlackMedium.copyWith(
                    color: ColorsManager.grey,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'وصول: $arrivalStatus',
                  style: TextStyles.font12BlackMedium.copyWith(
                    color: ColorsManager.grey,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'تاريخ التقديم: $createdAt',
                  style: TextStyles.font12BlackMedium.copyWith(
                    color: ColorsManager.grey,
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  child: AppTextButton(
                    buttonText: 'قبول الطلب',
                    onPressed: onAccept,
                    backgroundColor: ColorsManager.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return 'غير محدد';
    final dt = DateTime.tryParse(value)?.toLocal();
    if (dt == null) return 'غير محدد';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
