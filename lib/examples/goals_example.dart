// Example of how to use the Single Goal functionality

import 'package:flutter/material.dart';
import '../core/database/local_date.dart';
import '../models/goal_model.dart';
import '../widgets/goals_list_widget.dart';

/*
 * UPDATED SYSTEM: SINGLE GOAL ONLY
 * 
 * The system now supports only ONE goal per user. When a new goal is created,
 * it replaces any existing goal.
 * 
 * WHAT WAS UPDATED:
 * 
 * 1. LocalData functions (lib/core/database/local_date.dart)
 *    - saveGoal(GoalModel goal) - Save/Replace the single goal
 *    - getCurrentGoal() - Get the current goal (returns null if no goal)
 *    - hasGoal() - Check if user has a goal
 *    - updateGoalCompletion(bool isCompleted) - Update completion status
 *    - updateGoalAmount(double newAmount) - Update goal amount
 *    - updateGoalDeadline(DateTime? newDeadline) - Update deadline
 *    - deleteCurrentGoal() - Delete the current goal
 * 
 * 2. CreateGoalScreen updates
 *    - Added confirmation dialog when replacing existing goal
 *    - Updated success message to show "updated" vs "saved"
 * 
 * 3. GoalsListWidget updates
 *    - Now displays single goal instead of list
 *    - Updated to work with getCurrentGoal()
 * 
 * USAGE EXAMPLES:
 */

class ExampleSingleGoalScreen extends StatefulWidget {
  const ExampleSingleGoalScreen({super.key});

  @override
  State<ExampleSingleGoalScreen> createState() => _ExampleSingleGoalScreenState();
}

class _ExampleSingleGoalScreenState extends State<ExampleSingleGoalScreen> {
  
  // Example: Create/Replace goal
  Future<void> _createExampleGoal() async {
    final goal = GoalModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: 5000.0,
      deadline: DateTime.now().add(const Duration(days: 30)),
      createdAt: DateTime.now(),
    );

    bool success = await LocalData.saveGoal(goal);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal saved/updated!')),
      );
      setState(() {}); // Refresh the goal display
    }
  }

  // Example: Check if user has a goal
  Future<void> _checkHasGoal() async {
    bool hasGoal = await LocalData.hasGoal();
    print('User has goal: $hasGoal');
    
    if (hasGoal) {
      GoalModel? goal = await LocalData.getCurrentGoal();
      print('Current goal: \$${goal?.amount}, Completed: ${goal?.isCompleted}');
    }
  }

  // Example: Update goal completion
  Future<void> _toggleGoalCompletion() async {
    GoalModel? currentGoal = await LocalData.getCurrentGoal();
    if (currentGoal != null) {
      bool newStatus = !currentGoal.isCompleted;
      bool success = await LocalData.updateGoalCompletion(newStatus);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Goal marked as ${newStatus ? 'completed' : 'incomplete'}!')),
        );
        setState(() {}); // Refresh the goal display
      }
    }
  }

  // Example: Update goal amount
  Future<void> _updateGoalAmount() async {
    bool success = await LocalData.updateGoalAmount(10000.0);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal amount updated!')),
      );
      setState(() {}); // Refresh the goal display
    }
  }

  // Example: Delete current goal
  Future<void> _deleteGoal() async {
    bool success = await LocalData.deleteCurrentGoal();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal deleted!')),
      );
      setState(() {}); // Refresh the goal display
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Single Goal Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createExampleGoal,
            tooltip: 'Create/Replace Goal',
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: _checkHasGoal,
            tooltip: 'Check Goal Status',
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _toggleGoalCompletion,
            tooltip: 'Toggle Completion',
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _updateGoalAmount,
            tooltip: 'Update Amount',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteGoal,
            tooltip: 'Delete Goal',
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // This widget displays the single goal
            GoalsListWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create goal screen
          Navigator.pushNamed(context, 'createGoalScreen');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/*
 * KEY CHANGES FROM MULTI-GOAL TO SINGLE-GOAL SYSTEM:
 * 
 * 1. STORAGE:
 *    - Changed from List<Goal> to single Goal
 *    - Uses String instead of List<String> in SharedPreferences
 *    - Key changed from 'goals_list' to 'current_goal'
 * 
 * 2. USER EXPERIENCE:
 *    - Creating new goal shows confirmation to replace existing
 *    - Clear messaging about goal replacement
 *    - Simplified UI (no list, just single goal card)
 * 
 * 3. API CHANGES:
 *    - getCurrentGoal() instead of getGoals()
 *    - hasGoal() to check existence
 *    - updateGoalCompletion(bool) instead of updateGoalCompletion(id, bool)
 *    - New methods: updateGoalAmount(), updateGoalDeadline()
 *    - deleteCurrentGoal() instead of deleteGoal(id)
 * 
 * 4. BACKWARD COMPATIBILITY:
 *    - Old methods marked as @deprecated but still work
 *    - Gradual migration path available
 * 
 * INTEGRATION NOTES:
 * 
 * 1. The LocalData.initLocalService() is still called in main.dart
 * 
 * 2. To display the goal: const GoalsListWidget()
 * 
 * 3. To create/replace goal: Navigator.pushNamed(context, 'createGoalScreen')
 * 
 * 4. System automatically handles goal replacement with user confirmation
 */
