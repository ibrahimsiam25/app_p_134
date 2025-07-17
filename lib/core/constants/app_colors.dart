import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0xff0F0F0F);
  static const Color gren = Color(0xff70E284);
  static const Color lightGray = Color(0xffF2F2F2);
  static const Color royalBlue = Color(0xff2B48EB);
  static const Color red = Color(0xffDE2828);
  static const Color lavenderPurple = Color(0xff9163F6);
  static const Color royalPurple = Color(0xff673BC3);
  static const Color irisPurple = Color(0xff6E45C0);
  static const LinearGradient purpleGradient = LinearGradient(
            colors: [
              AppColors.lavenderPurple,
              AppColors.royalPurple,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ) ;
}
