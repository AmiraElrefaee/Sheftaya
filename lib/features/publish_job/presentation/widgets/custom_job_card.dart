import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_loading_indicator.dart'; // تأكد من المسار الصحيح

import 'package:intl/intl.dart';

import '../../data/model/job_details_response.dart'; // ستحتاجين إضافة intl في pubspec.yaml لتنسيق التاريخ بسهولة

class JobSummaryCard extends StatelessWidget {
  final JobDetails job; // استلام الداتا هنا
  const JobSummaryCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    // تنسيق التاريخ والوقت
    DateTime startUtc = DateTime.parse(job.startDateTime);

    // 2. التحويل من UTC إلى التوقيت المحلي (توقيت مصر)
    DateTime localStart = startUtc.toLocal();

    // 3. التنسيق العربي اللي اخترتيه (يوم/شهر)
    String formattedDay = DateFormat('d MMMM', 'ar').format(localStart); // مثال: 16 مارس

    // 4. التنسيق العربي للوقت (صباحاً/مساءً) مع استخدام localStart
    String formattedTime = DateFormat('h:mm a', 'ar')
        .format(localStart)
        .replaceAll('AM', 'صباحاً')
        .replaceAll('PM', 'مساءً');

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        border: Border.all(color: ColorsManager.lightGrey),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CachedNetworkImage(
                  imageUrl: 'https://wallpapercave.com/wp/wp1874173.jpg',
                  width: 50.w,
                  height: 50.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const CustomLoadingIndicator(size: 20),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded( // لتجنب الـ Overflow
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.title, // العنوان من الـ API
                        style: TextStyles.font16BlackBold.copyWith(fontSize: 18.sp)),
                    Text(job.mainPlace, // الـ mainPlace من الـ API
                        style: TextStyles.font14BlackRegular),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: ColorsManager.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text('${job.requiredWorkers} عمال', style: TextStyles.font12PrimaryMedium),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: ColorsManager.primary, size: 18.sp),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  job.address, // الـ address من الـ API
                  style: TextStyles.font12BlackRegular.copyWith(color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // التاجز (Tags)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTag('${job.dailyWorkHours} ساعات'),
              _buildTag(job.experienceLevel == 'junior' ? 'مبتدئ' : job.experienceLevel),
              _buildTag(formattedDay), // اليوم والشهر
              _buildTag(formattedTime), // الساعة
            ],
          ),
          const Divider(height: 32, color: ColorsManager.lightGrey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${job.price}',
                      style: TextStyles.font24PrimaryBold.copyWith(color: ColorsManager.green)),
                  SizedBox(width: 4.w),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Text('ج', style: TextStyles.font24PrimaryBold.copyWith(color: ColorsManager.green)),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  minimumSize: Size(100.w, 40.h),
                ),
                child: Text('التفاصيل', style: TextStyles.font14WhiteBold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      margin: EdgeInsets.only(left: 8.w), // تقليل الـ margin لتناسب الشاشة
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ColorsManager.lightGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(label, style: TextStyles.font12BlackMedium, maxLines: 1),
    );
  }
}