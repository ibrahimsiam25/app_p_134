import 'package:app_p_134/core/constants/app_colors.dart';
import 'package:app_p_134/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String title;
  final String hintText;
  final VoidCallback onChanged;

  const TextInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.title,
    required this.hintText,
    required this.onChanged,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateClearButtonVisibility);
    _updateClearButtonVisibility();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateClearButtonVisibility);
    super.dispose();
  }

  void _updateClearButtonVisibility() {
    final shouldShow = widget.controller.text.isNotEmpty;
    if (shouldShow != _showClearButton) {
      setState(() {
        _showClearButton = shouldShow;
      });
    }
  }

  void _clearText() {
    widget.controller.clear();
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontFamily: AppTextStyles.fontMontserrat,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.blackLight,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffFDFCFD),
            border: Border.all(color: AppColors.gray),
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: TextInputType.text,
            maxLength: 18,
            inputFormatters: [
              LengthLimitingTextInputFormatter(18),
            ],
            onChanged: (value) {
              widget.onChanged();
              _updateClearButtonVisibility();
            },
            style: AppTextStyles.header16.copyWith(color: AppColors.blackLight),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTextStyles.header16.copyWith(color: AppColors.gray),
              border: InputBorder.none,
              counterText: '',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              suffixIcon: _showClearButton
                  ? GestureDetector(
                      onTap: _clearText,
                      child: Container(
                        margin: EdgeInsets.only(right: 8.w),
                        child: Icon(
                          Icons.clear,
                          color: AppColors.blackLight,
                          size: 15.sp,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
