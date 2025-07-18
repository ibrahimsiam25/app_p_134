import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/assets.dart';
import '../../../core/helpers/goal_tree_helper.dart';
import '../../../cubit/goalCubit/goal_cubit.dart';
import '../../../cubit/goalCubit/goal_state.dart';
import '../../../core/constants/number_formatter.dart';
import 'success_dialog.dart';


class BalanceCard extends StatelessWidget {
  final String balance;
  
  const BalanceCard({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalCubit, GoalState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 26,),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FINANCE\nDASHBOARD',
                textAlign: TextAlign.start,
                style: AppTextStyles.header32,
              ),
              Text(
                balance,
                style: AppTextStyles.header24.copyWith(
                  color: AppColors.lightGray
                ),
              ),
              _buildGoalStatusText(state),
              const SizedBox(height:5),
              Center(
                child: Container(
                  width: 210.w,
                  height: 210.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.whiteDark,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Tree/Plant image based on progress
                      _buildGoalImage(state),
                      // Action button based on state
                      _buildGoalButton(context, state),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGoalStatusText(GoalState state) {
    if (state is InProgressGoalState) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          'Financial goal Saved: ${formatCurrency(state.currentAmount)} / ${formatCurrency(state.goal.amount)}',
          style: AppTextStyles.header14.copyWith(
            color: AppColors.gray,
          ),
        ),
      );
    } else if (state is GoalAchievedState) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          'Financial goal achieved',
          style: AppTextStyles.header14.copyWith(
            color: AppColors.green,
          ),
        ),
      );
    } else if (state is GoalFailedState) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          'Financial goal not achieved',
          style: AppTextStyles.header14.copyWith(
            color: AppColors.red,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildGoalImage(GoalState state) {
    String imageAsset;
    
    if (state is InProgressGoalState) {
      imageAsset = GoalTreeHelper.getTreeImageForPercent(state.progressPercentage);
    } else if (state is GoalAchievedState) {
      imageAsset = Assets.imagesGoalAchieved5;
    } else if (state is GoalFailedState) {
      imageAsset = Assets.imagesGoalNotAchieved;
    } else {
      // NoGoalState
      imageAsset = Assets.imagesGoalInitalAchieved;
    }

    return Image.asset(
      imageAsset,
      height: 136.w,
      fit: BoxFit.cover,
    );
  }

  Widget _buildGoalButton(BuildContext context, GoalState state) {
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
      // Show "Create new goal" button
      return _buildActionButton(
        context: context,
        text: 'Create new goal',
        onTap: () {
          _showSuccessDialog(context);
        },
      );
    } else if (state is GoalFailedState) {
      // Show "Change a goal" button
      return _buildActionButton(
        context: context,
        text: 'Change a goal',
        onTap: () {
          Navigator.pushNamed(
            context, 
            'changeGoalScreen',
            arguments: {
              'initialGoalAmount': state.goal.amount,
              'initialDeadline': state.goal.deadline,
            },
          );
        },
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
        Navigator.pushNamed(context, 'createGoalScreen');
      },
      onOk: () {
        // Just dismiss the dialog
      },
    );
  }
}
