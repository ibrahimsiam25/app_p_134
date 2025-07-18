import 'package:app_p_134/screens/home/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/number_formatter.dart';
import '../../../core/database/local_date.dart';
import '../../../models/transaction_model.dart';
import '../../../models/goal_model.dart';

class TransactionsSection extends StatefulWidget {
  const TransactionsSection({super.key});

  @override
  State<TransactionsSection> createState() => _TransactionsSectionState();
}

class _TransactionsSectionState extends State<TransactionsSection> {
  List<TransactionModel> recentTransactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentTransactions();
  }

  Future<void> _loadRecentTransactions() async {
    try {
      List<TransactionModel> allTransactions = await LocalData.getTransactionsFromGoal();

      setState(() {
        // Show only the first 3 transactions (most recent)
        recentTransactions = allTransactions.take(3).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading transactions: $e');
      setState(() {
        isLoading = false;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24.h),
      padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 15.h),
      decoration: const BoxDecoration(
        color: AppColors.white,
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
                  Navigator.pushNamed(context, 'allTransactionsScreen');
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
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(
                color: AppColors.darkPurple,
              ),
            )
          else if (recentTransactions.isEmpty)
            TransactionItem(
                title: 'Example entry',
                date: formatDate(DateTime.now()),
                amount: "\$ +0,01",

                isIncome: true,
              )
          else
            ...recentTransactions.map((transaction) => TransactionItem(
                  title: transaction.name,
                  date: formatDate(transaction.date),
                  amount: formatAmount(transaction),
                  isIncome: transaction.isIncome,
                )),
        ],
      ),
    );
  }
}
