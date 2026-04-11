import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/colors_manager.dart';
import '../../../../core/theme/text_styles.dart';

Future<bool?> showLogoutConfirmationDialog(BuildContext context) {
  bool? result;

  return AwesomeDialog(
    context: context,
    dialogType: DialogType.question,
    animType: AnimType.bottomSlide,
    dismissOnTouchOutside: false,
    dismissOnBackKeyPress: false,
    title: 'تأكيد تسجيل الخروج',
    desc: 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
    btnCancelText: 'إلغاء',
    btnOkText: 'تأكيد',
    titleTextStyle: TextStyles.font24BlackBold,
    descTextStyle: TextStyles.font16BlackMedium,
    btnCancelOnPress: () {
      result = false;
    },
    btnCancelColor: ColorsManager.lightGrey,
    buttonsTextStyle: TextStyles.font16WhiteBold,
    btnOkColor: ColorsManager.error,
    btnOkOnPress: () {
      result = true;
    },
  ).show().then((_) => result);
}
