import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/database/local_date.dart';
import '../../models/transaction_model.dart';
import '../../screens/add _income_and_expense/widgets/transaction_type_selector.dart';
import 'add_income_state.dart';

class AddIncomeCubit extends Cubit<AddIncomeState> {
  AddIncomeCubit() : super(const AddIncomeInitialState());

  Future<void> initialize() async {
    try {
      final hasGoal = await LocalData.hasGoal();
      emit(state.copyWith(hasGoal: hasGoal));
    } catch (e) {
      // Handle error silently
    }
  }

  void updateIncomeName(String name) {
    emit(state.copyWith(incomeName: name));
  }

  void updateIncomeAmount(String amount) {
    emit(state.copyWith(incomeAmount: amount));
  }

  void updateSelectedIncomeType(TransactionType type) {
    emit(state.copyWith(selectedIncomeType: type));
  }

  Future<void> saveIncome() async {
    if (!state.isFormValid) return;

    emit(state.copyWith(isLoading: true));

    try {
      final amount = double.parse(state.incomeAmount);
      final income = TransactionModel.income(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: state.incomeName,
        amount: amount,
        date: DateTime.now(),
        isFromCurrentGoal: (state.selectedIncomeType == TransactionType.addToGoal) && state.hasGoal,
      );

      bool success = await LocalData.addIncome(income);

      if (success) {
        emit(AddIncomeSuccessState(
          incomeName: state.incomeName,
          incomeAmount: state.incomeAmount,
          selectedIncomeType: state.selectedIncomeType,
          hasGoal: state.hasGoal,
          isLoading: false,
        ));
      } else {
        emit(AddIncomeErrorState(
          errorMessage: 'Failed to add income. Please try again.',
          incomeName: state.incomeName,
          incomeAmount: state.incomeAmount,
          selectedIncomeType: state.selectedIncomeType,
          hasGoal: state.hasGoal,
          isLoading: false,
        ));
      }
    } catch (e) {
      emit(AddIncomeErrorState(
        errorMessage: 'Please enter a valid amount.',
        incomeName: state.incomeName,
        incomeAmount: state.incomeAmount,
        selectedIncomeType: state.selectedIncomeType,
        hasGoal: state.hasGoal,
        isLoading: false,
      ));
    }
  }
}
