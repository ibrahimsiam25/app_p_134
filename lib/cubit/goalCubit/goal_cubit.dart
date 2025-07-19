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
  
    _transactionsSubscription = LocalData.transactionsStream.listen((_) {
      _updateGoalState();
    });
    

    _updateGoalState();
  }

  Future<void> _updateGoalState() async {
    try {
     
      GoalModel? goal = await LocalData.getCurrentGoal();
      
      if (goal == null) {
        emit(const NoGoalState());
        return;
      }

  
      double currentAmount = await LocalData.getCurrentAmount();
  
      double progressPercentage = goal.calculateProgressPercentage(currentAmount);
      
   
      bool isAchieved = goal.isAchievedWith(currentAmount);
   
      bool isDeadlinePassed = goal.deadline != null && 
                             DateTime.now().isAfter(goal.deadline!);
      
      if (isAchieved) {
       
        bool isFirstTimeAchieved = !goal.hasShownSuccessDialog;
        
       
        if (isFirstTimeAchieved) {
          GoalModel updatedGoal = goal.copyWith(hasShownSuccessDialog: true);
          await LocalData.saveGoal(updatedGoal);
        }
        
        emit(GoalAchievedState(
          goal: goal,
          currentAmount: currentAmount,
          isFirstTimeAchieved: isFirstTimeAchieved,
        ));
      } else if (isDeadlinePassed) {
     
        bool isFirstTimeFailure = !goal.hasShownFailureDialog;
        

        if (isFirstTimeFailure) {
          GoalModel updatedGoal = goal.copyWith(hasShownFailureDialog: true);
          await LocalData.saveGoal(updatedGoal);
        }
        
        emit(GoalFailedState(
          goal: goal,
          currentAmount: currentAmount,
          progressPercentage: progressPercentage,
          isFirstTimeFailure: isFirstTimeFailure,
        ));
      } else {
        emit(InProgressGoalState(
          goal: goal,
          currentAmount: currentAmount,
          progressPercentage: progressPercentage,
        ));
      }
    } catch (e) {
      emit(const NoGoalState());
    }
  }


  Future<void> refreshState() async {
    await _updateGoalState();
  }

  @override
  Future<void> close() {
    _transactionsSubscription?.cancel();
    return super.close();
  }
}
