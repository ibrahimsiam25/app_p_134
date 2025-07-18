import 'package:app_p_134/widgets/custom_back_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/database/local_date.dart';
import '../../models/transaction_model.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_snack_bar.dart';
import '../../widgets/coustom_dialog.dart';
import '../../widgets/price_amount_input.dart';
import 'widgets/text_input.dart';
import 'widgets/transaction_type_selector.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _expenseNameController = TextEditingController();
  final TextEditingController _expenseAmountController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();
  
  TransactionType _selectedExpenseType = TransactionType.addToGoal;
  bool _hasGoal = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkForExistingGoal();
  }

  @override
  void dispose() {
    _expenseNameController.dispose();
    _expenseAmountController.dispose();
    _nameFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  Future<void> _checkForExistingGoal() async {
    try {
      final hasGoal = await LocalData.hasGoal();
      setState(() {
        _hasGoal = hasGoal;
      });
    } catch (e) {
      // Handle error silently
    }
  }

  bool get _isFormValid {
    return _expenseNameController.text.isNotEmpty &&
           _expenseAmountController.text.isNotEmpty;
  }

  bool get _hasUnsavedData {
    return _expenseNameController.text.isNotEmpty ||
           _expenseAmountController.text.isNotEmpty;
  }

  void _onBackPressed() {
    if (_hasUnsavedData) {
      showDialog(
        context: context,
        builder: (context) => ExitDialog(
          title: 'Heads up!',
          message: 'If you exit, you\'ll lose any unsaved work.',
          onCancel: () => Navigator.of(context).pop(),
          onAction: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveExpense() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_expenseAmountController.text);
      final expense = TransactionModel.expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _expenseNameController.text,
        amount: amount,
        date: DateTime.now(),
      );

      bool success = false;

    success = await LocalData.addExpense(expense);

      if (success) {
        if (mounted) {
          CustomSnackBar.show(
            context,
            message: 'Expense added successfully!',
            isSuccess: true,
          );
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          CustomSnackBar.show(
            context,
            message: 'Failed to add expense. Please try again.',
            isError: true,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.show(
          context,
          message: 'Please enter a valid amount.',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomBackAppBar(
        title: 'Add Expense',
        onBackPressed: _onBackPressed,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            
            TextInput(
              title: 'Enter expense name',
              hintText: 'Name',
              controller: _expenseNameController,
              focusNode: _nameFocusNode,
              onChanged: () {
                setState(() {});  
              },
            ),

            SizedBox(height: 12.h),
            
            // Expense Amount Section
            PriceAmountInput(
              title: 'Enter expense amount',
              controller: _expenseAmountController,
              focusNode: _amountFocusNode,
              onChanged: () => setState(() {}),
            ),
            
            SizedBox(height: 12.h),
            
            // Expense Type Section (only show if user has a goal)
            if (_hasGoal) ...[
              TransactionTypeSelector(
                title: 'Type of expense',
                selectedType: _selectedExpenseType,
                onTypeChanged: (type) {
                  setState(() {
                    _selectedExpenseType = type;
                  });
                },
              ),
              SizedBox(height: 40.h),
            ],
            
            const Spacer(),
            
            // Save Button
            AppButton(
              text: _isLoading ? 'Saving...' : 'Save',
              onTap: (_isFormValid && !_isLoading) ? _saveExpense : null,
              containerColor: (_isFormValid && !_isLoading) ? AppColors.green : AppColors.white,
              fontColor: (_isFormValid && !_isLoading) ? AppColors.blackLight : AppColors.gray,
              borderColor: (_isFormValid && !_isLoading) ? null : AppColors.gray,
              width: double.infinity,
              height: 60.h,
            ),
            
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
