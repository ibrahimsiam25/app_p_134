import 'package:app_p_134/widgets/coustom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/database/local_date.dart';
import '../../cubit/goalCubit/goal_cubit.dart';
import '../../widgets/custom_back_app_bar.dart';
import '../../widgets/custom_snack_bar.dart';
import 'widgets/setting_card.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  


  

  void _showClearDataDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) =>  CoustomDialog(
      title: 'Delete Everything?',
      message: 'This action can\'t be undone.',
         primaryLabel:'Delete', 
          secondaryLabel: "Cancel",

      onSecondary: () => Navigator.of(context).pop(),
      onPrimary: () async {
        Navigator.of(context).pop();
        await _clearAllData(context);
      },
    ),
      );
  
  }

  Future<void> _clearAllData(BuildContext context) async {
    try {
      await LocalData.deleteCurrentGoal();
      await LocalData.clearAllTransactions();
      if (context.mounted) {
        context.read<GoalCubit>().refreshState();
      }
      Navigator.of(context).pop();
      CustomSnackBar.show(
        context,
        message: 'All data cleared successfully!',
        isSuccess: true,
      );
    } catch (e) {
      CustomSnackBar.show(
        context,
        message: 'Failed to clear data. Please try again.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomBackAppBar(
        title: 'Settings',
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w,),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.purpleGradient,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  SettingCard(
                    title: 'Notifications',
                    onTap:() {}
                  ),
                  
                  SettingCard(
                    title: 'Privacy Policy',
                    onTap: () {}
                  ),
                 
                  SettingCard(
                    title: 'Share App',
                    onTap: () {}
                  ),
                 
                  SettingCard(
                    title: 'Rate Us',
                    onTap: () {}
                  ),
                  
                  SettingCard(
                    title: 'Clear Data',
                    onTap: () => _showClearDataDialog(context),
                    isLast: true,
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
