import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final bool isIncome;
  
  const TransactionItem({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.header16.copyWith(
                    color: AppColors.blackLight,
                  
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  date,
                  style: AppTextStyles.header14.copyWith(
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: AppTextStyles.header16.copyWith(
              color: isIncome ? AppColors.gren : AppColors.red,
            
            ),
          ),
        ],
      ),
    );
  }
}

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
