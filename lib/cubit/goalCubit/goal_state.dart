import '../../models/goal_model.dart';

abstract class GoalState {
  const GoalState();
}


class NoGoalState extends GoalState {
  const NoGoalState();
}

class InProgressGoalState extends GoalState {
  final GoalModel goal;
  final double currentAmount;
  final double progressPercentage;

  const InProgressGoalState({
    required this.goal,
    required this.currentAmount,
    required this.progressPercentage,
  });
}

class GoalAchievedState extends GoalState {
  final GoalModel goal;
  final double currentAmount;
  final bool isFirstTimeAchieved;

  const GoalAchievedState({
    required this.goal,
    required this.currentAmount,
    required this.isFirstTimeAchieved,
  });
}

class GoalFailedState extends GoalState {
  final GoalModel goal;
  final double currentAmount;
  final double progressPercentage;
  final bool isFirstTimeFailure;

  const GoalFailedState({
    required this.goal,
    required this.currentAmount,
    required this.progressPercentage,
    required this.isFirstTimeFailure,
  });
}
