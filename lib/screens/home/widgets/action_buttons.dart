import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/assets.dart';
import '../../add _income_and_expense/add_income_screen.dart';



class ActionButton extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;
  
  const ActionButton({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: AppColors. whiteDark ,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
          width: 44.w,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: AppTextStyles.header14,
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ActionButton(
            title: 'Add Income  ',
            iconPath: Assets.imagesIncome,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddIncomeScreen(),
                ),
              );
            },
          ),
          ActionButton(
            title: 'Add Expense  ',
            iconPath: Assets.imagesExpense,
            onTap: () {
              // Navigate to add expense screen
            },
          ),
        ],
      ),
    );
  }
}
