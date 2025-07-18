import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/goal_model.dart';

class LocalData {
  static late SharedPreferences prefs;
  static const String _goalsKey = 'goals_list';

  static Future<void> initLocalService() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Save a single goal
  static Future<bool> saveGoal(GoalModel goal) async {
    try {
      List<GoalModel> goals = await getGoals();
      
      // Check if goal with same ID already exists, if so update it
      int existingIndex = goals.indexWhere((g) => g.id == goal.id);
      if (existingIndex != -1) {
        goals[existingIndex] = goal;
      } else {
        goals.add(goal);
      }

      // Convert goals list to JSON strings
      List<String> goalsJsonList = goals.map((goal) => jsonEncode(goal.toJson())).toList();
      print("Saving goals++++++++++: $goalsJsonList");
      return await prefs.setStringList(_goalsKey, goalsJsonList);
    } catch (e) {
      print('Error saving goal: $e');
      return false;
    }
  }

  // Get all goals
  static Future<List<GoalModel>> getGoals() async {
    try {
      List<String>? goalsJsonList = prefs.getStringList(_goalsKey);
      
      if (goalsJsonList == null || goalsJsonList.isEmpty) {
        return [];
      }

      List<GoalModel> goals = goalsJsonList
          .map((goalJson) => GoalModel.fromJson(jsonDecode(goalJson)))
          .toList();

      // Sort goals by creation date (newest first)
      goals.sort((a, b) => b.createdAt.compareTo(a.createdAt));
     
      return goals;
    } catch (e) {
      print('Error getting goals: $e');
      return [];
    }
  }

  // Get a specific goal by ID
  static Future<GoalModel?> getGoalById(String id) async {
    try {
      List<GoalModel> goals = await getGoals();
       print(" get goal by ID++++++++++: $goals");
      return goals.firstWhere((goal) => goal.id == id);
    } catch (e) {
      print('Error getting goal by ID: $e');
      return null;
    }
  }

  // Delete a goal by ID
  static Future<bool> deleteGoal(String id) async {
    try {
      List<GoalModel> goals = await getGoals();
      goals.removeWhere((goal) => goal.id == id);

      List<String> goalsJsonList = goals.map((goal) => jsonEncode(goal.toJson())).toList();
      
      return await prefs.setStringList(_goalsKey, goalsJsonList);
    } catch (e) {
      print('Error deleting goal: $e');
      return false;
    }
  }

  // Update goal completion status
  static Future<bool> updateGoalCompletion(String id, bool isCompleted) async {
    try {
      List<GoalModel> goals = await getGoals();
      int index = goals.indexWhere((goal) => goal.id == id);
      
      if (index != -1) {
        goals[index] = goals[index].copyWith(isCompleted: isCompleted);
        List<String> goalsJsonList = goals.map((goal) => jsonEncode(goal.toJson())).toList();
        return await prefs.setStringList(_goalsKey, goalsJsonList);
      }
      
      return false;
    } catch (e) {
      print('Error updating goal completion: $e');
      return false;
    }
  }

  // Clear all goals
  static Future<bool> clearAllGoals() async {
    try {
       print("Clearing all goals from storage--------");
      return await prefs.remove(_goalsKey);
      
    } catch (e) {
      print('Error clearing goals: $e');
      return false;
    }
  }
}
