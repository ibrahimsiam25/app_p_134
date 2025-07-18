import 'package:app_p_134/core/constants/app_colors.dart';
import 'package:app_p_134/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriceAmountInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String title;
  final VoidCallback onChanged;

  const PriceAmountInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
         title,
          style: TextStyle(
            fontFamily: AppTextStyles.fontMontserrat,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.blackLight,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffFDFCFD),
            border: Border.all(color: AppColors.gray),
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: AppTextStyles.header16.copyWith(color: AppColors.blackLight),
            maxLength: 6,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            onChanged: (value) => onChanged(),
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: AppTextStyles.header16.copyWith(color: AppColors.gray),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 16.w, right: 8.w),
                child: Icon(
                  Icons.attach_money,
                  color: AppColors.blackLight,
                  size: 20.sp,
                ),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 40.w,
                minHeight: 20.h,
              ),
              border: InputBorder.none,
              counterText: '',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
