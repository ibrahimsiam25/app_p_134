import 'package:app_p_134/widgets/price_amount_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/database/local_date.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_back_app_bar.dart';
import 'widgets/deadline_section.dart';
import 'widgets/create_goal_functions.dart';


class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final TextEditingController _goalAmountController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isDeadlineSet = false; 

  final FocusNode _focusNode = FocusNode();
  
  bool get _isFormValid => CreateGoalFunctions.isFormValid(
    goalAmountText: _goalAmountController.text,
    selectedDate: _selectedDate,
    selectedTime: _selectedTime,
  );

  bool get _hasUnsavedData => CreateGoalFunctions.hasUnsavedData(
    goalAmountText: _goalAmountController.text,
    selectedDate: _selectedDate,
    selectedTime: _selectedTime,
  );

  @override
  void dispose() {
    _goalAmountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

 void _showDatePicker() {
  CreateGoalFunctions.showDatePicker(
    context: context,
    selectedDate: _selectedDate,
    onDateSelected: (DateTime? newDate) {  
      if (newDate != null) {  
        setState(() {
          _selectedDate = newDate;
        });
      }
    
    },
  );
}

  void _showTimePicker() {
    CreateGoalFunctions.showTimePicker(
      context: context,
      selectedTime: _selectedTime,
      onTimeSelected: (TimeOfDay newTime) {
        setState(() {
          _selectedTime = newTime;
        });
      },
    );
  }

  void _onBackPressed() {
    CreateGoalFunctions.handleBackPress(
      context: context,
      hasUnsavedData: _hasUnsavedData,
    );
  }

  Future<void> _saveGoal() async {
    await CreateGoalFunctions.saveGoal(
      context: context,
      goalAmountText: _goalAmountController.text,
      selectedDate: _selectedDate,
      selectedTime: _selectedTime,
      isFormValid: _isFormValid,
      onSuccess: () async {
          await LocalData.clearTransactionsFromCurrentGoal();
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      appBar: CustomBackAppBar(
        title: 'Create a goal',
        onBackPressed: _onBackPressed,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Goal Amount Section
                  PriceAmountInput(
                    title: 'Goal amount',
                    controller: _goalAmountController,
                    focusNode: _focusNode,
                    onChanged: () {
                      setState(() {});
                    },
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Set Deadline Section
                  DeadlineSection(
                    isDeadlineSet: _isDeadlineSet,
                    selectedDate: _selectedDate,
                    selectedTime: _selectedTime,
                    onDeadlineChanged: (bool? value) {
                      setState(() {
                        _isDeadlineSet = value ?? false;
                        if (!_isDeadlineSet) {
                          // عندما يتم إلغاء تفعيل الـ checkbox، امسح التاريخ والوقت
                          _selectedDate = null;
                          _selectedTime = null;
                        }
                      });
                    },
                    onDateTap: _showDatePicker,
                    onTimeTap: _showTimePicker,
                  ),
                  
                  const Spacer(),
                  
                  // Save Button
                  AppButton(
                    text: 'Save',
                    onTap: _isFormValid ? _saveGoal : null,
                    containerColor: _isFormValid ? AppColors.green : AppColors.white,
                    fontColor:_isFormValid ? AppColors.blackLight : AppColors.gray,
                    borderColor:_isFormValid ?null: AppColors.gray,
                    width: double.infinity,
                    height: 60.h,
                  ),
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}
