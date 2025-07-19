import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/database/local_date.dart';
import '../../../models/goal_model.dart';
import '../../../widgets/custom_snack_bar.dart';
import '../../../widgets/coustom_dialog.dart';
import '../../../cubit/goalCubit/goal_cubit.dart';
import 'date_picker_widget.dart';
import 'time_picker_widget.dart';

class CreateGoalFunctions {
  static void showDatePicker({
  required BuildContext context,
  DateTime? selectedDate,
  required Function(DateTime?) onDateSelected, // خلي الـ function تقبل null
}) async {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime initialDate = selectedDate ?? today;
  
  // Ensure initial date is not before today
  if (initialDate.isBefore(today)) {
    initialDate = today;
  }
  
  DateTime? currentSelectedDate; // متغير لحفظ التاريخ المختار
  
  showCupertinoModalPopup(
    context: context,
    builder: (context) => DatePickerWidget(
      selectedDate: selectedDate,
      onDateSelected: (DateTime date) {
        currentSelectedDate = date; // حفظ التاريخ المختار
      },
      onCancel: () {
        onDateSelected(null); // إرسال null عند الـ Cancel
        Navigator.of(context).pop();
      },
      onDone: () {
        // استخدام التاريخ المختار أو التاريخ الابتدائي
        DateTime finalDate = currentSelectedDate ?? selectedDate ?? today;
        onDateSelected(finalDate);
        Navigator.of(context).pop();
      },
    ),
  );
}

 static void showTimePicker({
  required BuildContext context,
  TimeOfDay? selectedTime,
  required Function(TimeOfDay) onTimeSelected,
}) async {
  TimeOfDay? currentSelectedTime; // متغير لحفظ الوقت المختار
  
  showCupertinoModalPopup(
    context: context,
    builder: (context) => TimePickerWidget(
      selectedTime: selectedTime,
      onTimeSelected: (TimeOfDay time) {
        currentSelectedTime = time; // حفظ الوقت المختار
      },
      onCancel: () => Navigator.of(context).pop(),
      onDone: () {
        // استخدام الوقت المختار أو الوقت الابتدائي
        TimeOfDay finalTime = currentSelectedTime ?? selectedTime ?? TimeOfDay.now();
        onTimeSelected(finalTime);
        Navigator.of(context).pop();
      },
    ),
  );
}


  // Show exit confirmation dialog
  static void showCoustomDialog({
    required BuildContext context,
    required VoidCallback onExit,
  }) {
    showDialog(
      context: context,
      builder: (context) => CoustomDialog(
        title: 'Heads up!',
        message: 'If you exit, you\'ll lose any unsaved work.',
           primaryLabel:"Exit", 
          secondaryLabel: "Cancel",
        onSecondary: () => Navigator.of(context).pop(),
        onPrimary: () {
          Navigator.of(context).pop();
          onExit();
        },
      ),
    );
  }

  // Show replace goal confirmation dialog
  static Future<bool> showReplaceGoalDialog({
    required BuildContext context,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Replace Existing Goal?'),
        content: const Text(
          'You already have a goal. Creating a new goal will replace your current one. Do you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Replace',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  // Handle back button press with unsaved data check
  static void handleBackPress({
    required BuildContext context,
    required bool hasUnsavedData,
  }) {
    if (hasUnsavedData) {
      showCoustomDialog(
        context: context,
        onExit: () => Navigator.of(context).pop(),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  // Save goal with validation and confirmation
  static Future<void> saveGoal({
    required BuildContext context,
    required String goalAmountText,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    required bool isFormValid,
    VoidCallback? onSuccess,
  }) async {
    if (!isFormValid) return;

    try {
      // Check if user already has a goal
      bool hasExistingGoal = await LocalData.hasGoal();
      
    

      // Parse the goal amount
      double amount = double.parse(goalAmountText);
      
      // Combine date and time for deadline
      DateTime? deadline;
      if (selectedDate != null && selectedTime != null) {
        deadline = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }

      // Create goal model (this will replace any existing goal)
      final goal = GoalModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: amount,
        deadline: deadline,
        createdAt: DateTime.now(),
      );

      // Save goal to local storage (replaces any existing goal)
      bool success = await LocalData.saveGoal(goal);
      
      if (success) {
        // Refresh the GoalCubit state
        if (context.mounted) {
          context.read<GoalCubit>().refreshState();
        }
        
        // Show success message
        CustomSnackBar.show(
          context,
          message: hasExistingGoal ? 'Goal updated successfully!' : 'Goal saved successfully!',
          isSuccess: true,
        );
        
        // Call success callback if provided, otherwise navigate back
        if (onSuccess != null) {
          onSuccess();
        } else {
          Navigator.of(context).pop();
        }
      } else {
        // Show error message
        CustomSnackBar.show(
          context,
          message: 'Failed to save goal. Please try again.',
          isError: true,
        );
      }
    } catch (e) {
      // Show error message for invalid input
      CustomSnackBar.show(
        context,
        message: 'Please enter a valid amount.',
        isError: true,
      );
    }
  }

  // Validate form inputs
  static bool isFormValid({
    required String goalAmountText,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
  }) {
    return goalAmountText.isNotEmpty && 
           selectedDate != null && 
           selectedTime != null;
  }

  // Check if user has unsaved data
  static bool hasUnsavedData({
    required String goalAmountText,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
  }) {
    return goalAmountText.isNotEmpty || 
           selectedDate != null || 
           selectedTime != null;
  }
}
