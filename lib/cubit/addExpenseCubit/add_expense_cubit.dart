import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/database/local_date.dart';
import '../../models/transaction_model.dart';
import '../../screens/add _income_and_expense/widgets/transaction_type_selector.dart';
import 'add_expense_state.dart';

class AddExpenseCubit extends Cubit<AddExpenseState> {
  AddExpenseCubit() : super(const AddExpenseInitialState());

  Future<void> initialize() async {
    try {
      final hasGoal = await LocalData.hasGoal();
      emit(state.copyWith(hasGoal: hasGoal));
    } catch (e) {
      // Handle error silently
    }
  }

  void updateExpenseName(String name) {
    emit(state.copyWith(expenseName: name));
  }

  void updateExpenseAmount(String amount) {
    emit(state.copyWith(expenseAmount: amount));
  }

  void updateSelectedExpenseType(TransactionType type) {
    emit(state.copyWith(selectedExpenseType: type));
  }

  Future<void> saveExpense() async {
    if (!state.isFormValid) return;

    emit(state.copyWith(isLoading: true));

    try {
      final amount = double.parse(state.expenseAmount);
      final expense = TransactionModel.expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: state.expenseName,
        amount: amount,
        date: DateTime.now(),
        isFromCurrentGoal: (state.selectedExpenseType == TransactionType.addToGoal) && state.hasGoal,
      );

      bool success = await LocalData.addExpense(expense);

      if (success) {
        emit(AddExpenseSuccessState(
          expenseName: state.expenseName,
          expenseAmount: state.expenseAmount,
          selectedExpenseType: state.selectedExpenseType,
          hasGoal: state.hasGoal,
          isLoading: false,
        ));
      } else {
        emit(AddExpenseErrorState(
          errorMessage: 'Failed to add expense. Please try again.',
          expenseName: state.expenseName,
          expenseAmount: state.expenseAmount,
          selectedExpenseType: state.selectedExpenseType,
          hasGoal: state.hasGoal,
          isLoading: false,
        ));
      }
    } catch (e) {
      emit(AddExpenseErrorState(
        errorMessage: 'Please enter a valid amount.',
        expenseName: state.expenseName,
        expenseAmount: state.expenseAmount,
        selectedExpenseType: state.selectedExpenseType,
        hasGoal: state.hasGoal,
        isLoading: false,
      ));
    }
  }
}
