import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/features/setting/presentation/widgets/setting_item.dart';
import '../../../../core/constants/shared_pref_helper.dart';
import '../../../../core/constants/shared_pref_keys.dart';
import 'show_logout_confirmation_dialog.dart';

class SettingScreenBody extends StatelessWidget {
  const SettingScreenBody({super.key});

  Future<void> _logout(BuildContext context) async {
    await SharedPrefHelper.removeSecuredData(SharedPrefKeys.userToken);
    if (context.mounted) {
      GoRouter.of(context).go(AppRouter.kLoginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 12.h),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0).copyWith(top: 0),
                children: [
                  SettingItem(
                    icon: Icons.person_outline,
                    title: 'الملف الشخصي',
                    onTap: () {
                      GoRouter.of(context).push(AppRouter.kMyProfileScreen);
                    },
                  ),
                  Divider(color: Colors.grey[200], thickness: 1),
                  SettingItem(
                    icon: Icons.help_outline,
                    title: 'الأسئلة الشائعة',
                    onTap: () {
                      GoRouter.of(context).push(AppRouter.kFaqScreen);
                    },
                  ),
                  Divider(color: Colors.grey[200], thickness: 1),
                  SettingItem(
                    icon: Icons.support_agent,
                    title: 'الدعم الفني',
                    onTap: () {
                      GoRouter.of(
                        context,
                      ).push(AppRouter.kSupportContactScreen);
                    },
                  ),
                  Divider(color: Colors.grey[200], thickness: 1),
                  SettingItem(
                    icon: Icons.lock_outline,
                    title: 'تغيير كلمة المرور',
                    onTap: () {
                      GoRouter.of(
                        context,
                      ).push(AppRouter.kChangePasswordScreen);
                    },
                  ),
                  Divider(color: Colors.grey[200], thickness: 1),

                  SettingItem(
                    icon: Icons.logout,
                    title: 'تسجيل الخروج',
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () async {
                      final bool? shouldLogout =
                          await showLogoutConfirmationDialog(context);
                      if (shouldLogout == true && context.mounted) {
                        await _logout(context);
                      }
                    },
                  ),
                  const Divider(color: Colors.red, thickness: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
