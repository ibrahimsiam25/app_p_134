import 'package:app_p_134/core/constants/app_colors.dart';
import 'package:app_p_134/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomSheet extends StatelessWidget {
  final VoidCallback? onDeletePressed;
  final VoidCallback? onCancelPressed;

  const CustomBottomSheet({
    super.key,
    this.onDeletePressed,
    this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal:8.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // First container with Options, Delete transaction, and Delete button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              children: [
                // Options title
                Text(
                  'Options',
                  style: AppTextStyles.header13.copyWith(
                   fontSize: 13.sp,
                    fontWeight: FontWeight.w600, // 590 closest to w600
                 
                    color: AppColors.darkGray.withOpacity(0.5),
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                // Delete transaction text
                Text(
                  'Delete transaction',
                  style: AppTextStyles.header13.copyWith(
              
                    fontWeight: FontWeight.w400, // Regular
              
                    color: AppColors.darkGray.withOpacity(0.5),
                  ),
                ),
                
                SizedBox(height: 20.h),
                
                // Divider line
                Container(
                  height: 1.h,
                  color: AppColors.gray.withOpacity(0.3),
                ),
                
                SizedBox(height: 20.h),
                
                // Delete button (as text, not elevated button)
                GestureDetector(
                  onTap: onDeletePressed ?? () => Navigator.pop(context),
                  child: Text(
                    'Delete',
                    style: AppTextStyles.header17.copyWith(
                      color: AppColors. brightRed,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // Second container with Cancel button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: GestureDetector(
              onTap: onCancelPressed ?? () => Navigator.pop(context),
              child: Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: AppTextStyles.header17.copyWith(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
