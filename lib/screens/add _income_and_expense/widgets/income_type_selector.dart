import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

enum IncomeType { addToGoal, addToTransactions }

class IncomeTypeSelector extends StatelessWidget {
  final IncomeType selectedType;
  final ValueChanged<IncomeType> onTypeChanged;
  final String title ;
  const IncomeTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    required this.title,
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
        SizedBox(height: 12.h),
        _buildRadioOption(
          title: 'Add to goal',
          value: IncomeType.addToGoal,
        ),
        SizedBox(height: 12.h),
        _buildRadioOption(
          title: 'Add to transactions',
          value: IncomeType.addToTransactions,
        ),
      ],
    );
  }

  Widget _buildRadioOption({
    required String title,
    required IncomeType value,
  }) {
    final isSelected = selectedType == value;
    
    return GestureDetector(
      onTap: () => onTypeChanged(value),
      child: Row(
        children: [
          Container(
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.royalPurple : AppColors.gray,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.royalPurple,
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: 12.w),
          Text(
            title,
            style: AppTextStyles.header16.copyWith(
              color: AppColors.blackLight,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
