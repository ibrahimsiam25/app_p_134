import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/database/local_date.dart';
import '../../models/goal_model.dart';
import '../../widgets/app_button.dart';
import 'widgets/date_picker_widget.dart';
import 'widgets/time_picker_widget.dart';
import 'widgets/exit_dialog.dart';
import 'widgets/goal_amount_input.dart';
import 'widgets/deadline_section.dart';
import 'widgets/custom_app_bar.dart';


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
  
  bool get _isFormValid => 
    _goalAmountController.text.isNotEmpty && 
    ( _selectedDate != null && _selectedTime != null);

  bool get _hasUnsavedData => 
    _goalAmountController.text.isNotEmpty || 
    _selectedDate != null || 
    _selectedTime != null;

  @override
  void dispose() {
    _goalAmountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showDatePicker() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime initialDate = _selectedDate ?? today;
    
    // Ensure initial date is not before today
    if (initialDate.isBefore(today)) {
      initialDate = today;
    }
    
    showCupertinoModalPopup(
      context: context,
      builder: (context) => DatePickerWidget(
        selectedDate: _selectedDate,
        onDateSelected: (DateTime newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
        onCancel: () => Navigator.of(context).pop(),
        onDone: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showTimePicker() async {
    TimeOfDay initialTime = _selectedTime ?? TimeOfDay.now();
    DateTime initialDateTime = DateTime.now().copyWith(
      hour: initialTime.hour,
      minute: initialTime.minute,
    );
    
    showCupertinoModalPopup(
      context: context,
      builder: (context) => TimePickerWidget(
        selectedTime: _selectedTime,
        onTimeSelected: (TimeOfDay newTime) {
          setState(() {
            _selectedTime = newTime;
          });
        },
        onCancel: () => Navigator.of(context).pop(),
        onDone: () {
          // حفظ القيمة الافتراضية إذا لم يتم اختيار شيء
          if (_selectedTime == null) {
            setState(() {
              _selectedTime = TimeOfDay(
                hour: initialDateTime.hour,
                minute: initialDateTime.minute,
              );
            });
          }
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => ExitDialog(
        onCancel: () => Navigator.of(context).pop(),
        onExit: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _onBackPressed() {
    if (_hasUnsavedData) {
      _showExitDialog();
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveGoal() async {
    if (!_isFormValid) return;

    try {
      // Parse the goal amount
      double amount = double.parse(_goalAmountController.text);
      
      // Combine date and time for deadline
      DateTime? deadline;
      if (_selectedDate != null && _selectedTime != null) {
        deadline = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );
      }

      // Create goal model
      final goal = GoalModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: amount,
        deadline: deadline,
        createdAt: DateTime.now(),
      );

      // Save goal to local storage
      bool success = await LocalData.saveGoal(goal);
      
      if (success) {
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Goal saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Navigate back
          Navigator.of(context).pop();
        }
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save goal. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Show error message for invalid input
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid amount.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
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
                  GoalAmountInput(
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
                    containerColor: _isFormValid ? AppColors.gren : AppColors.white,
                    fontColor:_isFormValid ? AppColors.black : AppColors.gray,
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
