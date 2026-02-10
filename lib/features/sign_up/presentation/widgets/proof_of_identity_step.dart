import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/features/sign_up/presentation/widgets/upload_tile.dart';

class ProofOfIdentityStep extends StatelessWidget {
  final File? idFront;
  final File? idBack;
  final File? personalPhoto;
  final VoidCallback onPickIdFront;
  final VoidCallback onPickIdBack;
  final VoidCallback onPickPersonalPhoto;

  const ProofOfIdentityStep({
    super.key,
    required this.idFront,
    required this.idBack,
    required this.personalPhoto,
    required this.onPickIdFront,
    required this.onPickIdBack,
    required this.onPickPersonalPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'إثبات الهوية',
            style: TextStyles.font16BlackBold.copyWith(fontSize: 20.sp),
          ),
          SizedBox(height: 12.h),
          Text('صورة وجه البطاقة', style: TextStyles.font14BlackRegular),
          SizedBox(height: 8.h),
          UploadTile(
            label: idFront == null
                ? 'ارفع الصورة هنا'
                : idFront!.path.split('/').last,
            onPick: onPickIdFront,
            file: idFront,
            acceptPdf: true,
          ),
          SizedBox(height: 12.h),
          Text('صورة خلفية البطاقة', style: TextStyles.font14BlackRegular),
          SizedBox(height: 8.h),
          UploadTile(
            label: idBack == null
                ? 'ارفع الصورة هنا'
                : idBack!.path.split('/').last,
            onPick: onPickIdBack,
            file: idBack,
            acceptPdf: true,
          ),
          SizedBox(height: 12.h),
          Text('صورة شخصية لك (إختياري)', style: TextStyles.font14BlackRegular),
          SizedBox(height: 8.h),
          UploadTile(
            label: personalPhoto == null
                ? 'ارفع الصورة هنا'
                : personalPhoto!.path.split('/').last,
            onPick: onPickPersonalPhoto,
            file: personalPhoto,
            acceptPdf: true,
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey, width: 1.w),
            ),
            child: Text(
              '⚠️​ تأكد أن الصور واضحة وقابلة للقراءة.',
              style: TextStyles.font12PrimarySemiBold,
            ),
          ),
        ],
      ),
    );
  }
}
