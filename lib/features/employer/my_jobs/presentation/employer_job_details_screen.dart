import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/di/service_locator.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/features/employer/my_jobs/logic/job_applications_cubit.dart';
import 'package:sheftaya/features/employer/my_jobs/logic/job_applications_state.dart';
import 'package:sheftaya/features/worker/my_application_jobs/data/models/my_jobs_response.dart';

class EmployerJobDetailsScreen extends StatelessWidget {
  final MyJobItem jobItem;

  const EmployerJobDetailsScreen({super.key, required this.jobItem});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<JobApplicationsCubit>(
      create: (_) =>
          getIt<JobApplicationsCubit>()
            ..fetchApplicationsForJob(jobItem.job?.id ?? ''),
      child: _EmployerJobDetailsBody(jobItem: jobItem),
    );
  }
}

class _EmployerJobDetailsBody extends StatelessWidget {
  final MyJobItem jobItem;

  const _EmployerJobDetailsBody({required this.jobItem});

  @override
  Widget build(BuildContext context) {
    final job = jobItem.job;

    final startDT = job?.startDateTime != null
        ? DateTime.tryParse(job!.startDateTime!)?.toLocal()
        : null;

    final endDT = startDT != null && job?.dailyWorkHours != null
        ? startDT.add(Duration(hours: job!.dailyWorkHours!))
        : null;

    final formattedDate = startDT != null
        ? '${startDT.day} ${_arabicMonth(startDT.month)}'
        : '';

    final formattedStart = startDT != null ? _formatTime(startDT) : '';
    final formattedEnd = endDT != null ? _formatTime(endDT) : '';

    final imageUrl = job?.jobImages?.isNotEmpty == true
        ? job!.jobImages!.first
        : null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: Text('تفاصيل الوظيفة', style: TextStyles.font18BlackBold),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: imageUrl != null
                              ? Image.network(
                                  imageUrl,
                                  width: 100.w,
                                  height: 100.w,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 100.w,
                                  height: 100.w,
                                  decoration: BoxDecoration(
                                    color: ColorsManager.lightGrey,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: const Icon(
                                    Icons.business,
                                    color: ColorsManager.grey,
                                  ),
                                ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job?.title ?? jobItem.title ?? '',
                                style: TextStyles.font24BlackBold.copyWith(
                                  fontSize: 22.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                job?.place ??
                                    job?.companyDetails?.companyName ??
                                    '',
                                style: TextStyles.font14BlackMedium.copyWith(
                                  color: ColorsManager.darkGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: _infoChip(
                            icon: Icons.calendar_today_rounded,
                            label: formattedDate,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: _infoChip(
                            icon: Icons.access_time_rounded,
                            label: '${job?.dailyWorkHours ?? 0} ساعات',
                            subtitle: 'من $formattedStart إلى $formattedEnd',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: _infoChip(
                            icon: Icons.attach_money_sharp,
                            label:
                                '${job?.pricePerHour?.amount?.toStringAsFixed(0) ?? '0'} جنيه',
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: _infoChip(
                            icon: Icons.people_outline,
                            label: '${job?.requiredWorkers ?? 0} عمال مطلوبين',
                          ),
                        ),
                      ],
                    ),
                    if (job?.location?.address != null) ...[
                      SizedBox(height: 10.h),
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: ColorsManager.lightGrey.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 20.sp,
                              color: ColorsManager.primary,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                job!.location!.address!,
                                style: TextStyles.font14BlackMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              if (job?.details != null) ...[
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('وصف الوظيفة', style: TextStyles.font18BlackBold),
                      SizedBox(height: 8.h),
                      Text(
                        job!.details!,
                        style: TextStyles.font14BlackMedium.copyWith(
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
              ],
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(16.w),
                child: BlocBuilder<JobApplicationsCubit, JobApplicationsState>(
                  builder: (context, state) {
                    final applications = state is Success
                        ? (state.data.data ?? <dynamic>[])
                        : <dynamic>[];

                    final count = applications.length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'طلبات العمال ($count)',
                              style: TextStyles.font18BlackBold,
                            ),
                            if (state is! Success)
                              SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                          ],
                        ),
                        if (state is Success && count == 0) ...[
                          SizedBox(height: 16.h),
                          Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 48.r,
                                  color: ColorsManager.lightGrey,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'لا توجد طلبات عمال حتى الآن',
                                  style: TextStyles.font14BlackMedium.copyWith(
                                    color: ColorsManager.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],
                        if (state is Success && count > 0) ...[
                          SizedBox(height: 12.h),
                          Text(
                            'يوجد $count طلب - اضغط على الزر لعرض الطلبات',
                            style: TextStyles.font12BlackMedium.copyWith(
                              color: ColorsManager.grey,
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 80.h),
            ],
          ),
        ),
        bottomNavigationBar:
            BlocBuilder<JobApplicationsCubit, JobApplicationsState>(
              builder: (context, state) {
                final canOpen =
                    state is Success && (state.data.data?.isNotEmpty ?? false);

                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: ColorsManager.lightGrey,
                        width: 1.5.w,
                      ),
                    ),
                  ),
                  child: AppTextButton(
                    buttonText: 'عرض طلبات العمال',
                    onPressed: canOpen
                        ? () {
                            context.push(AppRouter.kJobApplicationsScreen);
                          }
                        : () {},
                    backgroundColor: canOpen
                        ? ColorsManager.primary
                        : ColorsManager.lightGrey,
                  ),
                );
              },
            ),
      ),
    );
  }

  Widget _infoChip({
    required IconData icon,
    required String label,
    String? subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorsManager.lightGrey.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18.sp, color: ColorsManager.primary),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  label,
                  style: TextStyles.font14BlackMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            SizedBox(height: 2.h),
            Text(
              subtitle,
              style: TextStyles.font12BlackMedium.copyWith(
                color: ColorsManager.grey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  String _arabicMonth(int month) {
    const months = [
      '',
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return months[month];
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour;
    final min = dt.minute.toString().padLeft(2, '0');
    final isAm = hour < 12;
    final h12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$h12:$min ${isAm ? 'ص' : 'م'}';
  }
}
