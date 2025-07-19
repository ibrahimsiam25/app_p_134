import '../../screens/add _income_and_expense/widgets/transaction_type_selector.dart';

abstract class AddIncomeState {
  final String incomeName;
  final String incomeAmount;
  final TransactionType selectedIncomeType;
  final bool hasGoal;
  final bool isLoading;

  const AddIncomeState({
    required this.incomeName,
    required this.incomeAmount,
    required this.selectedIncomeType,
    required this.hasGoal,
    required this.isLoading,
  });

  AddIncomeState copyWith({
    String? incomeName,
    String? incomeAmount,
    TransactionType? selectedIncomeType,
    bool? hasGoal,
    bool? isLoading,
  });

  bool get isFormValid => incomeName.isNotEmpty && incomeAmount.isNotEmpty;
  bool get hasUnsavedData => incomeName.isNotEmpty || incomeAmount.isNotEmpty;
}

class AddIncomeInitialState extends AddIncomeState {
  const AddIncomeInitialState({
    super.incomeName = '',
    super.incomeAmount = '',
    super.selectedIncomeType = TransactionType.addToGoal,
    super.hasGoal = false,
    super.isLoading = false,
  });

  @override
  AddIncomeInitialState copyWith({
    String? incomeName,
    String? incomeAmount,
    TransactionType? selectedIncomeType,
    bool? hasGoal,
    bool? isLoading,
  }) {
    return AddIncomeInitialState(
      incomeName: incomeName ?? this.incomeName,
      incomeAmount: incomeAmount ?? this.incomeAmount,
      selectedIncomeType: selectedIncomeType ?? this.selectedIncomeType,
      hasGoal: hasGoal ?? this.hasGoal,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AddIncomeSuccessState extends AddIncomeState {
  const AddIncomeSuccessState({
    required super.incomeName,
    required super.incomeAmount,
    required super.selectedIncomeType,
    required super.hasGoal,
    required super.isLoading,
  });

  @override
  AddIncomeSuccessState copyWith({
    String? incomeName,
    String? incomeAmount,
    TransactionType? selectedIncomeType,
    bool? hasGoal,
    bool? isLoading,
  }) {
    return AddIncomeSuccessState(
      incomeName: incomeName ?? this.incomeName,
      incomeAmount: incomeAmount ?? this.incomeAmount,
      selectedIncomeType: selectedIncomeType ?? this.selectedIncomeType,
      hasGoal: hasGoal ?? this.hasGoal,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AddIncomeErrorState extends AddIncomeState {
  final String errorMessage;

  const AddIncomeErrorState({
    required this.errorMessage,
    required super.incomeName,
    required super.incomeAmount,
    required super.selectedIncomeType,
    required super.hasGoal,
    required super.isLoading,
  });

  @override
  AddIncomeErrorState copyWith({
    String? incomeName,
    String? incomeAmount,
    TransactionType? selectedIncomeType,
    bool? hasGoal,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AddIncomeErrorState(
      errorMessage: errorMessage ?? this.errorMessage,
      incomeName: incomeName ?? this.incomeName,
      incomeAmount: incomeAmount ?? this.incomeAmount,
      selectedIncomeType: selectedIncomeType ?? this.selectedIncomeType,
      hasGoal: hasGoal ?? this.hasGoal,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
