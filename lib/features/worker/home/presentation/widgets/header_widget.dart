import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/constants/user_cubit.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_text_form_field.dart';

class HeaderWidget extends StatelessWidget {
  final List<dynamic> jobs;

  const HeaderWidget({super.key, required this.jobs});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final user = userState.user;
        final firstName = user?.firstname ?? '';
        final city = user?.city ?? '';
        final imageUrl = user?.profileImg;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
            border: BorderDirectional(
              bottom: BorderSide(color: ColorsManager.lightGrey),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 32.h),
              Row(
                children: [
                  InkWell(
                    onTap: () => context.push(AppRouter.kMyProfileScreen),
                    child: CircleAvatar(
                      radius: 24.h,
                      backgroundColor: ColorsManager.lightGrey,
                      backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                          ? NetworkImage(imageUrl)
                          : null,
                      child: imageUrl == null || imageUrl.isEmpty
                          ? Icon(Icons.person, size: 24.sp, color: Colors.white)
                          : null,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'أهلاً، $firstName',
                        style: TextStyles.font18BlackSemiBold,
                      ),
                      if (city.isNotEmpty)
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.locationDot,
                              size: 14.sp,
                              color: ColorsManager.primary,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              city,
                              style: TextStyles.font14BlackSemiBold.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      if (city.isEmpty)
                        Text(
                          'فرص يومية جاهزة ليك 😊',
                          style: TextStyles.font14BlackSemiBold.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: ColorsManager.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: IconButton(
                      onPressed: () =>
                          context.push(AppRouter.kNotificationsScreen),
                      icon: Icon(
                        Icons.notifications_outlined,
                        size: 24.sp,
                        color: ColorsManager.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              AppTextFormField(
                hintText: 'ابحث عن وظيفة',
                prefixIcon: const Icon(FontAwesomeIcons.magnifyingGlass),
                onTap: () => context.push(AppRouter.kSearchScreen, extra: jobs),
                readOnly: true,
              ),
            ],
          ),
        );
      },
    );
  }
}
