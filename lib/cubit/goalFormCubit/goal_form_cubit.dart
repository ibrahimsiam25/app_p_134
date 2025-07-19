import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/database/local_date.dart';
import '../../models/goal_model.dart';
import '../../cubit/goalCubit/goal_cubit.dart';
import 'goal_form_state.dart';

class GoalFormCubit extends Cubit<GoalFormState> {
  GoalFormCubit() : super(const GoalFormInitialState());

  void initializeWithExistingGoal({
    required double initialGoalAmount,
    DateTime? initialDeadline,
  }) {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    bool isDeadlineSet = false;

    if (initialDeadline != null) {
      selectedDate = DateTime(
        initialDeadline.year,
        initialDeadline.month,
        initialDeadline.day,
      );
      selectedTime = TimeOfDay(
        hour: initialDeadline.hour,
        minute: initialDeadline.minute,
      );
      isDeadlineSet = true;
    }

    emit(GoalFormLoadedState(
      goalAmountText: initialGoalAmount.toStringAsFixed(2),
      selectedDate: selectedDate,
      selectedTime: selectedTime,
      isDeadlineSet: isDeadlineSet,
      isLoading: false,
    ));
  }

  void updateGoalAmount(String amount) {
    emit(state.copyWith(goalAmountText: amount));
  }

  void updateSelectedDate(DateTime? date) {
    emit(state.copyWith(selectedDate: date));
  }

  void updateSelectedTime(TimeOfDay? time) {
    emit(state.copyWith(selectedTime: time));
  }

  void updateDeadlineSet(bool isSet) {
    if (isSet) {
      emit(state.copyWith(isDeadlineSet: isSet));
    } else {
      emit(state.copyWith(
        isDeadlineSet: isSet,
        selectedDate: null,
        selectedTime: null,
      ));
    }
  }

  Future<void> saveGoal(BuildContext context, {VoidCallback? onSuccess}) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(isLoading: true));

    try {
      bool hasExistingGoal = await LocalData.hasGoal();
      
      double amount = double.parse(state.goalAmountText);
      
      DateTime? deadline;
      if (state.selectedDate != null && state.selectedTime != null) {
        deadline = DateTime(
          state.selectedDate!.year,
          state.selectedDate!.month,
          state.selectedDate!.day,
          state.selectedTime!.hour,
          state.selectedTime!.minute,
        );
      }

      final goal = GoalModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: amount,
        deadline: deadline,
        createdAt: DateTime.now(),
      );

      bool success = await LocalData.saveGoal(goal);
      
      if (success) {
        if (context.mounted) {
          context.read<GoalCubit>().refreshState();
        }
        
        emit(GoalFormSuccessState(
          successMessage: hasExistingGoal ? 'Goal updated successfully!' : 'Goal saved successfully!',
          goalAmountText: state.goalAmountText,
          selectedDate: state.selectedDate,
          selectedTime: state.selectedTime,
          isDeadlineSet: state.isDeadlineSet,
          isLoading: false,
        ));

        if (onSuccess != null) {
          onSuccess();
        }
      } else {
        emit(GoalFormErrorState(
          errorMessage: 'Failed to save goal. Please try again.',
          goalAmountText: state.goalAmountText,
          selectedDate: state.selectedDate,
          selectedTime: state.selectedTime,
          isDeadlineSet: state.isDeadlineSet,
          isLoading: false,
        ));
      }
    } catch (e) {
      emit(GoalFormErrorState(
        errorMessage: 'Please enter a valid amount.',
        goalAmountText: state.goalAmountText,
        selectedDate: state.selectedDate,
        selectedTime: state.selectedTime,
        isDeadlineSet: state.isDeadlineSet,
        isLoading: false,
      ));
    }
  }
}
