
import '../../models/transaction_model.dart';

class AllTransactionsState {
  final List<TransactionModel> allTransactions;
  final bool isLoading;
  final bool? deleteSuccess;
  final String? deleteError;

  const AllTransactionsState({
    this.allTransactions = const [],
    this.isLoading = true,
    this.deleteSuccess,
    this.deleteError,
  });

  AllTransactionsState copyWith({
    List<TransactionModel>? allTransactions,
    bool? isLoading,
    bool? deleteSuccess,
    String? deleteError,
  }) {
    return AllTransactionsState(
      allTransactions: allTransactions ?? this.allTransactions,
      isLoading: isLoading ?? this.isLoading,
      deleteSuccess: deleteSuccess,
      deleteError: deleteError,
    );
  }
}
