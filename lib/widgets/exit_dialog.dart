import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import 'app_button.dart';

class ExitDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onAction;
  final String actionLabel;
 final String title;

  final String message;
  const ExitDialog({
    super.key,
    required this.onCancel,
    required this.onAction,
    required this.title,
    required this.message,
    this.actionLabel = 'Exit', 
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTextStyles.header18.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              style: AppTextStyles.header16.copyWith(
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Cancel',
                    onTap: onCancel,
                    containerColor: AppColors.white,
                    fontColor: AppColors.black,
                    height: 45.h,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: AppButton(
                    text: actionLabel,
                    onTap: onAction,
                    containerColor: AppColors.gren,
                    fontColor: AppColors.black,
                    height: 45.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
