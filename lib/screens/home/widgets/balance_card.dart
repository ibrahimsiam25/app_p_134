import 'package:app_p_134/screens/home/widgets/goal_button.dart';
import 'package:app_p_134/screens/home/widgets/goal_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../cubit/goalCubit/goal_cubit.dart';
import '../../../cubit/goalCubit/goal_state.dart';
import 'goal_status_text.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 26),
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
                  color: AppColors.lightGray,
                ),
              ),
              const SizedBox(height: 5),
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
                      GoalImage(state: state),
                      GoalButton(state: state),
                    ],
                  ),
                ),
              ),
              GoalStatusText(state: state),
            ],
          ),
        );
      },
    );
  }
}