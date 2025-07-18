import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/database/local_date.dart';

class PreloaderScreen extends StatefulWidget {
  const PreloaderScreen({super.key});

  @override
  State<PreloaderScreen> createState() => _PreloaderScreenState();
}

class _PreloaderScreenState extends State<PreloaderScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _navigateToNextScreen() async {
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        if (LocalData.prefs.getBool('isFirstLaunch') != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'homeScreen', (context) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, 'welcomeScreen', (context) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: AppColors.purpleGradient,
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(20)),
            ),
            const Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(
                  color: AppColors.black,
                  backgroundColor: AppColors.irisPurple,
                  strokeWidth: 5.0,
                )),
          ],
        ),
      ),
    ));
  }
}
