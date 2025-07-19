import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/assets.dart';
import '../../core/database/local_date.dart';
import '../../core/constants/number_formatter.dart';
import '../../models/transaction_model.dart';
import 'widgets/balance_card.dart';
import 'widgets/action_buttons.dart';
import 'widgets/transactions_section.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double currentAmount = 0.0;
  bool isLoading = true;
  StreamSubscription<List<TransactionModel>>? _transactionsSubscription;

  @override
  void initState() {
    super.initState();
    _loadCurrentAmount();
    _listenToTransactions();
  }

  @override
  void dispose() {
    _transactionsSubscription?.cancel();
    super.dispose();
  }

  void _listenToTransactions() {
    _transactionsSubscription = LocalData.transactionsStream.listen((transactions) {
      if (mounted) {
        // Calculate amount from the transactions received via stream
        double totalIncome = 0.0;
        double totalExpense = 0.0;
        
        for (var transaction in transactions) {
          if (transaction.isIncome) {
            totalIncome += transaction.amount;
          } else {
            totalExpense += transaction.amount;
          }
        }
        
        setState(() {
          currentAmount = totalIncome - totalExpense;
          isLoading = false;
        });
      }
    });
  }

  Future<void> _loadCurrentAmount() async {
    try {
      double amount = await LocalData.getCurrentAmount();
      setState(() {
        currentAmount = amount;
        isLoading = false;
      });
    } catch (e) {

      setState(() {
        isLoading = false;
      });
    }
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.white,
    body: Column(
      children: [
        // Section 1 - 66% height with scaling
        Expanded(
          flex: 66,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.purpleGradient,
            ),
            child: SafeArea(
              bottom: false,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.66,
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
                      // Balance Card with Real Balance
                      isLoading
                          ? const BalanceCard(balance: '\$ 0.00')
                          : BalanceCard(
                              balance: formatCurrency(currentAmount)
                            ),
                      
                      const SizedBox(height: 30),
                      
                      // Action Buttons
                      const ActionButtons(),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        
        // Section 2 - 34% height with scaling
        Expanded(
          flex: 34,
          child: Container(
            width: double.infinity,
            color: AppColors.white,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.34,
                child: const TransactionsSection(),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}
