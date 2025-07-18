import 'package:app_p_134/widgets/custom_back_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/database/local_date.dart';
import '../../models/transaction_model.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_snack_bar.dart';
import '../../widgets/exit_dialog.dart';
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
  
  TransactionType _selectedIncomeType = TransactionType.addToGoal;
  bool _hasGoal = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkForExistingGoal();
  }

  @override
  void dispose() {
    _incomeNameController.dispose();
    _incomeAmountController.dispose();
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
    return _incomeNameController.text.isNotEmpty &&
           _incomeAmountController.text.isNotEmpty;
  }

  bool get _hasUnsavedData {
    return _incomeNameController.text.isNotEmpty ||
           _incomeAmountController.text.isNotEmpty;
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

  Future<void> _saveIncome() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_incomeAmountController.text);
      final income = TransactionModel.income(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _incomeNameController.text,
        amount: amount,
        date: DateTime.now(),
      );

      bool success = false;

      if (_hasGoal && _selectedIncomeType == TransactionType.addToGoal) {
        // Add to goal
        success = await LocalData.addIncomeToGoal(income);
      } else {
        // Add to transactions only (create a simple goal with just this income)
        // For now, we'll add to goal anyway since we need to have transactions management
        success = await LocalData.addIncomeToGoal(income);
      }

      if (success) {
        if (mounted) {
          CustomSnackBar.show(
            context,
            message: 'Income added successfully!',
            isSuccess: true,
          );
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          CustomSnackBar.show(
            context,
            message: 'Failed to add income. Please try again.',
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
        title: 'Add Income',
        onBackPressed: _onBackPressed,
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
    setState(() {});  
  },
),

            
            SizedBox(height: 12.h),
            
            // Income Amount Section
            PriceAmountInput(
              title: 'Enter income amount',
              controller: _incomeAmountController,
              focusNode: _amountFocusNode,
              onChanged: () => setState(() {}),
            ),
            
            SizedBox(height: 12.h),
            
            // Income Type Section (only show if user has a goal)
            if (_hasGoal) ...[
              TransactionTypeSelector(
                title: 'Type of income',
                selectedType: _selectedIncomeType,
                onTypeChanged: (type) {
                  setState(() {
                    _selectedIncomeType = type;
                  });
                },
              ),
              SizedBox(height: 40.h),
            ],
            
            const Spacer(),
            
            // Save Button
            AppButton(
              text: _isLoading ? 'Saving...' : 'Save',
              onTap: (_isFormValid && !_isLoading) ? _saveIncome : null,
              containerColor: (_isFormValid && !_isLoading) ? AppColors.gren : AppColors.white,
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

