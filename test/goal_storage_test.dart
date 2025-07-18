import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/core/database/local_date.dart';
import '../lib/models/goal_model.dart';

void main() {
  group('Single Goal Storage Tests', () {
    setUp(() async {
      // Initialize shared preferences for testing
      SharedPreferences.setMockInitialValues({});
      await LocalData.initLocalService();
    });

    test('Save and retrieve single goal', () async {
      // Create a test goal
      final goal = GoalModel(
        id: '1',
        amount: 1000.0,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
      );

      // Save the goal
      bool saveResult = await LocalData.saveGoal(goal);
      expect(saveResult, true);

      // Check if goal exists
      bool hasGoal = await LocalData.hasGoal();
      expect(hasGoal, true);

      // Retrieve the goal
      GoalModel? retrievedGoal = await LocalData.getCurrentGoal();
      expect(retrievedGoal, isNotNull);
      expect(retrievedGoal!.id, '1');
      expect(retrievedGoal.amount, 1000.0);
    });

    test('Replace existing goal', () async {
      // Create first goal
      final goal1 = GoalModel(
        id: '1',
        amount: 1000.0,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
      );

      // Save first goal
      await LocalData.saveGoal(goal1);

      // Create second goal (should replace first)
      final goal2 = GoalModel(
        id: '2',
        amount: 2000.0,
        deadline: DateTime.now().add(const Duration(days: 60)),
        createdAt: DateTime.now(),
      );

      // Save second goal
      await LocalData.saveGoal(goal2);

      // Retrieve goal - should be the second one
      GoalModel? currentGoal = await LocalData.getCurrentGoal();
      expect(currentGoal, isNotNull);
      expect(currentGoal!.id, '2');
      expect(currentGoal.amount, 2000.0);
    });

    test('Update goal completion status', () async {
      // Create a test goal
      final goal = GoalModel(
        id: '1',
        amount: 1000.0,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
      );

      // Save the goal
      await LocalData.saveGoal(goal);

      // Update completion status
      bool updateResult = await LocalData.updateGoalCompletion(true);
      expect(updateResult, true);

      // Verify update
      GoalModel? updatedGoal = await LocalData.getCurrentGoal();
      expect(updatedGoal?.isCompleted, true);
    });

    test('Update goal amount', () async {
      // Create a test goal
      final goal = GoalModel(
        id: '1',
        amount: 1000.0,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
      );

      // Save the goal
      await LocalData.saveGoal(goal);

      // Update amount
      bool updateResult = await LocalData.updateGoalAmount(1500.0);
      expect(updateResult, true);

      // Verify update
      GoalModel? updatedGoal = await LocalData.getCurrentGoal();
      expect(updatedGoal?.amount, 1500.0);
    });

    test('Update goal deadline', () async {
      // Create a test goal
      final goal = GoalModel(
        id: '1',
        amount: 1000.0,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
      );

      // Save the goal
      await LocalData.saveGoal(goal);

      // Update deadline
      DateTime newDeadline = DateTime.now().add(const Duration(days: 60));
      bool updateResult = await LocalData.updateGoalDeadline(newDeadline);
      expect(updateResult, true);

      // Verify update
      GoalModel? updatedGoal = await LocalData.getCurrentGoal();
      expect(updatedGoal?.deadline?.day, newDeadline.day);
    });

    test('Delete current goal', () async {
      // Create a test goal
      final goal = GoalModel(
        id: '1',
        amount: 1000.0,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
      );

      // Save the goal
      await LocalData.saveGoal(goal);

      // Verify goal exists
      bool hasGoalBefore = await LocalData.hasGoal();
      expect(hasGoalBefore, true);

      // Delete the goal
      bool deleteResult = await LocalData.deleteCurrentGoal();
      expect(deleteResult, true);

      // Verify deletion
      bool hasGoalAfter = await LocalData.hasGoal();
      expect(hasGoalAfter, false);

      GoalModel? goalAfterDelete = await LocalData.getCurrentGoal();
      expect(goalAfterDelete, isNull);
    });

    test('No goal initially', () async {
      // Check if there's no goal initially
      bool hasGoal = await LocalData.hasGoal();
      expect(hasGoal, false);

      GoalModel? goal = await LocalData.getCurrentGoal();
      expect(goal, isNull);
    });

    test('Update operations with no goal should fail', () async {
      // Try to update completion with no goal
      bool updateCompletion = await LocalData.updateGoalCompletion(true);
      expect(updateCompletion, false);

      // Try to update amount with no goal
      bool updateAmount = await LocalData.updateGoalAmount(1000.0);
      expect(updateAmount, false);

      // Try to update deadline with no goal
      bool updateDeadline = await LocalData.updateGoalDeadline(DateTime.now());
      expect(updateDeadline, false);
    });
  });
}
