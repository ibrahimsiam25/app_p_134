import 'package:flutter/material.dart';
import '../../screens/add _income_and_expense/add_income_screen.dart';
import '../../screens/add _income_and_expense/add_expense_screen.dart';
import '../../screens/create_goal/create_goal_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/home/all_transactions_screen.dart';
import '../../screens/preloader/preloader_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/welcome/welcome_screen.dart';

class AppRoute {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => const PreloaderScreen(),
    'welcomeScreen': (context) => const WelcomeScreen(),
    'homeScreen': (context) => const HomeScreen(),
    'settingsScreen': (context) => const SettingsScreen(),
    'createGoalScreen': (context) => const CreateGoalScreen(),
    'addIncomeScreen': (context) => const AddIncomeScreen(),
    'addExpenseScreen': (context) => const AddExpenseScreen(),
    'allTransactionsScreen': (context) => const AllTransactionsScreen(),
  };
}
