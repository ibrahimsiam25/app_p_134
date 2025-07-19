import 'package:app_p_134/screens/home/widgets/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/number_formatter.dart';
import '../../cubit/allTransactionsCubit/all_transactions_cubit.dart';
import '../../cubit/allTransactionsCubit/all_transactions_state.dart';
import '../../widgets/custom_back_app_bar.dart';
import '../../widgets/custom_snack_bar.dart';
import 'widgets/transaction_item.dart';



class AllTransactionsScreen extends StatelessWidget {
  const AllTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllTransactionsCubit(),
      child: const _AllTransactionsScreenView(),
    );
  }
}

class _AllTransactionsScreenView extends StatelessWidget {
  const _AllTransactionsScreenView();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AllTransactionsCubit, AllTransactionsState>(
      listener: (context, state) {
        if (state.deleteSuccess == true) {
          CustomSnackBar.show(
            context,
            message: 'Transaction deleted successfully!',
            isSuccess: true,
          );
          context.read<AllTransactionsCubit>().clearDeleteStatus();
        } else if (state.deleteError != null) {
          CustomSnackBar.show(
            context,
            message: state.deleteError!,
            isSuccess: false,
          );
          context.read<AllTransactionsCubit>().clearDeleteStatus();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomBackAppBar(
            title: 'All transactions',
            onBackPressed: () => Navigator.pop(context),
          ),
          body: state.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.darkPurple,
                  ),
                )
              : state.allTransactions.isEmpty
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
                      itemCount: state.allTransactions.length,
                      separatorBuilder: (context, index) => SizedBox(height: 8.h),
                      itemBuilder: (context, index) {
                        final transaction = state.allTransactions[index];
                 
                        final cubit = context.read<AllTransactionsCubit>();
                        
                        return TransactionItem(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (dialogContext) => CustomBottomSheet(
                                onDeletePressed: () async {
                                  Navigator.pop(dialogContext);
                           
                                  await cubit.deleteTransaction(transaction.id);
                                },
                                onCancelPressed: () {
                                  Navigator.pop(dialogContext);
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
      },
    );
  }
}