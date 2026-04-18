import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/di/service_locator.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/utils/snackbar.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/core/widgets/default_user_image.dart';
import 'package:sheftaya/features/employer/my_jobs/data/models/job_applications_response.dart';
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

class _EmployerJobDetailsBody extends StatefulWidget {
  final MyJobItem jobItem;

  const _EmployerJobDetailsBody({required this.jobItem});

  @override
  State<_EmployerJobDetailsBody> createState() =>
      _EmployerJobDetailsBodyState();
}

class _EmployerJobDetailsBodyState extends State<_EmployerJobDetailsBody> {
  final Set<String> _selectedIds = {};
  bool _isAccepting = false;
  int _acceptedWorkersOffset = 0;

  JobDetails? get _job => widget.jobItem.job;

  int get _requiredWorkers => _job?.requiredWorkers ?? 0;

  int get _baseAcceptedCount => _job?.acceptedWorkersCount ?? 0;

  int get _displayAcceptedCount => _baseAcceptedCount + _acceptedWorkersOffset;

  int get _remainingSlots {
    final remaining = _requiredWorkers - _displayAcceptedCount;
    return remaining.clamp(0, _requiredWorkers).toInt();
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

  bool _isAcceptedStatus(String? status) {
    return (status ?? '').toLowerCase() == 'accepted';
  }

  List<JobApplicationItem> _visibleApplications(
    List<JobApplicationItem> applications,
  ) {
    return applications
        .where((item) => !_isAcceptedStatus(item.status))
        .toList();
  }

  void _toggleSelection(String id) {
    if (_isAccepting || id.isEmpty || _remainingSlots <= 0) return;

    if (_selectedIds.contains(id)) {
      setState(() => _selectedIds.remove(id));
      return;
    }

    if (_selectedIds.length < _remainingSlots) {
      setState(() => _selectedIds.add(id));
    }
  }

  Future<void> _acceptSelected() async {
    if (_selectedIds.isEmpty || _isAccepting) return;

    final jobId = _job?.id ?? '';
    if (jobId.isEmpty) return;

    setState(() => _isAccepting = true);

    final cubit = context.read<JobApplicationsCubit>();

    try {
      final selectedIds = _selectedIds.toList();
      for (final applicationId in selectedIds) {
        await cubit.acceptWorker(jobId: jobId, applicationId: applicationId);
      }

      await cubit.fetchApplicationsForJob(jobId);

      if (!mounted) return;

      setState(() {
        _acceptedWorkersOffset += selectedIds.length;
        _selectedIds.clear();
      });

      customSnackBar(context, 'تم قبول العمالة بنجاح', ColorsManager.success);
    } catch (_) {
      if (!mounted) return;

      customSnackBar(
        context,
        'حدث خطاء اثناء قبول العمالة',
        ColorsManager.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isAccepting = false);
      }
    }
  }

