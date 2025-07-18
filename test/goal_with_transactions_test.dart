import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/core/database/local_date.dart';
import '../lib/models/goal_model.dart';
import '../lib/models/income_model.dart';
import '../lib/models/expense_model.dart';

void main() {
  group('Enhanced Goal with Transactions Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await LocalData.initLocalService();
    });

    test('Create goal with incomes and expenses', () async {
      final income = IncomeModel(
        id: '1',
        name: 'Salary',
        amount: 2000.0,
        date: DateTime.now(),
        isFromCurrentGoal: true,
      );

      final expense = ExpenseModel(
        id: '1',
        name: 'Rent',
        amount: 500.0,
        date: DateTime.now(),
        isFromCurrentGoal: true,
      );

      final goal = GoalModel(
        id: '1',
        amount: 5000.0,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
        incomes: [income],
        expenses: [expense],
      );

      bool saveResult = await LocalData.saveGoal(goal);
      expect(saveResult, true);

      GoalModel? retrievedGoal = await LocalData.getCurrentGoal();
      expect(retrievedGoal, isNotNull);
      expect(retrievedGoal!.incomes.length, 1);
      expect(retrievedGoal.expenses.length, 1);
      expect(retrievedGoal.currentAmount, 1500.0); // 2000 - 500
    });

    test('Goal progress calculations', () async {
      final income1 = IncomeModel(
        id: '1',
        name: 'Salary',
        amount: 3000.0,
        date: DateTime.now(),
        isFromCurrentGoal: true,
      );

      final income2 = IncomeModel(
        id: '2',
        name: 'Bonus',
        amount: 1000.0,
        date: DateTime.now(),
        isFromCurrentGoal: true,
      );

      final expense = ExpenseModel(
        id: '1',
        name: 'Bills',
        amount: 1000.0,
        date: DateTime.now(),
        isFromCurrentGoal: true,
      );

      final goal = GoalModel(
        id: '1',
        amount: 5000.0,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
        incomes: [income1, income2],
        expenses: [expense],
      );

      await LocalData.saveGoal(goal);

      Map<String, dynamic> progress = await LocalData.getGoalProgress();
      expect(progress['goalAmount'], 5000.0);
      expect(progress['currentAmount'], 3000.0); // 4000 - 1000
      expect(progress['remainingAmount'], 2000.0); // 5000 - 3000
      expect(progress['progressPercentage'], 60.0); // (3000/5000) * 100
      expect(progress['isAchieved'], false);
      expect(progress['totalIncomes'], 4000.0);
      expect(progress['totalExpenses'], 1000.0);
    });

    test('Goal achieved when current amount >= goal amount', () async {
      final income = IncomeModel(
        id: '1',
        name: 'Big Win',
        amount: 6000.0,
        date: DateTime.now(),
        isFromCurrentGoal: true,
      );

      final goal = GoalModel(
        id: '1',
        amount: 5000.0,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
        incomes: [income],
        expenses: [],
      );

      await LocalData.saveGoal(goal);

      GoalModel? retrievedGoal = await LocalData.getCurrentGoal();
      expect(retrievedGoal!.isAchieved, true);
      expect(retrievedGoal.progressPercentage, 100.0);
      expect(retrievedGoal.remainingAmount, 0.0);
    });

    test('Add income to existing goal', () async {
      // Create initial goal
      final goal = GoalModel(
        id: '1',
        amount: 5000.0,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
      );

      await LocalData.saveGoal(goal);

      // Add income
      final income = IncomeModel(
        id: '1',
        name: 'Freelance',
        amount: 1500.0,
        date: DateTime.now(),
        isFromCurrentGoal: true,
      );

      bool addResult = await LocalData.addIncomeToGoal(income);
      expect(addResult, true);

      GoalModel? updatedGoal = await LocalData.getCurrentGoal();
      expect(updatedGoal!.incomes.length, 1);
      expect(updatedGoal.incomes.first.name, 'Freelance');
      expect(updatedGoal.currentAmount, 1500.0);
    });

    test('Add expense to existing goal', () async {
      // Create initial goal with income
      final income = IncomeModel(
        id: '1',
        name: 'Salary',
        amount: 3000.0,
        date: DateTime.now(),
        isFromCurrentGoal: true,
      );

      final goal = GoalModel(
        id: '1',
        amount: 5000.0,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
        incomes: [income],
      );

      await LocalData.saveGoal(goal);

      // Add expense
      final expense = ExpenseModel(
        id: '1',
        name: 'Rent',
        amount: 1000.0,
        date: DateTime.now(),
        isFromCurrentGoal: true,
      );

      bool addResult = await LocalData.addExpenseToGoal(expense);
      expect(addResult, true);

      GoalModel? updatedGoal = await LocalData.getCurrentGoal();
      expect(updatedGoal!.expenses.length, 1);
      expect(updatedGoal.expenses.first.name, 'Rent');
      expect(updatedGoal.currentAmount, 2000.0); // 3000 - 1000
    });

    test('Update income in goal', () async {
      final income = IncomeModel(
        id: '1',
        name: 'Salary',
        amount: 2000.0,
        date: DateTime.now(),
        isFromCurrentGoal: true,
      );

      final goal = GoalModel(
        id: '1',
        amount: 5000.0,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
        incomes: [income],
      );

      await LocalData.saveGoal(goal);

      // Update income
      final updatedIncome = income.copyWith(amount: 2500.0, name: 'Salary Raise');

      bool updateResult = await LocalData.updateIncomeInGoal(updatedIncome);
      expect(updateResult, true);

      GoalModel? updatedGoal = await LocalData.getCurrentGoal();
      expect(updatedGoal!.incomes.first.amount, 2500.0);
      expect(updatedGoal.incomes.first.name, 'Salary Raise');
      expect(updatedGoal.currentAmount, 2500.0);
    });

    test('Remove income from goal', () async {
      final income1 = IncomeModel(
        id: '1',
        name: 'Salary',
        amount: 2000.0,
        date: DateTime.now(),
        isFromCurrentGoal: true,
      );

      final income2 = IncomeModel(
        id: '2',
        name: 'Bonus',
        amount: 1000.0,
        date: DateTime.now(),
        isFromCurrentGoal: true,
      );

      final goal = GoalModel(
        id: '1',
        amount: 5000.0,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
        incomes: [income1, income2],
      );

      await LocalData.saveGoal(goal);

      // Remove one income
      bool removeResult = await LocalData.removeIncomeFromGoal('1');
      expect(removeResult, true);

      GoalModel? updatedGoal = await LocalData.getCurrentGoal();
      expect(updatedGoal!.incomes.length, 1);
      expect(updatedGoal.incomes.first.id, '2');
      expect(updatedGoal.currentAmount, 1000.0);
    });

    test('Get incomes and expenses separately', () async {
      final income = IncomeModel(
        id: '1',
        name: 'Salary',
        amount: 2000.0,
        date: DateTime.now(),
        isFromCurrentGoal: true,
      );

      final expense = ExpenseModel(
        id: '1',
        name: 'Rent',
        amount: 500.0,
        date: DateTime.now(),
        isFromCurrentGoal: true,
      );

      final goal = GoalModel(
        id: '1',
        amount: 5000.0,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
        incomes: [income],
        expenses: [expense],
      );

      await LocalData.saveGoal(goal);

      List<IncomeModel> incomes = await LocalData.getIncomesFromGoal();
      List<ExpenseModel> expenses = await LocalData.getExpensesFromGoal();

      expect(incomes.length, 1);
      expect(expenses.length, 1);
      expect(incomes.first.name, 'Salary');
      expect(expenses.first.name, 'Rent');
    });

    test('Operations with no goal should return false', () async {
      final income = IncomeModel(
        id: '1',
        name: 'Salary',
        amount: 2000.0,
        date: DateTime.now(),
        isFromCurrentGoal: true,
      );

      final expense = ExpenseModel(
        id: '1',
        name: 'Rent',
        amount: 500.0,
        date: DateTime.now(),
        isFromCurrentGoal: true,
      );

      bool addIncomeResult = await LocalData.addIncomeToGoal(income);
      bool addExpenseResult = await LocalData.addExpenseToGoal(expense);
      bool updateIncomeResult = await LocalData.updateIncomeInGoal(income);
      bool updateExpenseResult = await LocalData.updateExpenseInGoal(expense);
      bool removeIncomeResult = await LocalData.removeIncomeFromGoal('1');
      bool removeExpenseResult = await LocalData.removeExpenseFromGoal('1');

      expect(addIncomeResult, false);
      expect(addExpenseResult, false);
      expect(updateIncomeResult, false);
      expect(updateExpenseResult, false);
      expect(removeIncomeResult, false);
      expect(removeExpenseResult, false);

      List<IncomeModel> incomes = await LocalData.getIncomesFromGoal();
      List<ExpenseModel> expenses = await LocalData.getExpensesFromGoal();
      expect(incomes.isEmpty, true);
      expect(expenses.isEmpty, true);
    });
  });
}
