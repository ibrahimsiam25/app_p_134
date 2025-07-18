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
    this.fontColor = AppColors.blackLight,
    required this.containerColor,
    this.fontWeight = FontWeight.w600,
    required this.onTap,
    required this.text,
    this.rightWidget,
    this.borderColor,
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
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.symmetric(horizontal: margin ?? 0),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(radius ?? 100),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
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
