import 'package:app_p_134/core/constants/app_colors.dart';
import 'package:app_p_134/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

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
              color: isIncome ? AppColors.green : AppColors.red,
            
            ),
          ),
        ],
      ),
    );
  }
}
