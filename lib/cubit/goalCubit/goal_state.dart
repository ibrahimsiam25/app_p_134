import '../../models/goal_model.dart';

abstract class GoalState {
  const GoalState();
}

// When no goal is created yet
class NoGoalState extends GoalState {
  const NoGoalState();
}

// When a goal is in progress (not yet achieved or failed)
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

// When the goal is achieved before the deadline
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

// When the deadline is passed and goalAmount is not reached
class GoalFailedState extends GoalState {
  final GoalModel goal;
  final double currentAmount;
  final double progressPercentage;

  const GoalFailedState({
    required this.goal,
    required this.currentAmount,
    required this.progressPercentage,
  });
}
