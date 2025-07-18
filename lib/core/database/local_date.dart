import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/goal_model.dart';
import '../../models/transaction_model.dart';

class LocalData {
  static late SharedPreferences prefs;
  static const String _goalKey = 'current_goal';
  static const String _transactionsKey = 'transactions';
  
  // Stream controller for transactions changes
  static final StreamController<List<TransactionModel>> _transactionsController = 
      StreamController<List<TransactionModel>>.broadcast();
  
  // Stream to listen to transactions changes
  static Stream<List<TransactionModel>> get transactionsStream => _transactionsController.stream;

  static Future<void> initLocalService() async {
    prefs = await SharedPreferences.getInstance();
    // Initialize stream with current data
    await notifyTransactionsChanged();
  }

  // Notify listeners about transactions changes
  static Future<void> notifyTransactionsChanged() async {
    try {
      List<TransactionModel> transactions = await getTransactions();
      print('LocalData: Notifying ${transactions.length} transactions to stream');
      _transactionsController.add(transactions);
    } catch (e) {
      print('Error notifying transactions changed: $e');
    }
  }

  // Dispose stream controller when no longer needed
  static void dispose() {
    _transactionsController.close();
  }

  // Goal Management Methods
  
  // Save/Update the single goal (replaces any existing goal)
  static Future<bool> saveGoal(GoalModel goal) async {
    try {
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

  // Delete the current goal
  static Future<bool> deleteCurrentGoal() async {
    try {
      print("LocalData: Deleting current goal from storage");
      bool result = await prefs.remove(_goalKey);
      
      // Notify listeners about the change (empty transactions list)
      if (result) {
        print("LocalData: Goal deleted successfully, notifying listeners");
        await notifyTransactionsChanged();
      }
      
      return result;
    } catch (e) {
      print('Error deleting goal: $e');
      return false;
    }
  }




  // Transaction Management Methods (Independent of Goals)
  
  // Save transactions list to storage
  static Future<bool> saveTransactions(List<TransactionModel> transactions) async {
    try {
      List<Map<String, dynamic>> transactionsJson = 
          transactions.map((transaction) => transaction.toJson()).toList();
      String transactionsString = jsonEncode(transactionsJson);
      return await prefs.setString(_transactionsKey, transactionsString);
    } catch (e) {
      print('Error saving transactions: $e');
      return false;
    }
  }

  // Get all transactions from storage
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
      print('Error getting transactions: $e');
      return [];
    }
  }

  // Add transaction to storage
  static Future<bool> addTransaction(TransactionModel transaction) async {
    try {
      print('LocalData: Adding transaction: ${transaction.name} - ${transaction.amount}');
      List<TransactionModel> currentTransactions = await getTransactions();
      currentTransactions.add(transaction);
      
      bool result = await saveTransactions(currentTransactions);
      
      if (result) {
        print('LocalData: Transaction saved successfully, notifying listeners');
        await notifyTransactionsChanged();
      }
      
      return result;
    } catch (e) {
      print('Error adding transaction: $e');
      return false;
    }
  }



  // Update transaction in storage
  static Future<bool> updateTransaction(TransactionModel updatedTransaction) async {
    try {
      List<TransactionModel> currentTransactions = await getTransactions();
      
      int index = currentTransactions.indexWhere((t) => t.id == updatedTransaction.id);
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
      print('Error updating transaction: $e');
      return false;
    }
  }

  // Remove transaction from storage
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
      print('Error removing transaction: $e');
      return false;
    }
  }

  // Clear all transactions
  static Future<bool> clearAllTransactions() async {
    try {
      bool result = await prefs.remove(_transactionsKey);
      
      if (result) {
        await notifyTransactionsChanged();
      }
      
      return result;
    } catch (e) {
      print('Error clearing transactions: $e');
      return false;
    }
  }

  // Get total income amount
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
      print('Error calculating total income: $e');
      return 0.0;
    }
  }
 
  // Get total expense amount
  static Future<double> getTotalExpense() async {
    try {
      List<TransactionModel> transactions = await getTransactions();
      double total = 0.0;
      for (var transaction in transactions ) {  
        if (transaction.isExpense && transaction.isFromCurrentGoal) {
          total += transaction.amount;
        }
      }
      return total;
    } catch (e) {
      print('Error calculating total expense: $e');
      return 0.0;
    }
  }

  // Get current net amount (income - expense)
  static Future<double> getCurrentAmount() async {
    try {
      double totalIncome = await getTotalIncome();
      double totalExpense = await getTotalExpense();
      return totalIncome - totalExpense;
    } catch (e) {
      print('Error calculating current amount: $e');
      return 0.0;
    }
  }


  // Add income (using unified transaction model)
  static Future<bool> addIncome(TransactionModel income) async {
    print('Adding income****: ${income.isFromCurrentGoal}');
    return await addTransaction(income);
  }

  // Add expense (using unified transaction model)
  static Future<bool> addExpense(TransactionModel expense) async {
    return await addTransaction(expense);
  }
  static void deleteTransaction(String id)async {
   await  removeTransaction(id);
  }
}
 