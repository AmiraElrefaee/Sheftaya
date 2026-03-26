import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/colors_manager.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../publish_job/presentation/widgets/custom_app_bar.dart';

class ShiftJobSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

          _buildMapSection(),
          SizedBox(height: 20.h,),

          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child:CachedNetworkImage(
                  imageUrl: "",
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  // يظهر أثناء تحميل الصورة
                  placeholder: (context, url) => Container(
                    color: ColorsManager.lightGrey,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  // يظهر في حالة حدوث خطأ في الرابط أو الإنترنت
                  errorWidget: (context, url, error) => Container(
                    color: ColorsManager.lightGrey,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: ColorsManager.grey,
                      size: 24.w,
                    ),
                  ),
              ),),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("نادل", style: TextStyles.font20BlackMedium),
                    Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        "Center Perk Cafe", style: TextStyles.font20BlackMedium),
                    Text("400 ج", style: TextStyles.font20BlackBold.copyWith(color: ColorsManager.green)),
                  ],
                ),
              ),
              Column(
                children: [
                  _buildInfoBadge("الثلاثاء 2 ديسمبر"),
                  SizedBox(height: 4.h),
                  _buildInfoBadge("من 2:00م : 6:00م"),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(String text) {
    return Container(
      width: 127.w,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 9.h),
      decoration: BoxDecoration(color: ColorsManager.background, borderRadius: BorderRadius.circular(10.r)),
      child: Text(text, style: TextStyles.font14BlackMedium),
    );
  }
  Widget _buildMapSection() {
    return Container(
      height: 162.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorsManager.primary,
        borderRadius: BorderRadius.circular(12.r),
        image: DecorationImage(image: AssetImage('assets/images/empty_state.png'),
            fit: BoxFit.cover),
      ),
      child: Center(child:
      Container(

        padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            
              color:ColorsManager.primary ,
            shape: BoxShape.circle
          ),
          child: SvgPicture.asset('assets/icon/sigin_state.svg', height: 20,))
      ),
    );
  }
}