import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/number_formatter.dart';
import '../../cubit/homeCubit/home_cubit.dart';
import '../../cubit/homeCubit/home_state.dart';
import 'widgets/balance_card.dart';
import 'widgets/action_buttons.dart';
import 'widgets/transactions_section.dart';

import 'package:flutter_bloc/flutter_bloc.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatelessWidget {
  const _HomeScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.purpleGradient,
            ),
            child: SafeArea(
              bottom: false,
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
                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      return state.isLoading
                          ? const BalanceCard(balance: '\$ 0.00')
                          : BalanceCard(
                              balance: formatCurrency(state.currentAmount)
                            );
                    },
                  ),
                  const SizedBox(height: 30),
                  const ActionButtons(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          const Expanded(
            child: TransactionsSection(),
          ),
        ],
      ),
    );
  }
}