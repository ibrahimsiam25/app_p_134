import 'package:app_p_134/core/constants/app_colors.dart';
import 'package:app_p_134/core/constants/app_text_styles.dart';
import 'package:app_p_134/core/constants/assets.dart';
import 'package:app_p_134/cubit/goalCubit/goal_state.dart';
import 'package:app_p_134/screens/home/widgets/success_dialog.dart';
import 'package:app_p_134/widgets/coustom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/database/local_date.dart';


class GoalButton extends StatelessWidget {
  final GoalState state;

  const GoalButton({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is NoGoalState) {
      // Show "Create a goal" button
      return _buildActionButton(
        context: context,
        text: 'Create a goal  ',
        onTap: () {
          Navigator.pushNamed(context, 'createGoalScreen');
        },
      );
    } else if (state is GoalAchievedState) {
      return _buildActionButton(
        context: context,
        text: 'Create new goal',
        onTap: () => _showSuccessDialog(context),
      );
    } else if (state is GoalFailedState) {
      final failedState = state as GoalFailedState; // Cast to GoalFailedState
      // Show "Change a goal" button
      return _buildActionButton(
        context: context,
        text: 'Change a goal',
        onTap: () => _showChangeGoalDialog(context, failedState),
      );
    } else {
      // InProgressGoalState - hide the button
      return const SizedBox.shrink();
    }
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Assets.imagesAddGoal,
              width: 44.w,
              height: 44.w,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: AppTextStyles.header14,
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    SuccessDialog.show(
      context,
      onCreateNew: () {
            Navigator.of(context).pop();
        Navigator.pushNamed(context, 'createGoalScreen');
      },
      onOk: () {
           Navigator.of(context).pop();
      },
    );
  }

  void _showChangeGoalDialog(BuildContext context, GoalFailedState state) {
    showDialog(
        context: context,
        builder: (context) => CoustomDialog(
      onPrimary: () async {
        Navigator.pop(context);
           await LocalData.deleteCurrentGoal();
      },
      onSecondary: () {
        Navigator.pop(context);
              Navigator.pushNamed(
            context, 
            'changeGoalScreen',
            arguments: {
              'initialGoalAmount': state.goal.amount,
              'initialDeadline': state.goal.deadline,
            },
          );
      },
      title: "Time to update your goal",
      message:
          "It looks like you didn't reach your goal by the deadline. No problem! You can easily edit it or create a new one.",
      primaryLabel: "Delete",
      secondaryLabel: "Change",
    ),
      );
  }
}


