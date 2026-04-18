import 'package:awesome_dialog/awesome_dialog.dart';
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
  final Set<String> _selectedIds = {};
  bool _isConfirming = false;

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

  bool _isAcceptedStatus(String? status) {
    return (status ?? '').toLowerCase() == 'accepted';
  }

  List<JobApplicationItem> _pendingApplications(
    List<JobApplicationItem> applications,
  ) {
    return applications
        .where((item) => !_isAcceptedStatus(item.status))
        .toList();
  }

  void _toggleSelection(String id) {
    if (_isConfirming || id.isEmpty) return;

    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _confirmSelection() async {
    if (_selectedIds.isEmpty || _isConfirming) return;

    setState(() => _isConfirming = true);

    final cubit = context.read<JobApplicationsCubit>();

    try {
      final selectedIds = _selectedIds.toList();

      for (final applicationId in selectedIds) {
        await cubit.acceptWorker(
          jobId: widget.jobId,
          applicationId: applicationId,
        );
      }

      await cubit.fetchApplicationsForJob(widget.jobId);

      if (!mounted) return;

      setState(() => _selectedIds.clear());

      customSnackBar(
        context,
        'تم تأكيد اختيار العمالة بنجاح',
        ColorsManager.success,
      );
    } catch (_) {
      if (!mounted) return;
      customSnackBar(
        context,
        'حدث خطأ أثناء تأكيد الاختيار',
        ColorsManager.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isConfirming = false);
      }
    }
  }

  void _showConfirmDialog() {
    if (_selectedIds.isEmpty) return;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      title: 'تأكيد الاختيار',
      desc: 'هل تريد تأكيد اختيار ${_selectedIds.length} عامل؟',
      btnCancelText: 'إلغاء',
      btnOkText: 'تأكيد',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await _confirmSelection();
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JobApplicationsCubit, JobApplicationsState>(
      listener: (context, state) {
        state.whenOrNull(
          error: (message) {
            customSnackBar(context, message, ColorsManager.error);
          },
        );
      },
      builder: (context, state) {
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
            body: state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              loadingMore: (previous, nextPage) {
                final apps = _pendingApplications(
                  previous.data ?? <JobApplicationItem>[],
                );
                return _buildBody(applications: apps, isLoadingMore: true);
              },
              accepting: (previous) {
                final apps = _pendingApplications(
                  previous.data ?? <JobApplicationItem>[],
                );
                return _buildBody(applications: apps);
              },
              success: (data, page, limit, status, hasNextPage) {
                final apps = _pendingApplications(
                  data.data ?? <JobApplicationItem>[],
                );
                return _buildBody(applications: apps);
              },
              error: (message) => _buildError(message),
            ),
          ),
        );
      },
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.r, color: Colors.redAccent),
            SizedBox(height: 12.h),
            Text('فشل تحميل الطلبات', style: TextStyles.font14BlackBold),
            SizedBox(height: 8.h),
            Text(
              message,
              style: TextStyles.font12BlackMedium.copyWith(
                color: ColorsManager.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: 160.w,
              child: AppTextButton(
                buttonText: 'إعادة المحاولة',
                buttonHeight: 40,
                onPressed: () {
                  context.read<JobApplicationsCubit>().fetchApplicationsForJob(
                    widget.jobId,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody({
    required List<JobApplicationItem> applications,
    bool isLoadingMore = false,
  }) {
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Text(
                'العمال المتاحون (${applications.length})',
                style: TextStyles.font18BlackBold,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: applications.length,
            separatorBuilder: (_, _) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final item = applications[index];
              final id = item.id ?? '';
              return _WorkerCard(
                item: item,
                isSelected: _selectedIds.contains(id),
                onToggle: () => _toggleSelection(id),
              );
            },
          ),
        ),
        if (isLoadingMore)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: const Center(child: CircularProgressIndicator()),
          ),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: ColorsManager.lightGrey, width: 1.2.w),
            ),
          ),
          child: AppTextButton(
            buttonText: _selectedIds.isEmpty
                ? 'تأكيد اختيار العمالة'
                : 'تأكيد اختيار العمالة (${_selectedIds.length})',
            isLoading: _isConfirming,
            onPressed: _selectedIds.isEmpty ? () {} : _showConfirmDialog,
            backgroundColor: _selectedIds.isEmpty
                ? ColorsManager.lightGrey
                : ColorsManager.primary,
          ),
        ),
      ],
    );
  }
}

class _WorkerCard extends StatelessWidget {
  final JobApplicationItem item;
  final bool isSelected;
  final VoidCallback onToggle;

  const _WorkerCard({
    required this.item,
    required this.isSelected,
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
    ].where((part) => part.trim().isNotEmpty).join(' ').trim();

    final name = fullName.isNotEmpty ? fullName : 'عامل';
    final imageUrl = worker?.profileImage;
    final rating = _extractRating(worker, profile);
    final ratingCount = _extractRatingCount(worker, profile);

    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? ColorsManager.primary : ColorsManager.lightGrey,
            width: isSelected ? 1.6.w : 1.w,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: isSelected
                      ? ColorsManager.primary
                      : ColorsManager.grey,
                  width: 2,
                ),
                color: isSelected ? ColorsManager.primary : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 16.w, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 12.w),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 56.w,
                      height: 56.w,
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
                  Text(
                    name,
                    style: TextStyles.font16BlackBold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
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
                        style: TextStyles.font14BlackMedium,
                      ),
                      if (ratingCount > 0) ...[
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            '($ratingCount من التقييمات)',
                            style: TextStyles.font12BlackMedium.copyWith(
                              color: ColorsManager.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
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
