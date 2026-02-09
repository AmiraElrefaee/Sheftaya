import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
class UploadTile extends StatelessWidget {
  final String label;
  final VoidCallback onPick;
  final File? file;
  final bool acceptPdf;

  const UploadTile({
    required this.label,
    required this.onPick,
    this.file,
    this.acceptPdf = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPick,
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: ColorsManager.grey, width: 1.w),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                file == null ? label : (file!.path.split('/').last),
                style: TextStyles.font14BlackRegular.copyWith(
                  color: ColorsManager.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.upload_file, color: ColorsManager.primary),
          ],
        ),
      ),
    );
  }
}
