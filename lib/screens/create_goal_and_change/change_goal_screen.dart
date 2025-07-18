import 'package:app_p_134/widgets/price_amount_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_back_app_bar.dart';
import 'widgets/deadline_section.dart';
import 'widgets/create_goal_functions.dart';


class  ChangeGoalScreen extends StatefulWidget {
  const ChangeGoalScreen({super.key, required this.initialGoalAmount, this.initialDeadline});
  final double initialGoalAmount;
  final DateTime? initialDeadline;
  @override
  State<ChangeGoalScreen> createState() => _ChangeGoalScreenState();
}

class _ChangeGoalScreenState extends State<ChangeGoalScreen> {
   late final TextEditingController _goalAmountController;
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
  void initState() {
    super.initState();

    _goalAmountController =
        TextEditingController(text: widget.initialGoalAmount.toStringAsFixed(2));

    if (widget.initialDeadline != null) {
      _selectedDate = DateTime(
        widget.initialDeadline!.year,
        widget.initialDeadline!.month,
        widget.initialDeadline!.day,
      );
      _selectedTime = TimeOfDay(
        hour: widget.initialDeadline!.hour,
        minute: widget.initialDeadline!.minute,
      );
      _isDeadlineSet = true;
    }
  }

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
      onDateSelected: (DateTime newDate) {
        setState(() {
          _selectedDate = newDate;
        });
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

  Future<void> _updateGoal() async {
    await CreateGoalFunctions.saveGoal(
      context: context,
      goalAmountText: _goalAmountController.text,
      selectedDate: _selectedDate,
      selectedTime: _selectedTime,
      isFormValid: _isFormValid,
      onSuccess: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomBackAppBar(
        title: 'Change a goal',
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
                  // Goal Amount
                  PriceAmountInput(
                    title: 'Goal amount',
                    controller: _goalAmountController,
                    focusNode: _focusNode,
                    onChanged: () {
                      setState(() {});
                    },
                  ),

                  SizedBox(height: 32.h),

                  // Deadline
                  DeadlineSection(
                    isDeadlineSet: _isDeadlineSet,
                    selectedDate: _selectedDate,
                    selectedTime: _selectedTime,
                    onDeadlineChanged: (bool? value) {
                      setState(() {
                        _isDeadlineSet = value ?? false;
                        if (!_isDeadlineSet) {
                          _selectedDate = null;
                          _selectedTime = null;
                        }
                      });
                    },
                    onDateTap: _showDatePicker,
                    onTimeTap: _showTimePicker,
                  ),

                  const Spacer(),

                  // Save button
                  AppButton(
                    text: 'Update',
                    onTap: _isFormValid ? _updateGoal : null,
                    containerColor: _isFormValid ? AppColors.green : AppColors.white,
                    fontColor: _isFormValid ? AppColors.blackLight : AppColors.gray,
                    borderColor: _isFormValid ? null : AppColors.gray,
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
