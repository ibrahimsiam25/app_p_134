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

  InProgressGoalState copyWith({
    GoalModel? goal,
    double? currentAmount,
    double? progressPercentage,
  }) {
    return InProgressGoalState(
      goal: goal ?? this.goal,
      currentAmount: currentAmount ?? this.currentAmount,
      progressPercentage: progressPercentage ?? this.progressPercentage,
    );
  }
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

  GoalAchievedState copyWith({
    GoalModel? goal,
    double? currentAmount,
    bool? isFirstTimeAchieved,
  }) {
    return GoalAchievedState(
      goal: goal ?? this.goal,
      currentAmount: currentAmount ?? this.currentAmount,
      isFirstTimeAchieved: isFirstTimeAchieved ?? this.isFirstTimeAchieved,
    );
  }
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

  GoalFailedState copyWith({
    GoalModel? goal,
    double? currentAmount,
    double? progressPercentage,
    bool? isFirstTimeFailure,
  }) {
    return GoalFailedState(
      goal: goal ?? this.goal,
      currentAmount: currentAmount ?? this.currentAmount,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      isFirstTimeFailure: isFirstTimeFailure ?? this.isFirstTimeFailure,
    );
  }
}