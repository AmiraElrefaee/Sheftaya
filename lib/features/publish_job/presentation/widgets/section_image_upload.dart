// lib/features/publish_job/presentation/widgets/section_image_upload.dart

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/colors_manager.dart';
import '../../../../core/theme/text_styles.dart';

class ImageUploadWidget extends StatefulWidget {
  final List<String>? initialImages;
  final Function(List<String>) onImagesChanged;

  const ImageUploadWidget({
    super.key,
    this.initialImages,
    required this.onImagesChanged,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  List<String> _imagePaths = [];

  @override
  void initState() {
    super.initState();
    _imagePaths = widget.initialImages ?? [];
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        for (var image in images) {
          _imagePaths.add(image.path);
        }
        widget.onImagesChanged(_imagePaths);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imagePaths.removeAt(index);
      widget.onImagesChanged(_imagePaths);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ زر رفع الصور
        InkWell(
          onTap: _pickImages,
          child: Container(
            width: double.infinity,
            height: 100.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: const Color(0xFFD2D2D2),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.upload_sharp,
                  color: Colors.grey,
                  size: 30.sp,
                ),
                SizedBox(height: 4.h),
                Text(
                  'ارفع الصور هنا (اختياري)',
                  style: TextStyles.font12BlackRegular.copyWith(
                    color: Colors.grey,
                  ),
                ),
                if (_imagePaths.isNotEmpty)
                  Text(
                    '${_imagePaths.length} صورة',
                    style: TextStyles.font12BlackMedium.copyWith(
                      color: ColorsManager.primary,
                    ),
                  ),
              ],
            ),
          ),
        ),

        SizedBox(height: 10.h),

        // ✅ عرض الصور المرفوعة
        if (_imagePaths.isNotEmpty)
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imagePaths.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 8.w),
                      width: 70.w,
                      height: 70.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        image: DecorationImage(
                          image: FileImage(File(_imagePaths[index])),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 8.w,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          padding: EdgeInsets.all(2.r),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}