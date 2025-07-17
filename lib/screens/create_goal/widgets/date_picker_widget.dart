import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class DatePickerWidget extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final VoidCallback onCancel;
  final VoidCallback onDone;

  const DatePickerWidget({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onCancel,
    required this.onDone,
  }) : super(key: key);

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late DateTime currentSelectedDate;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    
    // If no date is selected, start with today's date
    // Otherwise, use the selected date as is (no restrictions)
    if (widget.selectedDate == null) {
      currentSelectedDate = today;
    } else {
      currentSelectedDate = widget.selectedDate!;
    }
    
    // إرسال القيمة الابتدائية للـ parent widget عند فتح الـ picker
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateSelected(currentSelectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      padding: EdgeInsets.only(top: 6.h),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header with Cancel and Done buttons
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: const BoxDecoration(
                color: AppColors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: widget.onCancel,
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.header16.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.blue
                      ),
                    ),
                  ),
                  Text(
                    'Select Date',
                    style: AppTextStyles.header16.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none, 
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      // إرسال القيمة الحالية (الابتدائية أو المختارة) عند الضغط على Done
                      widget.onDateSelected(currentSelectedDate);
                      widget.onDone();
                    },
                    child: Text(
                      'Done',
                      style: AppTextStyles.header16.copyWith(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Date Picker without selection lines
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: currentSelectedDate,
                maximumDate: DateTime(2030),
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    currentSelectedDate = newDate;
                  });
                  // إرسال التاريخ المختار مباشرة للـ parent widget
                  widget.onDateSelected(newDate);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
