import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class SettingCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isLast;

  const SettingCard({
    super.key,
    required this.title,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
          bottomLeft: Radius.circular(isLast ? 20.r : 0),
          bottomRight: Radius.circular(isLast ? 20.r : 0),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.header16.copyWith(
                    color: AppColors.lightGray,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: AppColors.whiteDark,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 24.sp,
                  color: AppColors.blackLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
