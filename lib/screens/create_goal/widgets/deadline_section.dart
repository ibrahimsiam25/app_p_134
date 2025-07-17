import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/assets.dart';

class DeadlineSection extends StatelessWidget {
  final bool isDeadlineSet;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final Function(bool?) onDeadlineChanged;
  final VoidCallback onDateTap;
  final VoidCallback onTimeTap;

  const DeadlineSection({
    Key? key,
    required this.isDeadlineSet,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDeadlineChanged,
    required this.onDateTap,
    required this.onTimeTap,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: isDeadlineSet,
              onChanged: onDeadlineChanged,
              activeColor: AppColors.gren,
            ),
            Text(
              'Set a deadline',
              style: AppTextStyles.header16.copyWith(color: AppColors.black),
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // Date Selection - يظهر فقط عندما يكون الـ checkbox مفعل
        if (isDeadlineSet) ...[
          GestureDetector(
            onTap: onDateTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: const Color(0xffFDFCFD),
                border: Border.all(color: AppColors.gray),
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Row(
                children: [
                  Image.asset(Assets.imagesDate),
                  SizedBox(width: 12.w),
                  Text(
                    selectedDate != null ? _formatDate(selectedDate!) : 'Select date',
                    style: AppTextStyles.header16.copyWith(
                      color: selectedDate != null ? AppColors.black : AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Time Selection - يظهر فقط عندما يكون الـ checkbox مفعل
          GestureDetector(
            onTap: onTimeTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: const Color(0xffFDFCFD),
                border: Border.all(color: AppColors.gray),
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Row(
                children: [ 
                  Image.asset(Assets.imagesTime),
                  SizedBox(width: 12.w),
                  Text(
                    selectedTime != null ? _formatTime(selectedTime!) : 'Select time',
                    style: AppTextStyles.header16.copyWith(
                      color: selectedTime != null ? AppColors.black : AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
