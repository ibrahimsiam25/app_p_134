import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/database/local_date.dart';
import '../../models/transaction_model.dart';
import '../../screens/add _income_and_expense/widgets/transaction_type_selector.dart';
import 'transaction_form_state.dart';

class TransactionFormCubit extends Cubit<TransactionFormState> {
  TransactionFormCubit(TransactionFormType formType) 
    : super(TransactionFormInitialState(formType: formType));

  Future<void> initialize() async {
    try {
      final hasGoal = await LocalData.hasGoal();
      emit(state.copyWith(hasGoal: hasGoal));
    } catch (e) {
      // Handle error silently
    }
  }

  void updateTransactionName(String name) {
    emit(state.copyWith(transactionName: name));
  }

  void updateTransactionAmount(String amount) {
    emit(state.copyWith(transactionAmount: amount));
  }

  void updateSelectedTransactionType(TransactionType type) {
    emit(state.copyWith(selectedTransactionType: type));
  }

  Future<void> saveTransaction() async {
    if (!state.isFormValid) return;

    emit(state.copyWith(isLoading: true));

    try {
      final amount = double.parse(state.transactionAmount);
      
      bool success = false;
      
      if (state.formType == TransactionFormType.income) {
        final income = TransactionModel.income(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: state.transactionName,
          amount: amount,
          date: DateTime.now(),
          isFromCurrentGoal: (state.selectedTransactionType == TransactionType.addToGoal) && state.hasGoal,
        );
        success = await LocalData.addIncome(income);
      } else {
        final expense = TransactionModel.expense(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: state.transactionName,
          amount: amount,
          date: DateTime.now(),
          isFromCurrentGoal: (state.selectedTransactionType == TransactionType.addToGoal) && state.hasGoal,
        );
        success = await LocalData.addExpense(expense);
      }

      if (success) {
        emit(TransactionFormSuccessState(
          transactionName: state.transactionName,
          transactionAmount: state.transactionAmount,
          selectedTransactionType: state.selectedTransactionType,
          hasGoal: state.hasGoal,
          isLoading: false,
          formType: state.formType,
        ));
      } else {
        final errorMessage = state.formType == TransactionFormType.income 
          ? 'Failed to add income. Please try again.'
          : 'Failed to add expense. Please try again.';
          
        emit(TransactionFormErrorState(
          errorMessage: errorMessage,
          transactionName: state.transactionName,
          transactionAmount: state.transactionAmount,
          selectedTransactionType: state.selectedTransactionType,
          hasGoal: state.hasGoal,
          isLoading: false,
          formType: state.formType,
        ));
      }
    } catch (e) {
      emit(TransactionFormErrorState(
        errorMessage: 'Please enter a valid amount.',
        transactionName: state.transactionName,
        transactionAmount: state.transactionAmount,
        selectedTransactionType: state.selectedTransactionType,
        hasGoal: state.hasGoal,
        isLoading: false,
        formType: state.formType,
      ));
    }
  }
}
