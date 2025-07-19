import 'dart:async';
import 'package:app_p_134/cubit/allTransactionsCubit/all_transactions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/database/local_date.dart';
import '../../models/transaction_model.dart';


class AllTransactionsCubit extends Cubit<AllTransactionsState> {
  StreamSubscription<List<TransactionModel>>? _transactionsSubscription;

  AllTransactionsCubit() : super(const AllTransactionsState()) {
    _initializeCubit();
  }

  void _initializeCubit() {
    _loadTransactions();
    _listenToTransactions();
  }

  void _listenToTransactions() {
    _transactionsSubscription = LocalData.transactionsStream.listen((transactions) {
      emit(state.copyWith(
        allTransactions: transactions,
        isLoading: false,
      ));
    });
  }

  Future<void> _loadTransactions() async {
    try {
      List<TransactionModel> transactions = await LocalData.getTransactions();
      emit(state.copyWith(
        allTransactions: transactions,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      LocalData.deleteTransaction(transactionId);
      emit(state.copyWith(
        deleteSuccess: true,
        deleteError: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        deleteSuccess: false,
        deleteError: 'Failed to delete transaction. Please try again.',
      ));
    }
  }

  void clearDeleteStatus() {
    emit(state.copyWith(
      deleteSuccess: null,
      deleteError: null,
    ));
  }

  @override
  Future<void> close() {
    _transactionsSubscription?.cancel();
    return super.close();
  }
}
