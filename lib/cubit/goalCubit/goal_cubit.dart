import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/database/local_date.dart';
import '../../models/goal_model.dart';
import '../../models/transaction_model.dart';
import 'goal_state.dart';

class GoalCubit extends Cubit<GoalState> {
  StreamSubscription<List<TransactionModel>>? _transactionsSubscription;

  GoalCubit() : super(const NoGoalState()) {
    _initializeCubit();
  }

  void _initializeCubit() {
    // Listen to transactions changes
    _transactionsSubscription = LocalData.transactionsStream.listen((_) {
      _updateGoalState();
    });
    
    // Initial state check
    _updateGoalState();
  }

  Future<void> _updateGoalState() async {
    try {
      // Get current goal
      GoalModel? goal = await LocalData.getCurrentGoal();
      
      if (goal == null) {
        emit(const NoGoalState());
        return;
      }

      // Get current amount (balance)
      double currentAmount = await LocalData.getCurrentAmount();
      
      // Calculate progress percentage
      double progressPercentage = goal.calculateProgressPercentage(currentAmount);
      
      // Check if goal is achieved
      bool isAchieved = goal.isAchievedWith(currentAmount);
      print("----------------------------${goal.deadline}"); 
      // Check if goal is failed (deadline passed and not achieved)
      bool isDeadlinePassed = goal.deadline != null && 
                             DateTime.now().isAfter(goal.deadline!);
      
      if (isAchieved) {
        emit(GoalAchievedState(
          goal: goal,
          currentAmount: currentAmount,
        ));
      } else if (isDeadlinePassed) {
        emit(GoalFailedState(
          goal: goal,
          currentAmount: currentAmount,
          progressPercentage: progressPercentage,
        ));
      } else {
        emit(InProgressGoalState(
          goal: goal,
          currentAmount: currentAmount,
          progressPercentage: progressPercentage,
        ));
      }
    } catch (e) {
      print('Error updating goal state: $e');
      emit(const NoGoalState());
    }
  }

  // Force refresh the state (useful after creating/updating goals)
  Future<void> refreshState() async {
    await _updateGoalState();
  }

  @override
  Future<void> close() {
    _transactionsSubscription?.cancel();
    return super.close();
  }
}
