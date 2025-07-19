import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/goal_model.dart';
import '../../models/transaction_model.dart';

class LocalData {
  static late SharedPreferences prefs;
  static const String _goalKey = 'current_goal';
  static const String _transactionsKey = 'transactions';

  static final StreamController<List<TransactionModel>>
      _transactionsController =
      StreamController<List<TransactionModel>>.broadcast();

  static Stream<List<TransactionModel>> get transactionsStream =>
      _transactionsController.stream;

  static Future<void> initLocalService() async {
    prefs = await SharedPreferences.getInstance();

    await notifyTransactionsChanged();
  }

  static Future<void> notifyTransactionsChanged() async {
    try {
      List<TransactionModel> transactions = await getTransactions();

      _transactionsController.add(transactions);
    } catch (e) {
      // Handle error
    }
  }

  static void dispose() {
    _transactionsController.close();
  }

  static Future<bool> saveGoal(GoalModel goal) async {
    try {
      String goalJson = jsonEncode(goal.toJson());

      return await prefs.setString(_goalKey, goalJson);
    } catch (e) {
      return false;
    }
  }

  static Future<GoalModel?> getCurrentGoal() async {
    try {
      String? goalJson = prefs.getString(_goalKey);

      if (goalJson == null || goalJson.isEmpty) {
        return null;
      }

      GoalModel goal = GoalModel.fromJson(jsonDecode(goalJson));

      return goal;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> hasGoal() async {
    try {
      String? goalJson = prefs.getString(_goalKey);
      return goalJson != null && goalJson.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteCurrentGoal() async {
    try {
      bool result = await prefs.remove(_goalKey);

      if (result) {
        await notifyTransactionsChanged();
      }

      return result;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> saveTransactions(
      List<TransactionModel> transactions) async {
    try {
      List<Map<String, dynamic>> transactionsJson =
          transactions.map((transaction) => transaction.toJson()).toList();
      String transactionsString = jsonEncode(transactionsJson);
      return await prefs.setString(_transactionsKey, transactionsString);
    } catch (e) {
      return false;
    }
  }

  static Future<List<TransactionModel>> getTransactions() async {
    try {
      String? transactionsString = prefs.getString(_transactionsKey);

      if (transactionsString == null || transactionsString.isEmpty) {
        return [];
      }

      List<dynamic> transactionsJson = jsonDecode(transactionsString);
      return transactionsJson
          .map((json) => TransactionModel.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addTransaction(TransactionModel transaction) async {
    try {
      List<TransactionModel> currentTransactions = await getTransactions();
      currentTransactions.add(transaction);

      bool result = await saveTransactions(currentTransactions);

      if (result) {
        await notifyTransactionsChanged();
      }

      return result;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateTransaction(
      TransactionModel updatedTransaction) async {
    try {
      List<TransactionModel> currentTransactions = await getTransactions();

      int index =
          currentTransactions.indexWhere((t) => t.id == updatedTransaction.id);
      if (index != -1) {
        currentTransactions[index] = updatedTransaction;
        bool result = await saveTransactions(currentTransactions);

        if (result) {
          await notifyTransactionsChanged();
        }

        return result;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeTransaction(String transactionId) async {
    try {
      List<TransactionModel> currentTransactions = await getTransactions();

      currentTransactions.removeWhere((t) => t.id == transactionId);
      bool result = await saveTransactions(currentTransactions);

      if (result) {
        await notifyTransactionsChanged();
      }

      return result;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> clearAllTransactions() async {
    try {
      bool result = await prefs.remove(_transactionsKey);

      if (result) {
        await notifyTransactionsChanged();
      }

      return result;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> clearTransactionsFromCurrentGoal() async {
    try {
      List<TransactionModel> currentTransactions = await getTransactions();

      List<TransactionModel> filteredTransactions = currentTransactions
          .where((transaction) => !transaction.isFromCurrentGoal)
          .toList();

      bool result = await saveTransactions(filteredTransactions);

      if (result) {
        await notifyTransactionsChanged();
      }

      return result;
    } catch (e) {
      return false;
    }
  }

  static Future<double> getTotalIncome() async {
    try {
      List<TransactionModel> transactions = await getTransactions();
      double total = 0.0;
      for (var transaction in transactions) {
        if (transaction.isIncome && transaction.isFromCurrentGoal) {
          total += transaction.amount;
        }
      }
      return total;
    } catch (e) {
      return 0.0;
    }
  }

  static Future<double> getTotalExpense() async {
    try {
      List<TransactionModel> transactions = await getTransactions();
      double total = 0.0;
      for (var transaction in transactions) {
        if (transaction.isExpense && transaction.isFromCurrentGoal) {
          total += transaction.amount;
        }
      }
      return total;
    } catch (e) {
      return 0.0;
    }
  }

  static Future<double> getCurrentAmount() async {
    try {
      double totalIncome = await getTotalIncome();
      double totalExpense = await getTotalExpense();
      return totalIncome - totalExpense;
    } catch (e) {
      return 0.0;
    }
  }

  static Future<bool> addIncome(TransactionModel income) async {
    return await addTransaction(income);
  }

  static Future<bool> addExpense(TransactionModel expense) async {
    return await addTransaction(expense);
  }

  static void deleteTransaction(String id) async {
    await removeTransaction(id);
  }
}
