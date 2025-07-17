import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/asstes.dart';
import 'widgets/balance_card.dart';
import 'widgets/action_buttons.dart';
import 'widgets/transactions_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.purpleGradient,
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 40,
                        height: 40,
                      ),
                      Text(
                        'Welcome',
                        style: AppTextStyles.header18.copyWith(
                          color: AppColors.whiteDark,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'settingsScreen');
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.whiteDark,
                          ),
                          child: Image.asset(
                            Assets.imagesSettings,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // Balance Card with Create Goal
                const BalanceCard(balance: '\$ 0,01'),
                
                const SizedBox(height: 30),
                
                // Action Buttons
                const ActionButtons(),
                
                // Transactions Section
                TransactionsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
