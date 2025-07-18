import 'package:app_p_134/screens/home/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class TransactionsSection extends StatelessWidget {
  const TransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24.h),
      padding:  EdgeInsets.symmetric(horizontal: 26.w, vertical: 15.h),
      decoration: const BoxDecoration(
        color: AppColors.white
    
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transactions',
                style: AppTextStyles.header18.copyWith(
                  color: AppColors.blackLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to all transactions
                },
                child: Row(
                  children: [
                    Text(
                      'See all',
                      style: AppTextStyles.header16.copyWith(
                        color: AppColors.darkPurple,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 4.w),
                     Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                      color: AppColors.darkPurple,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          const TransactionItem(
            title: 'Example entry',
            date: '25.06.2025',
            amount: '\$ +0,01',
            isIncome: true,
          ),
          // Add more transaction items as needed
        ],
      ),
    );
  }
}
