import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/goal_model.dart';

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
}
