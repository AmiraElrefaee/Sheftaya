import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/colors_manager.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../publish_job/presentation/widgets/custom_app_bar.dart';
import '../../../../features/worker/my_application_jobs/data/models/my_jobs_response.dart';
import '../../../../core/utils/snackbar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ShiftJobSummaryCard extends StatelessWidget {
  final JobDetails? job;
  final DateTime startTime;
  final double price;

  const ShiftJobSummaryCard({
    super.key,
    required this.job,
    required this.startTime,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ حساب تاريخ اليوم الحالي مع الحفاظ على نفس الوقت
    final now = DateTime.now();
    final actualStartTime = DateTime(
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,
      startTime.second,
    );

    // ✅ إذا كان الوقت الحالي قبل وقت البدء اليوم، استخدم وقت البدء اليوم
    final displayTime = now.isBefore(actualStartTime) ? actualStartTime : now;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorsManager.lightGrey),
      ),
      child: Column(
        children: [
          CustomAppBar(title: "تأكيد الوصول"),
          _buildMapSection(context),
          SizedBox(height: 20.h),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: CachedNetworkImage(
                  imageUrl: job?.jobImages?.isNotEmpty == true ? job!.jobImages!.first : '',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: ColorsManager.lightGrey,
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: ColorsManager.lightGrey,
                    child: Icon(Icons.image_not_supported_outlined, color: ColorsManager.grey, size: 24.w),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job?.title ?? '', style: TextStyles.font20BlackMedium),
                    Text(job?.companyDetails?.companyName ?? job?.place ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.font20BlackMedium),
                    Text('${price.toStringAsFixed(0)} ج',
                        style: TextStyles.font20BlackBold.copyWith(color: ColorsManager.green)),
                  ],
                ),
              ),
              Column(
                children: [
                  _buildInfoBadge(_formatDate(displayTime)),
                  SizedBox(height: 4.h),
                  _buildInfoBadge(_formatTime(displayTime)), // ✅ استخدام _formatTime الجديد
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  // ✅ بناء رابط الخريطة من الإحداثيات أو العنوان
  Uri? _buildMapsUri() {
    final coords = job?.location?.coordinates;
    final address = job?.location?.address ?? job?.place;

    if (coords != null && coords.length >= 2) {
      final longitude = _asDouble(coords[0]);
      final latitude = _asDouble(coords[1]);

      if (latitude != null && longitude != null) {
        return Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
        );
      }
    }

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

  // ✅ فتح الخريطة عند الضغط
  Future<void> _openMap(BuildContext context) async {
    final uri = _buildMapsUri();

    if (uri == null) {
      if (context.mounted) {
        customSnackBar(
          context,
          'لا يوجد موقع محدد لهذه الوظيفة',
          ColorsManager.error,
        );
      }
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        customSnackBar(
          context,
          'تعذر فتح الخريطة',
          ColorsManager.error,
        );
      }
    } catch (_) {
      if (context.mounted) {
        customSnackBar(
          context,
          'حدث خطأ أثناء محاولة فتح الخريطة',
          ColorsManager.error,
        );
      }
    }
  }

  // ✅ عرض الخريطة
  Widget _buildMapSection(BuildContext context) {
    final location = job?.location;
    final coordinates = location?.coordinates;
    final address = location?.address ?? job?.place ?? 'موقع العمل';

    if (coordinates != null && coordinates.length >= 2) {
      final longitude = _asDouble(coordinates[0]);
      final latitude = _asDouble(coordinates[1]);

      if (latitude != null && longitude != null) {
        return GestureDetector(
          onTap: () => _openMap(context),
          child: Container(
            height: 162.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: ColorsManager.lightGrey, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  FlutterMap(
                    options: MapOptions(
                      center: LatLng(latitude, longitude),
                      zoom: 15,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.sheftaya.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(latitude, longitude),
                            width: 40.w,
                            height: 40.h,
                            child: Icon(
                              Icons.location_on_rounded,
                              size: 32.sp,
                              color: ColorsManager.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned.fill(
                    child: AbsorbPointer(
                      absorbing: true,
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  Container(
                    color: Colors.black.withValues(alpha: 0.05),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.open_in_new,
                          size: 20.sp,
                          color: ColorsManager.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return _buildMapPlaceholder(context, address, null, null);
  }

  // ✅ Placeholder للخريطة
  Widget _buildMapPlaceholder(BuildContext context, String address, double? lat, double? lng) {
    return GestureDetector(
      onTap: () => _openMap(context),
      child: Container(
        height: 162.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsManager.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: ColorsManager.lightGrey, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_rounded,
              size: 48.sp,
              color: ColorsManager.primary,
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                address,
                style: TextStyles.font14BlackMedium.copyWith(
                  color: ColorsManager.primary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (lat != null && lng != null) ...[
              SizedBox(height: 4.h),
              Text(
                '${lat.toStringAsFixed(4)}°, ${lng.toStringAsFixed(4)}°',
                style: TextStyles.font10BlackRegular.copyWith(
                  color: ColorsManager.grey,
                ),
              ),
            ],
            SizedBox(height: 4.h),
            Text(
              'اضغط للتنقل إلى الموقع',
              style: TextStyles.font12BlackMedium.copyWith(
                color: ColorsManager.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ دالة لحساب اليوم الحقيقي
  String _formatDate(DateTime dt) {
    const days = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    const months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];

    // ✅ استخدم اليوم الحالي الفعلي
    final now = DateTime.now();
    final actualDate = DateTime(now.year, now.month, now.day);

    return '${days[actualDate.weekday - 1]} ${actualDate.day} ${months[actualDate.month - 1]}';
  }

  // ✅ تنسيق الوقت بنظام 12 ساعة (صباحاً / مساءً)
  String _formatTime(DateTime dt) {
    int hour = dt.hour;
    int minute = dt.minute;
    String period = hour >= 12 ? 'م' : 'ص';
    int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    String minuteStr = minute.toString().padLeft(2, '0');
    return 'من $displayHour:$minuteStr $period';
  }

  Widget _buildInfoBadge(String text) {
    return Container(
      width: 127.w,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: ColorsManager.background,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(text, style: TextStyles.font14BlackMedium),
    );
  }
}