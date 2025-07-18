import 'transaction_model.dart';

class GoalModel {
  final String id;
  final double amount;
  final DateTime? deadline;
  final DateTime createdAt;
  final bool isCompleted;
  final List<TransactionModel> transactions;

  GoalModel({
    required this.id,
    required this.amount,
    this.deadline,
    required this.createdAt,
    this.isCompleted = false,
    this.transactions = const [],
  });

  // Calculate current saved amount (incomes - expenses)
  double get currentAmount {
    double totalIncome = transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
    double totalExpense = transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
    return totalIncome - totalExpense;
  }

  // Calculate remaining amount needed to reach goal
  double get remainingAmount {
    double remaining = amount - currentAmount;
    return remaining > 0 ? remaining : 0;
  }

  // Calculate progress percentage
  double get progressPercentage {
    if (amount <= 0) return 0;
    double progress = (currentAmount / amount) * 100;
    return progress > 100 ? 100 : progress;
  }

  // Check if goal is achieved based on current amount
  bool get isAchieved {
    return currentAmount >= amount;
  }

  // Convert GoalModel to Map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'deadline': deadline?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
      'transactions': transactions.map((transaction) => transaction.toJson()).toList(),
    };
  }

  // Create GoalModel from Map
  factory GoalModel.fromJson(Map<String, dynamic> json) {
    List<TransactionModel> transactionsList = [];

    // Handle new format with transactions
    if (json['transactions'] != null) {
      transactionsList = (json['transactions'] as List)
          .map((transactionJson) => TransactionModel.fromJson(transactionJson))
          .toList();
    } 
    // Handle legacy format with separate incomes and expenses
    else {
      if (json['incomes'] != null) {
        transactionsList.addAll((json['incomes'] as List)
            .map((incomeJson) => TransactionModel.fromIncome(incomeJson))
            .toList());
      }

      if (json['expenses'] != null) {
        transactionsList.addAll((json['expenses'] as List)
            .map((expenseJson) => TransactionModel.fromExpense(expenseJson))
            .toList());
      }
    }

    return GoalModel(
      id: json['id'],
      amount: json['amount'].toDouble(),
      deadline: json['deadline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['deadline'])
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      isCompleted: json['isCompleted'] ?? false,
      transactions: transactionsList,
    );
  }

  // Create a copy of GoalModel with updated fields
  GoalModel copyWith({
    String? id,
    double? amount,
    DateTime? deadline,
    DateTime? createdAt,
    bool? isCompleted,
    List<TransactionModel>? transactions,
  }) {
    return GoalModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  String toString() {
    int incomeCount = transactions.where((t) => t.isIncome).length;
    int expenseCount = transactions.where((t) => t.isExpense).length;
    return 'GoalModel(id: $id, amount: $amount, deadline: $deadline, createdAt: $createdAt, isCompleted: $isCompleted, incomes: $incomeCount, expenses: $expenseCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GoalModel && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
