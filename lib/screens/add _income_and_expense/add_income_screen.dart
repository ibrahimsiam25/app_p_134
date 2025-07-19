import 'package:app_p_134/widgets/custom_back_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../cubit/transactionFormCubit/transaction_form_cubit.dart';
import '../../cubit/transactionFormCubit/transaction_form_state.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_snack_bar.dart';
import '../../widgets/coustom_dialog.dart';
import '../../widgets/price_amount_input.dart';
import 'widgets/text_input.dart';
import 'widgets/transaction_type_selector.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}
class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final TextEditingController _incomeNameController = TextEditingController();
  final TextEditingController _incomeAmountController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();

  @override
  void dispose() {
    _incomeNameController.dispose();
    _incomeAmountController.dispose();
    _nameFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _onBackPressed(TransactionFormState state) {
    if (state.hasUnsavedData) {
      showDialog(
        context: context,
        builder: (context) => CoustomDialog(
          title: 'Heads up!',
          message: 'If you exit, you\'ll lose any unsaved work.',
          primaryLabel: "Exit",
          secondaryLabel: "Cancel",
          onSecondary: () => Navigator.of(context).pop(),
          onPrimary: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionFormCubit(TransactionFormType.income)..initialize(),
      child: BlocConsumer<TransactionFormCubit, TransactionFormState>(
        listener: (context, state) {
          if (state is TransactionFormSuccessState) {
            CustomSnackBar.show(
              context,
              message: 'Income added successfully!',
              isSuccess: true,
            );
            Navigator.of(context).pop();
          } else if (state is TransactionFormErrorState) {
            CustomSnackBar.show(
              context,
              message: state.errorMessage,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.white,
            appBar: CustomBackAppBar(
              title: 'Add Income',
              onBackPressed: () => _onBackPressed(state),
            ),
            body: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  
                  TextInput(
                    title: 'Enter income name',
                    hintText: 'Name',
                    controller: _incomeNameController,
                    focusNode: _nameFocusNode,
                    onChanged: () {
                      context.read<TransactionFormCubit>().updateTransactionName(_incomeNameController.text);
                    },
                  ),

                  SizedBox(height: 12.h),
                  
                  PriceAmountInput(
                    title: 'Enter income amount',
                    controller: _incomeAmountController,
                    focusNode: _amountFocusNode,
                    onChanged: () => context.read<TransactionFormCubit>().updateTransactionAmount(_incomeAmountController.text),
                  ),
                  
                  SizedBox(height: 12.h),
                  
                  if (state.hasGoal) ...[
                    TransactionTypeSelector(
                      title: 'Type of income',
                      selectedType: state.selectedTransactionType,
                      onTypeChanged: (type) {
                        context.read<TransactionFormCubit>().updateSelectedTransactionType(type);
                      },
                    ),
                    SizedBox(height: 40.h),
                  ],
                  
                  const Spacer(),
                  
                  AppButton(
                    text: state.isLoading ? 'Saving...' : 'Save',
                    onTap: (state.isFormValid && !state.isLoading) ? () => context.read<TransactionFormCubit>().saveTransaction() : null,
                    containerColor: (state.isFormValid && !state.isLoading) ? AppColors.green : AppColors.white,
                    fontColor: (state.isFormValid && !state.isLoading) ? AppColors.blackLight : AppColors.gray,
                    borderColor: (state.isFormValid && !state.isLoading) ? null : AppColors.gray,
                    width: double.infinity,
                    height: 60.h,
                  ),
                  
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

