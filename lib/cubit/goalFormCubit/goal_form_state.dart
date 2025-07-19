import 'package:flutter/material.dart';

abstract class GoalFormState {
  final String goalAmountText;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final bool isDeadlineSet;
  final bool isLoading;

  const GoalFormState({
    required this.goalAmountText,
    required this.selectedDate,
    required this.selectedTime,
    required this.isDeadlineSet,
    required this.isLoading,
  });

  GoalFormState copyWith({
    String? goalAmountText,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    bool? isDeadlineSet,
    bool? isLoading,
  });

  bool get isFormValid => goalAmountText.isNotEmpty && selectedDate != null && selectedTime != null;
  bool get hasUnsavedData => goalAmountText.isNotEmpty || selectedDate != null || selectedTime != null;
}

class GoalFormInitialState extends GoalFormState {
  const GoalFormInitialState({
    super.goalAmountText = '',
    super.selectedDate,
    super.selectedTime,
    super.isDeadlineSet = false,
    super.isLoading = false,
  });

  @override
  GoalFormInitialState copyWith({
    String? goalAmountText,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    bool? isDeadlineSet,
    bool? isLoading,
  }) {
    return GoalFormInitialState(
      goalAmountText: goalAmountText ?? this.goalAmountText,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      isDeadlineSet: isDeadlineSet ?? this.isDeadlineSet,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class GoalFormLoadedState extends GoalFormState {
  const GoalFormLoadedState({
    required super.goalAmountText,
    required super.selectedDate,
    required super.selectedTime,
    required super.isDeadlineSet,
    required super.isLoading,
  });

  @override
  GoalFormLoadedState copyWith({
    String? goalAmountText,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    bool? isDeadlineSet,
    bool? isLoading,
  }) {
    return GoalFormLoadedState(
      goalAmountText: goalAmountText ?? this.goalAmountText,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      isDeadlineSet: isDeadlineSet ?? this.isDeadlineSet,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class GoalFormSuccessState extends GoalFormState {
  final String successMessage;

  const GoalFormSuccessState({
    required this.successMessage,
    required super.goalAmountText,
    required super.selectedDate,
    required super.selectedTime,
    required super.isDeadlineSet,
    required super.isLoading,
  });

  @override
  GoalFormSuccessState copyWith({
    String? goalAmountText,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    bool? isDeadlineSet,
    bool? isLoading,
    String? successMessage,
  }) {
    return GoalFormSuccessState(
      successMessage: successMessage ?? this.successMessage,
      goalAmountText: goalAmountText ?? this.goalAmountText,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      isDeadlineSet: isDeadlineSet ?? this.isDeadlineSet,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class GoalFormErrorState extends GoalFormState {
  final String errorMessage;

  const GoalFormErrorState({
    required this.errorMessage,
    required super.goalAmountText,
    required super.selectedDate,
    required super.selectedTime,
    required super.isDeadlineSet,
    required super.isLoading,
  });

  @override
  GoalFormErrorState copyWith({
    String? goalAmountText,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    bool? isDeadlineSet,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GoalFormErrorState(
      errorMessage: errorMessage ?? this.errorMessage,
      goalAmountText: goalAmountText ?? this.goalAmountText,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      isDeadlineSet: isDeadlineSet ?? this.isDeadlineSet,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
