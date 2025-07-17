import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_images.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/database/local_date.dart';
import '../../widgets/app_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.lavenderPurple,
              AppColors.royalPurple,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('WTS APP NAME',
                textAlign: TextAlign.center, style: AppTextStyles.header32),
            Text(
              'Set a financial goal and watch as a lush,\nhealthy plant grows from a tiny sprout\nwith every contribution you make.\nEvery dollar saved is a drop of water for its\ngrowth!',
              textAlign: TextAlign.center,
              style: AppTextStyles.header16,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 30 / 852 * MediaQuery.of(context).size.height,
              ),
              child: Image.asset(
             Assets.imagesWelcomeImage
              ),
            ),
            AppButton(
              margin: 26,
              width: double.infinity,
              text: 'Begin',
              onTap: () {
                LocalData.prefs.setBool('isFirstLaunch', true);
                Navigator.pushNamedAndRemoveUntil(
                    context, 'homeScreen', (context) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
