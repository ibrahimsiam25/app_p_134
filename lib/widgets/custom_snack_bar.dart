import 'dart:async';
import 'dart:io';
import 'package:app_p_134/core/constants/app_colors.dart';
import 'package:app_p_134/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 2),
    IconData? icon,
    bool isError = false,
    bool isSuccess = false,
  }) {
    // Default colors based on iOS design
    Color defaultBackgroundColor;
    if (isError) {
      defaultBackgroundColor = Platform.isIOS ? CupertinoColors.systemRed : Colors.red;
    } else if (isSuccess) {
      defaultBackgroundColor = Platform.isIOS ? CupertinoColors.systemGreen : Colors.green;
    } else {
      defaultBackgroundColor = Platform.isIOS 
          ? CupertinoColors.systemGrey6.darkColor 
          : AppColors.black;
    }

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => _IOSStyleSnackBar(
        message: message,
        backgroundColor: backgroundColor ?? defaultBackgroundColor,
        icon: icon,
        isError: isError,
        isSuccess: isSuccess,
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    overlay.insert(overlayEntry);
    Timer(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}

class _IOSStyleSnackBar extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final IconData? icon;
  final bool isError;
  final bool isSuccess;
  final VoidCallback onDismiss;

  const _IOSStyleSnackBar({
    required this.message,
    required this.backgroundColor,
    this.icon,
    this.isError = false,
    this.isSuccess = false,
    required this.onDismiss,
  });

  @override
  State<_IOSStyleSnackBar> createState() => _IOSStyleSnackBarState();
}

class _IOSStyleSnackBarState extends State<_IOSStyleSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Platform.isIOS ? Curves.easeOutBack : Curves.easeOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() async {
    await _animationController.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    
    return Positioned(
      top: topPadding + (Platform.isIOS ? 8 : 20),
      left: Platform.isIOS ? 16 : 20,
      right: Platform.isIOS ? 16 : 20,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: GestureDetector(
            onTap: _dismiss,
            child: Platform.isIOS ? _buildIOSSnackBar() : _buildMaterialSnackBar(),
          ),
        ),
      ),
    );
  }

  Widget _buildIOSSnackBar() {
    IconData? displayIcon = widget.icon;
    if (displayIcon == null) {
      if (widget.isError) {
        displayIcon = CupertinoIcons.exclamationmark_circle_fill;
      } else if (widget.isSuccess) {
        displayIcon = CupertinoIcons.checkmark_circle_fill;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (displayIcon != null) ...[
            Icon(
              displayIcon,
              color: widget.isError || widget.isSuccess 
                  ? CupertinoColors.white 
                  : CupertinoColors.label,
              size: 20,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              widget.message,
              style: AppTextStyles.header14.copyWith(
                color: widget.isError || widget.isSuccess 
                    ? CupertinoColors.white 
                    : CupertinoColors.label,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialSnackBar() {
    IconData? displayIcon = widget.icon;
    if (displayIcon == null) {
      if (widget.isError) {
        displayIcon = Icons.error;
      } else if (widget.isSuccess) {
        displayIcon = Icons.check_circle;
      }
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (displayIcon != null) ...[
              Icon(
                displayIcon,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                widget.message,
                style: AppTextStyles.header14.copyWith(color: AppColors.white),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
