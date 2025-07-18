import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/assets.dart';


class BalanceCard extends StatelessWidget {
  final String balance;
  
  const BalanceCard({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
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
                  // Tree/Plant image in background
                  Image.asset(
                    Assets.imagesGoalInitalAchieved,
                   height: 136.w,
                   fit: BoxFit.cover,

                  ),
                  // Create a goal button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'createGoalScreen');
                    },
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
                            'Create a goal  ',
                            style: AppTextStyles.header14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
