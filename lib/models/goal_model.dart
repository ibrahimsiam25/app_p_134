import 'income_model.dart';
import 'expense_model.dart';

class GoalModel {
  final String id;
  final double amount;
  final DateTime? deadline;
  final DateTime createdAt;
  final bool isCompleted;
  final List<IncomeModel> incomes;
  final List<ExpenseModel> expenses;

  GoalModel({
    required this.id,
    required this.amount,
    this.deadline,
    required this.createdAt,
    this.isCompleted = false,
    this.incomes = const [],
    this.expenses = const [],
  });

  // Calculate current saved amount (incomes - expenses)
  double get currentAmount {
    double totalIncome = incomes.fold(0.0, (sum, income) => sum + income.amount);
    double totalExpense = expenses.fold(0.0, (sum, expense) => sum + expense.amount);
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
      'incomes': incomes.map((income) => income.toJson()).toList(),
      'expenses': expenses.map((expense) => expense.toJson()).toList(),
    };
  }

  // Create GoalModel from Map
  factory GoalModel.fromJson(Map<String, dynamic> json) {
    List<IncomeModel> incomesList = [];
    List<ExpenseModel> expensesList = [];

    if (json['incomes'] != null) {
      incomesList = (json['incomes'] as List)
          .map((incomeJson) => IncomeModel.fromJson(incomeJson))
          .toList();
    }

    if (json['expenses'] != null) {
      expensesList = (json['expenses'] as List)
          .map((expenseJson) => ExpenseModel.fromJson(expenseJson))
          .toList();
    }

    return GoalModel(
      id: json['id'],
      amount: json['amount'].toDouble(),
      deadline: json['deadline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['deadline'])
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      isCompleted: json['isCompleted'] ?? false,
      incomes: incomesList,
      expenses: expensesList,
    );
  }

  // Create a copy of GoalModel with updated fields
  GoalModel copyWith({
    String? id,
    double? amount,
    DateTime? deadline,
    DateTime? createdAt,
    bool? isCompleted,
    List<IncomeModel>? incomes,
    List<ExpenseModel>? expenses,
  }) {
    return GoalModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      incomes: incomes ?? this.incomes,
      expenses: expenses ?? this.expenses,
    );
  }

  @override
  String toString() {
    return 'GoalModel(id: $id, amount: $amount, deadline: $deadline, createdAt: $createdAt, isCompleted: $isCompleted, incomes: ${incomes.length}, expenses: ${expenses.length})';
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
