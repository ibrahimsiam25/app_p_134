import 'package:app_p_134/core/constants/app_colors.dart';
import 'package:app_p_134/core/constants/app_text_styles.dart';
import 'package:app_p_134/core/constants/assets.dart';
import 'package:app_p_134/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessDialog extends StatelessWidget {
  final VoidCallback? onCreateNew;
  final VoidCallback? onOk;

  const SuccessDialog({
    super.key,
    this.onCreateNew,
    this.onOk,
  });

  static void show(
    BuildContext context, {
    VoidCallback? onCreateNew,
    VoidCallback? onOk,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => SuccessDialog(
        onCreateNew: onCreateNew,
        onOk: onOk,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tree Image
            Container(
             
              height: 160.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Image.asset(
                Assets.imagesGoalAchieved5,
                fit: BoxFit.contain,
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Title with emoji
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'GOAL ACHIEVED!',
                  style: AppTextStyles.header18.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 2.w),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    '🎉',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Description text
            Text(
              'Congratulations! You\'ve reached your financial goal, and your plant has turned into a true giant! Your persistence and discipline have paid off.',
              textAlign: TextAlign.center,
              style: AppTextStyles.header16.copyWith(
                color: AppColors.blackLight,
               
              ),
            ),
            
            SizedBox(height: 12.h),
            
            Text(
              'What\'s next? You can now enjoy the results of your hard work or set a new goal and grow another plant!',
              textAlign: TextAlign.center,
              style: AppTextStyles.header16.copyWith(
                color: AppColors.blackLight,
              
              ),
            ),
            
            SizedBox(height: 32.h),
             
            // Buttons
             Row(
              children: [
                Expanded(
                   flex: 2, 
                  child: AppButton(
                    text:  'Create new',
                    onTap:() {
                    
                      onCreateNew?.call();
                    },
                    containerColor: AppColors.white,
                    fontColor: AppColors.red,
                    height: 50.h,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                   flex: 1,
                  child: AppButton(
                    text: 'OK!',
                    onTap:  () {
                  
                      onOk?.call();
                    },
                    containerColor: AppColors.green,
                    fontColor: AppColors.black,
                    height: 50.h,

                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}