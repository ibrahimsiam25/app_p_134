import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../widgets/app_button.dart';


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
    (!_isDeadlineSet || (_selectedDate != null && _selectedTime != null));

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
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.gren,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _showTimePicker() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.gren,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Heads up!',
                style: AppTextStyles.header18.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                'If you exit, you\'ll lose any unsaved work.',
                style: AppTextStyles.header14.copyWith(
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Cancel',
                      onTap: () => Navigator.of(context).pop(),
                      containerColor: AppColors.lightGray,
                      fontColor: AppColors.black,
                      height: 45.h,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: AppButton(
                      text: 'Exit',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      containerColor: AppColors.gren,
                      fontColor: AppColors.black,
                      height: 45.h,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: _onBackPressed,
        ),
        title: Text(
          'Create a goal',
          style: TextStyle(
            fontFamily: AppTextStyles.fontMontserrat,
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
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
                  Text(
                    'Goal amount',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontMontserrat,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Goal Amount Input
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffFDFCFD),
                      border: Border.all(color: AppColors.gray),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: TextField(
                      controller: _goalAmountController,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      style: AppTextStyles.header16.copyWith(color: AppColors.black),
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: AppTextStyles.header16.copyWith(color: AppColors.gray),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 16.w, right: 8.w),
                          child: Icon(
                            Icons.attach_money,
                            color: AppColors.black,
                            size: 20.sp,
                          ),
                        ),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 40.w,
                          minHeight: 20.h,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Set Deadline Section
                  Row(
                    children: [
                      Checkbox(
                        value: _isDeadlineSet,
                        onChanged: (value) {
                          setState(() {
                            _isDeadlineSet = value ?? false;
                            if (!_isDeadlineSet) {
                              _selectedDate = null;
                              _selectedTime = null;
                            }
                          });
                        },
                        activeColor: AppColors.gren,
                      ),
                      Text(
                        'Set a deadline',
                        style: AppTextStyles.header16.copyWith(color: AppColors.black),
                      ),
                    ],
                  ),
                  
                  if (_isDeadlineSet) ...[
                    SizedBox(height: 16.h),
                    
                    // Date Selection
                    GestureDetector(
                      onTap: _showDatePicker,
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xffFDFCFD),
                          border: Border.all(color: AppColors.gray),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, color: AppColors.gray),
                            SizedBox(width: 12.w),
                            Text(
                              _selectedDate != null ? _formatDate(_selectedDate!) : 'Select date',
                              style: AppTextStyles.header16.copyWith(
                                color: _selectedDate != null ? AppColors.black : AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Time Selection
                    GestureDetector(
                      onTap: _showTimePicker,
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xffFDFCFD),
                          border: Border.all(color: AppColors.gray),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: AppColors.gray),
                            SizedBox(width: 12.w),
                            Text(
                              _selectedTime != null ? _formatTime(_selectedTime!) : 'Select time',
                              style: AppTextStyles.header16.copyWith(
                                color: _selectedTime != null ? AppColors.black : AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  
                  const Spacer(),
                  
                  // Save Button
                  AppButton(
                    text: 'Save',
                    onTap: _isFormValid ? () {
                      // Save goal logic here
                      Navigator.of(context).pop();
                    } : null,
                    containerColor: _isFormValid ? AppColors.gren : AppColors.lightGray,
                    fontColor: AppColors.black,
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
