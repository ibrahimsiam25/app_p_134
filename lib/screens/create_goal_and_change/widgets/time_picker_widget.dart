import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class TimePickerWidget extends StatefulWidget {
  final TimeOfDay? selectedTime;
  final Function(TimeOfDay) onTimeSelected;
  final VoidCallback onCancel;
  final VoidCallback onDone;

  const TimePickerWidget({
    super.key,
    required this.selectedTime,
    required this.onTimeSelected,
    required this.onCancel,
    required this.onDone,
  });

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  late TimeOfDay currentSelectedTime;

  @override
  void initState() {
    super.initState();
    
    // If no time is selected, start with current time
    // Otherwise, use the selected time
    currentSelectedTime = widget.selectedTime ?? TimeOfDay.now();
    
   
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onTimeSelected(currentSelectedTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime initialDateTime = DateTime.now().copyWith(
      hour: currentSelectedTime.hour,
      minute: currentSelectedTime.minute,
    );

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
                    'Select Time',
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
                      widget.onTimeSelected(currentSelectedTime);
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
            // Time Picker without selection lines
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: initialDateTime,
                use24hFormat: true,
                onDateTimeChanged: (DateTime newDateTime) {
                  TimeOfDay newTime = TimeOfDay(
                    hour: newDateTime.hour,
                    minute: newDateTime.minute,
                  );
                  setState(() {
                    currentSelectedTime = newTime;
                  });
               
                  widget.onTimeSelected(newTime);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
