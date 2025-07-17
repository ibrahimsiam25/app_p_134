import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.width,
    this.height = 60,
    this.radius,
    this.margin,
    this.fontSize,
    this.fontColor = AppColors.black,
    this.containerColor = AppColors.gren,
    this.fontWeight = FontWeight.w600,
    required this.onTap,
    required this.text,
    this.rightWidget,
  });

  final double? width;
  final double? height;
  final double? margin;
  final double? radius;
  final double? fontSize;
  final Color fontColor;
  final Color containerColor;
  final FontWeight fontWeight;
  final VoidCallback? onTap;
  final String text;
  final Widget? rightWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.symmetric(horizontal: margin ?? 0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: containerColor,
          foregroundColor: fontColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 100),
          ),
          padding: const EdgeInsets.all(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: AppTextStyles.header18.copyWith(
                color: fontColor,
                fontWeight: fontWeight,
                fontSize: fontSize,
              ),
            ),
            if (rightWidget != null) ...[
              const SizedBox(width: 8),
              rightWidget!,
            ]
          ],
        ),
      ),
    );
  }
}
