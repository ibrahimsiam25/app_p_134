import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/number_formatter.dart';
import '../../core/database/local_date.dart';
import '../../models/transaction_model.dart';
import '../../widgets/custom_back_app_bar.dart';
import '../../widgets/custom_snack_bar.dart';
import 'widgets/transaction_item.dart';
import 'dart:async';

class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({super.key});

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  List<TransactionModel> allTransactions = [];
  bool isLoading = true;
  StreamSubscription<List<TransactionModel>>? _transactionsSubscription;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _listenToTransactions();
  }

  @override
  void dispose() {
    _transactionsSubscription?.cancel();
    super.dispose();
  }

  void _listenToTransactions() {
    _transactionsSubscription = LocalData.transactionsStream.listen((transactions) {
      print('AllTransactionsScreen: Received ${transactions.length} transactions');
      if (mounted) {
        setState(() {
          allTransactions = transactions;
          isLoading = false;
        });
      }
    });
  }

  Future<void> _loadTransactions() async {
    try {
      List<TransactionModel> transactions = await LocalData.getTransactions();
      
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

  Future<void> _deleteTransaction(String transactionId) async {
    try {
      LocalData.deleteTransaction(transactionId);
      
      // Show success message
      CustomSnackBar.show(
        context,
        message: 'Transaction deleted successfully!',
        isSuccess: true,
      );
      
      // The UI will automatically update through the stream listener
    } catch (e) {
      print('Error deleting transaction: $e');
      
      // Show error message
      CustomSnackBar.show(
        context,
        message: 'Failed to delete transaction. Please try again.',
        isSuccess: false,
      );
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
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) => CustomBottomSheet(
                            onDeletePressed: () async {
                              Navigator.pop(context); // Close bottom sheet first
                              await _deleteTransaction(transaction.id);
                            },
                            onCancelPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
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


class CustomBottomSheet extends StatelessWidget {
  final VoidCallback? onDeletePressed;
  final VoidCallback? onCancelPressed;

  const CustomBottomSheet({
    super.key,
    this.onDeletePressed,
    this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal:8.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // First container with Options, Delete transaction, and Delete button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              children: [
                // Options title
                Text(
                  'Options',
                  style: AppTextStyles.header13.copyWith(
                   fontSize: 13.sp,
                    fontWeight: FontWeight.w600, // 590 closest to w600
                 
                    color: AppColors.darkGray.withOpacity(0.5),
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                // Delete transaction text
                Text(
                  'Delete transaction',
                  style: AppTextStyles.header13.copyWith(
              
                    fontWeight: FontWeight.w400, // Regular
              
                    color: AppColors.darkGray.withOpacity(0.5),
                  ),
                ),
                
                SizedBox(height: 20.h),
                
                // Divider line
                Container(
                  height: 1.h,
                  color: AppColors.gray.withOpacity(0.3),
                ),
                
                SizedBox(height: 20.h),
                
                // Delete button (as text, not elevated button)
                GestureDetector(
                  onTap: onDeletePressed ?? () => Navigator.pop(context),
                  child: Text(
                    'Delete',
                    style: AppTextStyles.header17.copyWith(
                      color: AppColors. brightRed,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // Second container with Cancel button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: GestureDetector(
              onTap: onCancelPressed ?? () => Navigator.pop(context),
              child: Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: AppTextStyles.header17.copyWith(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