  void _confirmAcceptWorkers() {
    if (_selectedIds.isEmpty) return;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      title: 'تأكيد القبول',
      desc: 'هل انت متأكد انك تريد قبول ${_selectedIds.length} عامل؟',
      btnCancelText: 'إلغاء',
      btnOkText: 'تأكيد',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await _acceptSelected();
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final job = _job;

    final startDT = job?.startDateTime != null
        ? DateTime.tryParse(job!.startDateTime!)?.toLocal()
        : null;

    final endDT = startDT != null && job?.dailyWorkHours != null
        ? startDT.add(Duration(hours: job!.dailyWorkHours!))
        : null;

    final formattedDate = startDT != null
        ? '${startDT.day} ${_arabicMonth(startDT.month)}'
        : '—';
    final formattedStart = startDT != null ? _formatTime(startDT) : '—';
    final formattedEnd = endDT != null ? _formatTime(endDT) : '—';

    final imageUrl = job?.jobImages?.isNotEmpty == true
        ? job!.jobImages!.first
        : null;
    final companyName =
        widget.jobItem.place ?? job?.companyDetails?.companyName ?? '—';
    final locationText =
        job?.location?.address ?? job?.place ?? 'الموقع غير محدد';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: Text('تفاصيل الوظيفة', style: TextStyles.font18BlackBold),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => context.pop(),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.r),
                        bottomRight: Radius.circular(20.r),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: ColorsManager.lightGrey,
                          width: 1.2.w,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: imageUrl != null && imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      width: 96.w,
                                      height: 96.w,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => _placeholder(),
                                    )
                                  : _placeholder(),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 2.h),
                                  Text(
                                    job?.title ?? widget.jobItem.title ?? '',
                                    style: TextStyles.font24BlackBold.copyWith(
                                      fontSize: 30.sp,
                                      height: 1,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    companyName,
                                    style: TextStyles.font20BlackSemiBold
                                        .copyWith(
                                          color: ColorsManager.darkGrey,
                                          height: 1.1,
                                        ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _remainingSlots == 0
                                          ? ColorsManager.success.withValues(
                                              alpha: 0.10,
                                            )
                                          : ColorsManager.primary.withValues(
                                              alpha: 0.10,
                                            ),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.people_outline,
                                          size: 14.sp,
                                          color: _remainingSlots == 0
                                              ? ColorsManager.success
                                              : ColorsManager.primary,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          '$_displayAcceptedCount مقبول / $_remainingSlots متبقي',
                                          style: TextStyles.font12BlackMedium
                                              .copyWith(
                                                color: _remainingSlots == 0
                                                    ? ColorsManager.success
                                                    : ColorsManager.primary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Row(
                          children: [
                            Expanded(
                              child: _InfoChip(
                                icon: Icons.calendar_today_rounded,
                                label: formattedDate,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: _InfoChip(
                                icon: Icons.access_time_rounded,
                                label: '${job?.dailyWorkHours ?? 0} ساعات',
                                subtitle:
                                    'من $formattedStart إلى $formattedEnd',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Expanded(
                              child: _InfoChip(
                                icon: Icons.attach_money_sharp,
                                label:
                                    '${job?.pricePerHour?.amount?.toStringAsFixed(0) ?? '0'} ج/ساعة',
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: _InfoChip(
                                icon: Icons.work_outline_rounded,
                                label: '$_requiredWorkers عمال مطلوبين',
                              ),
                            ),
                          ],
                        ),
                        if (job?.location?.address != null) ...[
                          SizedBox(height: 10.h),
                          _LocationBox(locationText: locationText),
                        ],
                      ],
                    ),
                  ),
                  if (job?.details != null &&
                      job!.details!.trim().isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'وصف الوظيفة',
                            style: TextStyles.font18BlackBold,
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: ColorsManager.lightGrey,
                              ),
                            ),
                            child: Text(
                              job.details!,
                              style: TextStyles.font14BlackMedium.copyWith(
                                height: 1.7,
                                color: ColorsManager.darkGrey,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child:
                        BlocBuilder<JobApplicationsCubit, JobApplicationsState>(
                          builder: (context, state) {
                            return state.when(
                              initial: () => _applicationsSection(
                                applications: const [],
                                isLoading: true,
                              ),
                              loading: () => _applicationsSection(
                                applications: const [],
                                isLoading: true,
                              ),
                              loadingMore: (previous, nextPage) {
                                final apps = _visibleApplications(
                                  previous.data ?? <JobApplicationItem>[],
                                );
                                return _applicationsSection(
                                  applications: apps,
                                  showLoadingMore: true,
                                );
                              },
                              accepting: (previous) {
                                final apps = _visibleApplications(
                                  previous.data ?? <JobApplicationItem>[],
                                );
                                return _applicationsSection(applications: apps);
                              },
                              success:
                                  (data, page, limit, status, hasNextPage) {
                                    final apps = _visibleApplications(
                                      data.data ?? <JobApplicationItem>[],
                                    );
                                    return _applicationsSection(
                                      applications: apps,
                                    );
                                  },
                              error: (message) {
                                return _applicationsSection(
                                  applications: const [],
                                  errorMessage: message,
                                );
                              },
                            );
                          },
                        ),
                  ),
                  SizedBox(height: 110.h),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: ColorsManager.lightGrey, width: 1.2.w),
            ),
          ),
          child: AppTextButton(
            buttonText: _selectedIds.isEmpty
                ? (_remainingSlots > 0 ? 'اختيار العمالة' : 'تم اكتمال العمال')
                : 'قبول ${_selectedIds.length} عمال',
            isLoading: _isAccepting,
            onPressed: () {
              if (_selectedIds.isNotEmpty && !_isAccepting) {
                _confirmAcceptWorkers();
              }
            },
            backgroundColor: _selectedIds.isNotEmpty && !_isAccepting
                ? ColorsManager.primary
                : ColorsManager.lightGrey,
          ),
        ),
      ),
    );
  }

  Widget _applicationsSection({
    required List<JobApplicationItem> applications,
    bool isLoading = false,
    bool showLoadingMore = false,
    String? errorMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'طلبات العمال (${applications.length})',
              style: TextStyles.font18BlackBold,
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                final jobId = _job?.id ?? '';
                if (jobId.isEmpty) return;

                context.push(AppRouter.kJobApplicationsScreen, extra: jobId);
              },
              child: Text('عرض الكل', style: TextStyles.font14SecondaryBold),
            ),
          ],
        ),
        if (isLoading)
          _loadingCard()
        else if (errorMessage != null)
          _errorCard(errorMessage)
        else if (applications.isEmpty)
          _emptyApplicationsCard()
        else
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: ColorsManager.lightGrey),
            ),
            child: Column(
              children: [
                ...applications
                    .take(3)
                    .map(
                      (app) => _ApplicationCard(
                        item: app,
                        isSelected: _selectedIds.contains(app.id ?? ''),
                        canSelect: _remainingSlots > 0,
                        onToggle: () => _toggleSelection(app.id ?? ''),
                      ),
                    ),
                if (showLoadingMore) ...[
                  SizedBox(height: 12.h),
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _loadingCard() {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorsManager.lightGrey),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _emptyApplicationsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorsManager.lightGrey),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 18.h),
          child: Column(
            children: [
              Icon(
                Icons.people_outline,
                size: 48.r,
                color: ColorsManager.lightGrey,
              ),
              SizedBox(height: 10.h),
              Text(
                'لا توجد طلبات عمال حتى الآن',
                style: TextStyles.font14BlackMedium.copyWith(
                  color: ColorsManager.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorCard(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorsManager.lightGrey),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 44.r, color: Colors.redAccent),
          SizedBox(height: 10.h),
          Text(
            'حدث خطأ أثناء تحميل الطلبات',
            style: TextStyles.font14BlackBold,
          ),
          SizedBox(height: 6.h),
          Text(
            message,
            style: TextStyles.font12BlackMedium.copyWith(
              color: ColorsManager.grey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: 160.w,
            child: AppTextButton(
              buttonText: 'إعادة المحاولة',
              buttonHeight: 40,
              onPressed: () {
                context.read<JobApplicationsCubit>().fetchApplicationsForJob(
                  _job?.id ?? '',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 96.w,
      height: 96.w,
      decoration: BoxDecoration(
        color: ColorsManager.lightGrey.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(Icons.business, size: 42.sp, color: ColorsManager.grey),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;

  const _InfoChip({required this.icon, required this.label, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorsManager.lightGrey.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20.sp, color: ColorsManager.primary),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.right,
                  style: TextStyles.font16BlackMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            SizedBox(height: 2.h),
            Text(
              subtitle!,
              textAlign: TextAlign.right,
              style: TextStyles.font12BlackMedium.copyWith(
                color: ColorsManager.darkGrey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _LocationBox extends StatelessWidget {
  final String locationText;

  const _LocationBox({required this.locationText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorsManager.lightGrey.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              width: 52.w,
              height: 42.h,
              child: CustomPaint(painter: _MapPainter()),
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            Icons.location_on_rounded,
            size: 22.sp,
            color: ColorsManager.primary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              locationText,
              textAlign: TextAlign.right,
              style: TextStyles.font16BlackMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final JobApplicationItem item;
  final bool isSelected;
  final bool canSelect;
  final VoidCallback onToggle;

  const _ApplicationCard({
    required this.item,
    required this.isSelected,
    required this.canSelect,
    required this.onToggle,
  });

  double _extractRating(dynamic worker, dynamic profile) {
    try {
      final value =
          worker?.ratingAverage ??
          worker?.rating ??
          profile?.ratingAverage ??
          profile?.rating ??
          0.0;

      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
    } catch (_) {}
    return 0.0;
  }

  int _extractRatingCount(dynamic worker, dynamic profile) {
    try {
      final value = worker?.ratingCount ?? profile?.ratingCount ?? 0;

      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
    } catch (_) {}
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final worker = item.workerId;
    final profile = item.workerProfile;

    final fullName = [
      worker?.firstName ?? '',
      worker?.lastName ?? '',
    ].where((s) => s.trim().isNotEmpty).join(' ').trim();

    final name = fullName.isNotEmpty ? fullName : 'عامل';
    final rating = _extractRating(worker, profile);
    final ratingCount = _extractRatingCount(worker, profile);
    final imageUrl = worker?.profileImage;

    return GestureDetector(
      onTap: canSelect ? onToggle : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorsManager.primary.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? ColorsManager.primary : ColorsManager.lightGrey,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? ColorsManager.primary
                      : ColorsManager.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
                color: isSelected ? ColorsManager.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 12.w),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => DefaultUserImg(
                        containerWidth: 56,
                        containerHeight: 56,
                      ),
                    )
                  : DefaultUserImg(containerWidth: 56, containerHeight: 56),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyles.font16BlackBold),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 16.sp,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        rating.toStringAsFixed(1),
                        style: TextStyles.font12BlackMedium.copyWith(
                          color: ColorsManager.darkGrey,
                        ),
                      ),
                      if (ratingCount > 0) ...[
                        SizedBox(width: 4.w),
                        Text(
                          '($ratingCount من التقييمات)',
                          style: TextStyles.font12BlackMedium.copyWith(
                            color: ColorsManager.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFDDEEFF),
    );
    final road = Paint()
      ..color = const Color(0xFFB8D4EE)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.4),
      road,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width, size.height * 0.7),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.35, 0),
      Offset(size.width * 0.35, size.height),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.72, 0),
      Offset(size.width * 0.72, size.height),
      road,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      4,
      Paint()..color = const Color(0xFF2196F3),
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      4,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
