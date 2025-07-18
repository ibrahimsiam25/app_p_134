import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../cubit/goalCubit/goal_state.dart';

class GoalStatusText extends StatelessWidget {
  const GoalStatusText({
    super.key,
    required this.state,
  });

  final GoalState state;

  @override
  Widget build(BuildContext context) {
    if (state is InProgressGoalState) {
      final inProgressState = state as InProgressGoalState;
      return Padding(
        padding: const EdgeInsets.only(top: 7.0),
        child: Center(
          child: Column(
            children: [
              Text(
                'Financial goal  ',
                style: AppTextStyles.header18.copyWith(
                  color: AppColors.whiteDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Saved: \$${inProgressState.currentAmount.toStringAsFixed(0)} / \$${inProgressState.goal.amount.toStringAsFixed(0)}',
                style: AppTextStyles.header16.copyWith(
                  color: AppColors.whiteDark,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ), 
        ),
      );
    } else if (state is GoalAchievedState) {
      final achievedState = state as GoalAchievedState;
      return Padding(
        padding: const EdgeInsets.only(top: 7.0),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'Financial goal achieved',
                  style: AppTextStyles.header18.copyWith(
                    color: AppColors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Saved: \$${achievedState.currentAmount.toStringAsFixed(0)} / \$${achievedState.goal.amount.toStringAsFixed(0)}',
                style: AppTextStyles.header16.copyWith(
                  color: AppColors.whiteDark,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      );
    } else if (state is GoalFailedState) {
      final failedState = state as GoalFailedState;
      return Padding(
        padding: const EdgeInsets.only(top: 7.0),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'Financial goal not achieved',
                  style: AppTextStyles.header18.copyWith(
                    color: AppColors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Saved: \$${failedState.currentAmount.toStringAsFixed(0)} / \$${failedState.goal.amount.toStringAsFixed(0)}',
                style: AppTextStyles.header16.copyWith(
                  color: AppColors.whiteDark,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
