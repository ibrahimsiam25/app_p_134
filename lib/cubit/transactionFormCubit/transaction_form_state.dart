import '../../screens/add _income_and_expense/widgets/transaction_type_selector.dart';

enum TransactionFormType { income, expense }

abstract class TransactionFormState {
  final String transactionName;
  final String transactionAmount;
  final TransactionType selectedTransactionType;
  final bool hasGoal;
  final bool isLoading;
  final TransactionFormType formType;

  const TransactionFormState({
    required this.transactionName,
    required this.transactionAmount,
    required this.selectedTransactionType,
    required this.hasGoal,
    required this.isLoading,
    required this.formType,
  });

  TransactionFormState copyWith({
    String? transactionName,
    String? transactionAmount,
    TransactionType? selectedTransactionType,
    bool? hasGoal,
    bool? isLoading,
    TransactionFormType? formType,
  });

  bool get isFormValid => transactionName.isNotEmpty && transactionAmount.isNotEmpty;
  bool get hasUnsavedData => transactionName.isNotEmpty || transactionAmount.isNotEmpty;
}

class TransactionFormInitialState extends TransactionFormState {
  const TransactionFormInitialState({
    super.transactionName = '',
    super.transactionAmount = '',
    super.selectedTransactionType = TransactionType.addToGoal,
    super.hasGoal = false,
    super.isLoading = false,
    required super.formType,
  });

  @override
  TransactionFormInitialState copyWith({
    String? transactionName,
    String? transactionAmount,
    TransactionType? selectedTransactionType,
    bool? hasGoal,
    bool? isLoading,
    TransactionFormType? formType,
  }) {
    return TransactionFormInitialState(
      transactionName: transactionName ?? this.transactionName,
      transactionAmount: transactionAmount ?? this.transactionAmount,
      selectedTransactionType: selectedTransactionType ?? this.selectedTransactionType,
      hasGoal: hasGoal ?? this.hasGoal,
      isLoading: isLoading ?? this.isLoading,
      formType: formType ?? this.formType,
    );
  }
}

class TransactionFormSuccessState extends TransactionFormState {
  const TransactionFormSuccessState({
    required super.transactionName,
    required super.transactionAmount,
    required super.selectedTransactionType,
    required super.hasGoal,
    required super.isLoading,
    required super.formType,
  });

  @override
  TransactionFormSuccessState copyWith({
    String? transactionName,
    String? transactionAmount,
    TransactionType? selectedTransactionType,
    bool? hasGoal,
    bool? isLoading,
    TransactionFormType? formType,
  }) {
    return TransactionFormSuccessState(
      transactionName: transactionName ?? this.transactionName,
      transactionAmount: transactionAmount ?? this.transactionAmount,
      selectedTransactionType: selectedTransactionType ?? this.selectedTransactionType,
      hasGoal: hasGoal ?? this.hasGoal,
      isLoading: isLoading ?? this.isLoading,
      formType: formType ?? this.formType,
    );
  }
}

class TransactionFormErrorState extends TransactionFormState {
  final String errorMessage;

  const TransactionFormErrorState({
    required this.errorMessage,
    required super.transactionName,
    required super.transactionAmount,
    required super.selectedTransactionType,
    required super.hasGoal,
    required super.isLoading,
    required super.formType,
  });

  @override
  TransactionFormErrorState copyWith({
    String? transactionName,
    String? transactionAmount,
    TransactionType? selectedTransactionType,
    bool? hasGoal,
    bool? isLoading,
    TransactionFormType? formType,
    String? errorMessage,
  }) {
    return TransactionFormErrorState(
      errorMessage: errorMessage ?? this.errorMessage,
      transactionName: transactionName ?? this.transactionName,
      transactionAmount: transactionAmount ?? this.transactionAmount,
      selectedTransactionType: selectedTransactionType ?? this.selectedTransactionType,
      hasGoal: hasGoal ?? this.hasGoal,
      isLoading: isLoading ?? this.isLoading,
      formType: formType ?? this.formType,
    );
  }
}
