import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';

class ProfileImage extends StatefulWidget {
  final String? imageUrl;
  final double size;
  final VoidCallback? onTap;

  const ProfileImage({this.imageUrl, this.size = 160, this.onTap, super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  ImageProvider _resolveProvider(String? path) {
    if (path == null || path.isEmpty) {
      return const AssetImage('assets/images/download.jpg');
    }
    if (path.startsWith('/') ||
        path.startsWith('file://') ||
        path.contains('/cache/')) {
      try {
        final normalized = path.startsWith('file://')
            ? path.replaceFirst('file://', '')
            : path;
        final file = File(normalized);
        if (file.existsSync()) {
          return FileImage(file);
        }
      } catch (_) {}
    }
    if (path.startsWith('http') || path.startsWith('https')) {
      return NetworkImage(path);
    }
    return const AssetImage('assets/images/download.jpg');
  }

  @override
  Widget build(BuildContext context) {
    final provider = _resolveProvider(widget.imageUrl);
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: widget.size.w,
        height: widget.size.w,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: widget.size.w,
              height: widget.size.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
                border: Border.all(color: Colors.white, width: 4),
                image: DecorationImage(image: provider, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              bottom: 6.h,
              right: 6.w,
              child: Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.edit,
                  size: 18.sp,
                  color: ColorsManager.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
