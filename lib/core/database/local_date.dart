import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/goal_model.dart';
import '../../models/transaction_model.dart';

class LocalData {
  static late SharedPreferences prefs;
  static const String _goalKey = 'current_goal'; // Changed from _goalsKey to _goalKey

  static Future<void> initLocalService() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Save/Update the single goal (replaces any existing goal)
  static Future<bool> saveGoal(GoalModel goal) async {
    try {
      // Convert goal to JSON string
      String goalJson = jsonEncode(goal.toJson());
      print("Saving goal: $goalJson");
      return await prefs.setString(_goalKey, goalJson);
    } catch (e) {
      print('Error saving goal: $e');
      return false;
    }
  }

  // Get the current goal (returns null if no goal exists)
  static Future<GoalModel?> getCurrentGoal() async {
    try {
      String? goalJson = prefs.getString(_goalKey);
      
      if (goalJson == null || goalJson.isEmpty) {
        print("No goal found in storage");
        return null;
      }

      GoalModel goal = GoalModel.fromJson(jsonDecode(goalJson));
      print("Retrieved goal: ${goal.toString()}");
      return goal;
    } catch (e) {
      print('Error getting goal: $e');
      return null;
    }
  }

  // Check if user has a goal
  static Future<bool> hasGoal() async {
    try {
      String? goalJson = prefs.getString(_goalKey);
      return goalJson != null && goalJson.isNotEmpty;
    } catch (e) {
      print('Error checking if goal exists: $e');
      return false;
    }
  }

  // Update goal completion status
  static Future<bool> updateGoalCompletion(bool isCompleted) async {
    try {
      GoalModel? currentGoal = await getCurrentGoal();
      
      if (currentGoal != null) {
        GoalModel updatedGoal = currentGoal.copyWith(isCompleted: isCompleted);
        return await saveGoal(updatedGoal);
      }
      
      return false;
    } catch (e) {
      print('Error updating goal completion: $e');
      return false;
    }
  }

  // Update goal amount
  static Future<bool> updateGoalAmount(double newAmount) async {
    try {
      GoalModel? currentGoal = await getCurrentGoal();
      
      if (currentGoal != null) {
        GoalModel updatedGoal = currentGoal.copyWith(amount: newAmount);
        return await saveGoal(updatedGoal);
      }
      
      return false;
    } catch (e) {
      print('Error updating goal amount: $e');
      return false;
    }
  }

  // Update goal deadline
  static Future<bool> updateGoalDeadline(DateTime? newDeadline) async {
    try {
      GoalModel? currentGoal = await getCurrentGoal();
      
      if (currentGoal != null) {
        GoalModel updatedGoal = currentGoal.copyWith(deadline: newDeadline);
        return await saveGoal(updatedGoal);
      }
      
      return false;
    } catch (e) {
      print('Error updating goal deadline: $e');
      return false;
    }
  }

  // Delete the current goal
  static Future<bool> deleteCurrentGoal() async {
    try {
      print("Deleting current goal from storage");
      return await prefs.remove(_goalKey);
    } catch (e) {
      print('Error deleting goal: $e');
      return false;
    }
  }

  // Legacy methods for backward compatibility (deprecated)
  @deprecated
  static Future<List<GoalModel>> getGoals() async {
    GoalModel? goal = await getCurrentGoal();
    return goal != null ? [goal] : [];
  }

  @deprecated
  static Future<GoalModel?> getGoalById(String id) async {
    GoalModel? goal = await getCurrentGoal();
    return (goal != null && goal.id == id) ? goal : null;
  }

  @deprecated
  static Future<bool> deleteGoal(String id) async {
    GoalModel? goal = await getCurrentGoal();
    if (goal != null && goal.id == id) {
      return await deleteCurrentGoal();
    }
    return false;
  }

  @deprecated
  static Future<bool> updateGoalCompletionById(String id, bool isCompleted) async {
    GoalModel? goal = await getCurrentGoal();
    if (goal != null && goal.id == id) {
      return await updateGoalCompletion(isCompleted);
    }
    return false;
  }

  @deprecated
  static Future<bool> clearAllGoals() async {
    return await deleteCurrentGoal();
  }

  // Transaction Management Methods
  
  // Add transaction to current goal
  static Future<bool> addTransactionToGoal(TransactionModel transaction) async {
    try {
      GoalModel? currentGoal = await getCurrentGoal();
      
      if (currentGoal != null) {
        List<TransactionModel> updatedTransactions = List.from(currentGoal.transactions);
        updatedTransactions.add(transaction);
        
        GoalModel updatedGoal = currentGoal.copyWith(transactions: updatedTransactions);
        return await saveGoal(updatedGoal);
      }
      
      return false;
    } catch (e) {
      print('Error adding transaction to goal: $e');
      return false;
    }
  }

