import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';

class AppTextButton extends StatelessWidget {
  final double? borderRadius;
  final Color? backgroundColor;
  final double buttonHeight;
  final String buttonText;
  final TextStyle? textStyle;
  final VoidCallback onPressed;
  final bool isLoading;

  final IconData? icon;            
  final double iconSize;        
  final Color? iconColor;          
  final bool iconAtEnd;            

  const AppTextButton({
    super.key,
    this.borderRadius,
    this.buttonHeight = 48,
    required this.buttonText,
    this.textStyle,
    required this.onPressed,
    this.backgroundColor,
    this.isLoading = false,

    // الإضافات
    this.icon,
    this.iconSize = 20,
    this.iconColor,
    this.iconAtEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
            ),
          ),
          backgroundColor: WidgetStatePropertyAll<Color>(
            backgroundColor ?? ColorsManager.primary,
          ),
          fixedSize: WidgetStatePropertyAll(
            Size(double.infinity, buttonHeight.h),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null && !iconAtEnd) ...[
                    Icon(
                      icon,
                      size: iconSize,
                      color: iconColor ?? Colors.white,
                    ),
                    SizedBox(width: 6.w),
                  ],

                  Text(
                    buttonText,
                    textAlign: TextAlign.center,
                    style: textStyle ?? TextStyles.font16WhiteBold,
                  ),

                  if (icon != null && iconAtEnd) ...[
                    SizedBox(width: 6.w),
                    Icon(
                      icon,
                      size: iconSize,
                      color: iconColor ?? Colors.white,
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
