import 'package:app_p_134/core/constants/assets.dart';
import 'package:app_p_134/core/helpers/goal_tree_helper.dart';
import 'package:app_p_134/cubit/goalCubit/goal_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoalImage extends StatelessWidget {
  final GoalState state;

  const GoalImage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    String imageAsset;

    // Check for specific types and cast them
    if (state is InProgressGoalState) {
      final inProgressState = state as InProgressGoalState; 
      imageAsset = GoalTreeHelper.getTreeImageForPercent(inProgressState.progressPercentage);
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
}
