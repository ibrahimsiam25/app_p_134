import 'package:app_p_134/core/constants/app_colors.dart';
import 'package:app_p_134/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackPressed;

  const CustomBackAppBar({
    super.key,
    required this.title,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.blackLight),
        onPressed: onBackPressed,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: AppTextStyles.fontMontserrat,
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.blackLight,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
