import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0xff0F0F0F);
  static const Color blackLight = Color(0xff0F0F0F);
  static const Color whiteDark = Color(0xffFDFCFD);
  static const Color green = Color(0xff70E284);
  static const Color lightGray = Color(0xffF2F2F2);
  static const Color royalBlue = Color(0xff2B48EB);
  static const Color red = Color(0xffDE2828);
  static const Color lavenderPurple = Color(0xff9163F6);
  static const Color royalPurple = Color(0xff673BC3);
  static const Color irisPurple = Color(0xff6E45C0);
  static const Color darkPurple = Color(0xff1E1240);
  static const Color gray = Color(0xffAFAEAE);
  static const Color blue = Color(0xff007AFF);
  
  static const LinearGradient purpleGradient = LinearGradient(
            colors: [
              AppColors.lavenderPurple,
              AppColors.royalPurple,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ) ;

  static const LinearGradient backgroundGradient = LinearGradient(
            colors: [
              Color(0xffF3DDFA),
              Color(0xffFBE9F3),
            ],
            begin: Alignment(-0.5, -0.87), // Approximates 138.26 degrees
            end: Alignment(0.5, 0.87),
          );

          
}
