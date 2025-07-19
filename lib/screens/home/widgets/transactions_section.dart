import 'package:app_p_134/screens/home/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/number_formatter.dart';
import '../../../core/database/local_date.dart';
import '../../../models/transaction_model.dart';
import 'dart:async';


// تحديث TransactionsSection
class TransactionsSection extends StatefulWidget {
  const TransactionsSection({super.key});

  @override
  State<TransactionsSection> createState() => _TransactionsSectionState();
}

class _TransactionsSectionState extends State<TransactionsSection> {
  List<TransactionModel> recentTransactions = [];
  bool isLoading = true;
  StreamSubscription<List<TransactionModel>>? _transactionsSubscription;

  @override
  void initState() {
    super.initState();
    _listenToTransactions();
    _loadRecentTransactions();
  }

  @override
  void dispose() {
    _transactionsSubscription?.cancel();
    super.dispose();
  }

  void _listenToTransactions() {
    _transactionsSubscription = LocalData.transactionsStream.listen((transactions) {
      if (mounted) {
        setState(() {
          recentTransactions = transactions.take(3).toList();
          isLoading = false;
        });
      }
    });
  }

  Future<void> _loadRecentTransactions() async {
    try {
      List<TransactionModel> allTransactions = await LocalData.getTransactions();
 
      setState(() {
        // Show only the first 3 transactions (most recent)
        recentTransactions = allTransactions.take(3).toList();
        isLoading = false;
      });
      
      // Trigger notification to stream listeners after loading
      await LocalData.notifyTransactionsChanged();
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
      width: double.infinity,
      // ارتفاع ديناميكي حسب المحتوى
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.4, // على الأقل 40% من الشاشة
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ياخد المساحة اللي يحتاجها بس
        children: [
          // الـ header
          Padding(
            padding: EdgeInsets.fromLTRB(26.w, 15.h, 26.w, 14.h),
            child: Row(
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
          ),
          
          // محتوى الـ transactions - بدون Expanded أو SingleChildScrollView
          Padding(
            padding: EdgeInsets.fromLTRB(26.w, 0, 26.w, 30.h),
            child: Column(
              children: [
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
          ),
        ],
      ),
    );
  }
}