import 'dart:async';
import 'package:app_p_134/cubit/homeCubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/database/local_date.dart';
import '../../models/transaction_model.dart';


class HomeCubit extends Cubit<HomeState> {
  StreamSubscription<List<TransactionModel>>? _transactionsSubscription;

  HomeCubit() : super(const HomeState()) {
    _initializeCubit();
  }

  void _initializeCubit() {
    _loadCurrentAmount();
    _listenToTransactions();
  }

  void _listenToTransactions() {
    _transactionsSubscription = LocalData.transactionsStream.listen((transactions) {
      double totalIncome = 0.0;
      double totalExpense = 0.0;
      
      for (var transaction in transactions) {
        if (transaction.isIncome) {
          totalIncome += transaction.amount;
        } else {
          totalExpense += transaction.amount;
        }
      }
      
      emit(state.copyWith(
        currentAmount: totalIncome - totalExpense,
        isLoading: false,
      ));
    });
  }

  Future<void> _loadCurrentAmount() async {
    try {
      double amount = await LocalData.getCurrentAmount();
      emit(state.copyWith(
        currentAmount: amount,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  @override
  Future<void> close() {
    _transactionsSubscription?.cancel();
    return super.close();
  }
}