  // Add income to current goal (using unified transaction model)
  static Future<bool> addIncomeToGoal(TransactionModel income) async {
    return await addTransactionToGoal(income);
  }

  // Add expense to current goal (using unified transaction model)
  static Future<bool> addExpenseToGoal(TransactionModel expense) async {
    return await addTransactionToGoal(expense);
  }

  // Update transaction in current goal
  static Future<bool> updateTransactionInGoal(TransactionModel updatedTransaction) async {
    try {
      GoalModel? currentGoal = await getCurrentGoal();
      
      if (currentGoal != null) {
        List<TransactionModel> updatedTransactions = currentGoal.transactions.map((transaction) {
          return transaction.id == updatedTransaction.id ? updatedTransaction : transaction;
        }).toList();
        
        GoalModel updatedGoal = currentGoal.copyWith(transactions: updatedTransactions);
        return await saveGoal(updatedGoal);
      }
      
      return false;
    } catch (e) {
      print('Error updating transaction in goal: $e');
      return false;
    }
  }

  // Remove transaction from current goal
  static Future<bool> removeTransactionFromGoal(String transactionId) async {
    try {
      GoalModel? currentGoal = await getCurrentGoal();
      
      if (currentGoal != null) {
        List<TransactionModel> updatedTransactions = currentGoal.transactions
            .where((transaction) => transaction.id != transactionId)
            .toList();
        
        GoalModel updatedGoal = currentGoal.copyWith(transactions: updatedTransactions);
        return await saveGoal(updatedGoal);
      }
      
      return false;
    } catch (e) {
      print('Error removing transaction from goal: $e');
      return false;
    }
  }

  // Get all transactions from current goal
  static Future<List<TransactionModel>> getTransactionsFromGoal() async {
    try {
      GoalModel? currentGoal = await getCurrentGoal();
      return currentGoal?.transactions ?? [];
    } catch (e) {
      print('Error getting transactions from goal: $e');
      return [];
    }
  }

  // Get all incomes from current goal
  static Future<List<TransactionModel>> getIncomesFromGoal() async {
    try {
      GoalModel? currentGoal = await getCurrentGoal();
      return currentGoal?.transactions.where((t) => t.isIncome).toList() ?? [];
    } catch (e) {
      print('Error getting incomes from goal: $e');
      return [];
    }
  }

  // Get all expenses from current goal
  static Future<List<TransactionModel>> getExpensesFromGoal() async {
    try {
      GoalModel? currentGoal = await getCurrentGoal();
      return currentGoal?.transactions.where((t) => t.isExpense).toList() ?? [];
    } catch (e) {
      print('Error getting expenses from goal: $e');
      return [];
    }
  }

  // Legacy methods for backward compatibility
  static Future<bool> updateIncomeInGoal(TransactionModel updatedIncome) async {
    return await updateTransactionInGoal(updatedIncome);
  }

  static Future<bool> updateExpenseInGoal(TransactionModel updatedExpense) async {
    return await updateTransactionInGoal(updatedExpense);
  }

  static Future<bool> removeIncomeFromGoal(String incomeId) async {
    return await removeTransactionFromGoal(incomeId);
  }

  static Future<bool> removeExpenseFromGoal(String expenseId) async {
    return await removeTransactionFromGoal(expenseId);
  }

  // Get goal progress information
  static Future<Map<String, dynamic>> getGoalProgress() async {
    try {
      GoalModel? currentGoal = await getCurrentGoal();
      
      if (currentGoal != null) {
        List<TransactionModel> incomes = currentGoal.transactions.where((t) => t.isIncome).toList();
        List<TransactionModel> expenses = currentGoal.transactions.where((t) => t.isExpense).toList();
        
        return {
          'goalAmount': currentGoal.amount,
          'currentAmount': currentGoal.currentAmount,
          'remainingAmount': currentGoal.remainingAmount,
          'progressPercentage': currentGoal.progressPercentage,
          'isAchieved': currentGoal.isAchieved,
          'totalIncomes': incomes.fold(0.0, (sum, income) => sum + income.amount),
          'totalExpenses': expenses.fold(0.0, (sum, expense) => sum + expense.amount),
          'incomesCount': incomes.length,
          'expensesCount': expenses.length,
        };
      }
      
      return {};
    } catch (e) {
      print('Error getting goal progress: $e');
      return {};
    }
  }
}
