import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/utils/snackbar.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/features/worker/home/data/models/all_jobs/jobs_response.dart';
import 'package:sheftaya/features/worker/home/data/models/review_model.dart';
import 'package:sheftaya/features/worker/home/logic/apply_for_job/apply_job_cubit.dart';
import 'package:sheftaya/features/worker/home/logic/apply_for_job/apply_job_state.dart';
import 'package:sheftaya/features/worker/home/logic/job_details/job_details_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetails extends StatefulWidget {
  final String jobId;

  const JobDetails({super.key, required this.jobId});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<JobDetailsCubit>().fetch(jobId: widget.jobId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApplyJobCubit, ApplyJobState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (response) {
            customSnackBar(
              context,
              'تم التقديم على الوظيفة بنجاح',
              ColorsManager.success,
            );
            GoRouter.of(context).pop();
          },
        );
      },
      child: BlocBuilder<JobDetailsCubit, JobDetailsState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            success: (job) => _buildBody(context, job),
            error: (message) => Scaffold(
              appBar: AppBar(
                title: Text(
                  'تفاصيل الوظيفة',
                  style: TextStyles.font18BlackBold,
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.black),
              ),
              body: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48.r,
                        color: Colors.redAccent,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'فشل تحميل تفاصيل الوظيفة',
                        style: TextStyles.font18BlackBold,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        message,
                        style: TextStyles.font14BlackMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      AppTextButton(
                        onPressed: () => context.read<JobDetailsCubit>().fetch(
                          jobId: widget.jobId,
                        ),
                        buttonText: 'إعادة المحاولة',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, JobItem job) {
    final reviews = _mockReviews();
    final hasReviews = reviews.isNotEmpty;

    final startDT = job.startDateTime != null
        ? DateTime.tryParse(job.startDateTime!)
        : null;

    final endDT = startDT != null && job.dailyWorkHours != null
        ? startDT.add(Duration(hours: job.dailyWorkHours!))
        : null;

    final formattedDate = startDT != null
        ? '${startDT.day} ${_arabicMonth(startDT.month)}'
        : '';

    final formattedStartTime = startDT != null
        ? _formatArabicTime(startDT)
        : '';
    final formattedEndTime = endDT != null ? _formatArabicTime(endDT) : '';

    final ownerName = job.employerId != null
        ? '${job.employerId!.firstName ?? ''} ${job.employerId!.lastName ?? ''}'
              .trim()
        : null;

    final imageUrl = job.jobImages != null && job.jobImages!.isNotEmpty
        ? job.jobImages!.first
        : null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('تفاصيل الوظيفة', style: TextStyles.font18BlackBold),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
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
                      width: 2.w,
                    ),
                  ),
                ),
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
                                    color: ColorsManager.lightGrey.withValues(
                                      alpha: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.business,
                                    size: 40.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job.title ?? '',
                                textAlign: TextAlign.right,
                                style: TextStyles.font24BlackBold.copyWith(
                                  fontSize: 28.sp,
                                  height: 1,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                job.place ?? '',
                                textAlign: TextAlign.right,
                                style: TextStyles.font20BlackSemiBold.copyWith(
                                  color: ColorsManager.darkGrey,
                                  height: 1,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: ownerName ?? 'صاحب الوظيفة',
                                      style: TextStyles.font14PrimarySemiBold
                                          .copyWith(
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                    ),
                                    TextSpan(
                                      text: ' (صاحب الوظيفة)',
                                      style: TextStyles.font14BlackMedium
                                          .copyWith(
                                            color: ColorsManager.darkGrey,
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
                    SizedBox(height: 12.h),
                    Column(
                      children: [
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
                                label: '${job.dailyWorkHours ?? 0} ساعات',
                                subtitle:
                                    'من $formattedStartTime الى $formattedEndTime',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Expanded(
                              child: _infoChip(
                                icon: Icons.work_outline_rounded,
                                label: job.experienceLevel ?? 'بدون خبرة',
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: _infoChip(
                                icon: Icons.attach_money_sharp,
                                label:
                                    '${job.pricePerHour?.amount?.toStringAsFixed(0) ?? '0'} ج/ساعة',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        _locationSection(job),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('وصف الوظيفة'),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: ColorsManager.lightGrey),
                      ),
                      child: Text(
                        job.details ?? 'لا يوجد تفاصيل متاحة',
                        textAlign: TextAlign.right,
                        style: TextStyles.font14BlackMedium.copyWith(
                          height: 1.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _sectionTitle('تقييمات'),
                        InkWell(
                          onTap: () => context.push(
                            AppRouter.kJobReviewsScreen,
                            extra: reviews,
                          ),
                          child: Text(
                            'رؤيه الكل',
                            style: TextStyles.font14SecondaryMedium,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    if (!hasReviews)
                      Center(
                        child: Text(
                          'لا توجد تقييمات بعد',
                          style: TextStyles.font14BlackMedium,
                        ),
                      )
                    else
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: reviews
                              .take(2)
                              .map(
                                (r) => Padding(
                                  padding: EdgeInsets.only(left: 12.w),
                                  child: _reviewCardCompact(r),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                  border: Border(
                    top: BorderSide(color: ColorsManager.lightGrey, width: 2.w),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),
                    AppTextButton(
                      buttonText: 'التقديم على الوظيفة',
                      onPressed: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.question,
                          animType: AnimType.scale,
                          title: 'تأكيد التقديم',
                          desc:
                              'هل أنت متأكد أنك تريد التقديم على هذه الوظيفة؟',
                          btnCancelText: 'إلغاء',
                          btnOkText: 'تأكيد',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            context.read<ApplyJobCubit>().applyForJob(
                              widget.jobId,
                            );
                          },
                        ).show();
                      },
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _locationSection(JobItem job) {
    final uri = _buildMapsUri(job);
    final locationText = job.location?.address ?? 'جاري تحديد العنوان...';

    return InkWell(
      onTap: uri == null ? null : () => _openMaps(uri),
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: ColorsManager.lightGrey.withValues(alpha: 0.5),
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
      ),
    );
  }

  Uri? _buildMapsUri(JobItem job) {
    final coords = job.location?.coordinates;

    if (coords == null || coords.length < 2) {
      final address = job.location?.address ?? job.place;
      if (address != null && address.trim().isNotEmpty) {
        return Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
        );
      }
      return null;
    }

    final lng = _asDouble(coords[0]);
    final lat = _asDouble(coords[1]);

    if (lat != null && lng != null) {
      return Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      );
    }

    final address = job.location?.address ?? job.place;
    if (address != null && address.trim().isNotEmpty) {
      return Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
      );
    }

    return null;
  }

  double? _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Future<void> _openMaps(Uri uri) async {
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        customSnackBar(context, 'تعذر فتح الخريطة', ColorsManager.error);
      }
    } catch (_) {
      if (!mounted) return;
      customSnackBar(context, 'تعذر فتح Google Maps', ColorsManager.error);
    }
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

  String _formatArabicTime(DateTime dt) {
    final hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final isAm = hour < 12;
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$hour12:$minute ${isAm ? 'ص' : 'م'}';
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(title, style: TextStyles.font18BlackBold),
    );
  }

  Widget _infoChip({
    required IconData icon,
    required String label,
    String? subtitle,
  }) {
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
              Text(
                label,
                textAlign: TextAlign.right,
                style: TextStyles.font16BlackMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          if (subtitle != null) ...[
            SizedBox(height: 2.h),
            Text(
              subtitle,
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

  Widget _reviewCardCompact(ReviewModel review) {
    return Container(
      width: 260.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorsManager.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundImage: review.avatarUrl != null
                    ? NetworkImage(review.avatarUrl!)
                    : null,
                backgroundColor: ColorsManager.primary.withValues(alpha: 0.15),
                child: review.avatarUrl == null
                    ? Text(
                        review.userName.isNotEmpty ? review.userName[0] : '؟',
                        style: TextStyles.font14PrimaryBold,
                      )
                    : null,
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review.userName, style: TextStyles.font14BlackSemiBold),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${review.rating}',
                        style: TextStyles.font12BlackSemiBold,
                      ),
                      SizedBox(width: 2.w),
                      Icon(
                        Icons.star_rounded,
                        size: 14.sp,
                        color: ColorsManager.warning,
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Text(
                review.date ?? '',
                style: TextStyles.font12BlackMedium.copyWith(
                  color: ColorsManager.darkGrey,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            review.comment,
            textAlign: TextAlign.right,
            style: TextStyles.font12BlackMedium.copyWith(
              color: ColorsManager.darkGrey,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  List<ReviewModel> _mockReviews() {
    return [
      ReviewModel(
        userName: 'ندى الجمل',
        rating: 5.0,
        comment:
            'الخدمة كانت بطيئة جدا. الخدمة كانت بطيئة بشكل مزعج، والموظفين واضح إنهم مش مهتمين بساعدوا خالص، وجودة المنتج أقل بكتير من المتوقع.',
        date: 'منذ 1 يوم',
      ),
      ReviewModel(
        userName: 'ندى',
        rating: 0.0,
        comment: 'بصراحة التجربة كانت سيئة جدا، والموظفين، وجودة المنتج.',
        date: 'منذ 1 يوم',
      ),
    ];
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
