import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/number_formatter.dart';
import '../../core/database/local_date.dart';
import '../../models/transaction_model.dart';
import '../../models/goal_model.dart';
import '../../widgets/custom_back_app_bar.dart';
import 'widgets/transaction_item.dart';

class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({super.key});

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  List<TransactionModel> allTransactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      List<TransactionModel> transactions = await LocalData.getTransactionsFromGoal();
      
      setState(() {
        allTransactions = transactions;
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
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomBackAppBar(
        title: 'All transactions',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.darkPurple,
              ),
            )
          : allTransactions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 64.sp,
                        color: AppColors.gray,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No transactions yet',
                        style: AppTextStyles.header18.copyWith(
                          color: AppColors.gray,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Add your first income or expense',
                        style: AppTextStyles.header16.copyWith(
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  itemCount: allTransactions.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final transaction = allTransactions[index];
                    return TransactionItem(
                      title: transaction.name,
                      date: formatDate(transaction.date),
                      amount: formatAmount(transaction),
                      isIncome: transaction.isIncome,
                    );
                  },
                ),
    );
  }
}
