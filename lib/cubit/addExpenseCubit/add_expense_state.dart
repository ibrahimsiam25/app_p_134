import '../../screens/add _income_and_expense/widgets/transaction_type_selector.dart';

abstract class AddExpenseState {
  final String expenseName;
  final String expenseAmount;
  final TransactionType selectedExpenseType;
  final bool hasGoal;
  final bool isLoading;

  const AddExpenseState({
    required this.expenseName,
    required this.expenseAmount,
    required this.selectedExpenseType,
    required this.hasGoal,
    required this.isLoading,
  });

  AddExpenseState copyWith({
    String? expenseName,
    String? expenseAmount,
    TransactionType? selectedExpenseType,
    bool? hasGoal,
    bool? isLoading,
  });

  bool get isFormValid => expenseName.isNotEmpty && expenseAmount.isNotEmpty;
  bool get hasUnsavedData => expenseName.isNotEmpty || expenseAmount.isNotEmpty;
}

class AddExpenseInitialState extends AddExpenseState {
  const AddExpenseInitialState({
    super.expenseName = '',
    super.expenseAmount = '',
    super.selectedExpenseType = TransactionType.addToGoal,
    super.hasGoal = false,
    super.isLoading = false,
  });

  @override
  AddExpenseInitialState copyWith({
    String? expenseName,
    String? expenseAmount,
    TransactionType? selectedExpenseType,
    bool? hasGoal,
    bool? isLoading,
  }) {
    return AddExpenseInitialState(
      expenseName: expenseName ?? this.expenseName,
      expenseAmount: expenseAmount ?? this.expenseAmount,
      selectedExpenseType: selectedExpenseType ?? this.selectedExpenseType,
      hasGoal: hasGoal ?? this.hasGoal,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AddExpenseSuccessState extends AddExpenseState {
  const AddExpenseSuccessState({
    required super.expenseName,
    required super.expenseAmount,
    required super.selectedExpenseType,
    required super.hasGoal,
    required super.isLoading,
  });

  @override
  AddExpenseSuccessState copyWith({
    String? expenseName,
    String? expenseAmount,
    TransactionType? selectedExpenseType,
    bool? hasGoal,
    bool? isLoading,
  }) {
    return AddExpenseSuccessState(
      expenseName: expenseName ?? this.expenseName,
      expenseAmount: expenseAmount ?? this.expenseAmount,
      selectedExpenseType: selectedExpenseType ?? this.selectedExpenseType,
      hasGoal: hasGoal ?? this.hasGoal,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AddExpenseErrorState extends AddExpenseState {
  final String errorMessage;

  const AddExpenseErrorState({
    required this.errorMessage,
    required super.expenseName,
    required super.expenseAmount,
    required super.selectedExpenseType,
    required super.hasGoal,
    required super.isLoading,
  });

  @override
  AddExpenseErrorState copyWith({
    String? expenseName,
    String? expenseAmount,
    TransactionType? selectedExpenseType,
    bool? hasGoal,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AddExpenseErrorState(
      errorMessage: errorMessage ?? this.errorMessage,
      expenseName: expenseName ?? this.expenseName,
      expenseAmount: expenseAmount ?? this.expenseAmount,
      selectedExpenseType: selectedExpenseType ?? this.selectedExpenseType,
      hasGoal: hasGoal ?? this.hasGoal,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
