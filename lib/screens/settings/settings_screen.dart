import 'package:app_p_134/widgets/exit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/database/local_date.dart';
import '../../widgets/custom_back_app_bar.dart';
import '../../widgets/custom_snack_bar.dart';
import 'widgets/setting_card.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showNotificationsSettings(BuildContext context) {
    CustomSnackBar.show(
      context,
      message: 'Notification settings will be available soon!',
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    CustomSnackBar.show(
      context,
      message: 'Privacy Policy will be displayed here',
    );
  }

  void _shareApp(BuildContext context) async {
    try {
      await Share.share(
        'Check out this amazing finance app!',
        subject: 'Finance App Recommendation',
      );
    } catch (e) {
      CustomSnackBar.show(
        context,
        message: 'Unable to share app',
        isError: true,
      );
    }
  }

  void _rateApp(BuildContext context) async {
    // For demonstration purposes, showing a snack bar
    // In real app, you would open the app store
    CustomSnackBar.show(
      context,
      message: 'Thank you for rating our app!',
      isSuccess: true,
    );
  }

  void _showClearDataDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) =>  ExitDialog(
      title: 'Delete Everything?',
      message: 'This action can\'t be undone.',
      actionLabel: 'Delete',
      onCancel: () => Navigator.of(context).pop(),
      onAction: () async {
        Navigator.of(context).pop();
        await _clearAllData(context);
      },
    ),
      );
  
  }

  Future<void> _clearAllData(BuildContext context) async {
    try {
      // Clear current goal data
      await LocalData.deleteCurrentGoal();
      
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
                    onTap: () => _showNotificationsSettings(context),
                  ),
                  
                  SettingCard(
                    title: 'Privacy Policy',
                    onTap: () => _showPrivacyPolicy(context),
                  ),
                 
                  SettingCard(
                    title: 'Share App',
                    onTap: () => _shareApp(context),
                  ),
                 
                  SettingCard(
                    title: 'Rate Us',
                    onTap: () => _rateApp(context),
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
