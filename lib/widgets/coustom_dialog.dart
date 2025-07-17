import 'dart:ui';

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';

class CoustomDialog extends StatelessWidget {
  final Function()? onAllow;
  final VoidCallback cansel;
  final String textOne;
  final String textTwo;
  final String actionText;
  final String textCencel;
  final Color color;
  final double height;

  const CoustomDialog({
    super.key,
    this.onAllow,
    this.textCencel = 'Cancel',
    required this.cansel,
    required this.textOne,
    required this.textTwo,
    this.actionText = 'Delete',
    this.color = AppColors.red,
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: AppColors.white,
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          height: height,
          width: 330,
          child: Column(
            children: [
              const Spacer(),
              Text(
                textOne,
                style: AppTextStyles.header18.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 17, top: 5),
                child: Text(
                  textAlign: TextAlign.center,
                  textTwo,
                  style:
                      AppTextStyles.header16.copyWith(color: AppColors.black),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: cansel,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 48),
                      decoration: BoxDecoration(
                        color: AppColors.royalBlue,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        textCencel,
                        style: AppTextStyles.header18
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onAllow,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        actionText,
                        style: AppTextStyles.header18.copyWith(
                            fontWeight: FontWeight.w600, color: color),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
