import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Needed for styling the action button
import '../../helpers/snackbar_helper.dart';

extension SnackBarExtension on BuildContext {
  /// Displays a floating GREEN snackbar for success messages.
  void showSuccessSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    Widget? prefix,
    Widget? suffix,
  }) {
    SnackbarHelper.showTop(
      context: this,
      message: message,
      duration: duration,
      // onTap: onTap,
      prefixIcon: prefix,
      suffixIcon: suffix,
    );
  }

  /// Displays a floating RED snackbar for error messages.
  void showErrorSnackBar({
    String? message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    Widget? prefix,
    Widget? suffix,
  }) {
    if (message != null && message.isNotEmpty) {
      SnackbarHelper.showTop(
        context: this,
        message: message,
        isError: true,
        duration: duration,
        // onTap: onTap,
        prefixIcon: prefix,
        suffixIcon: suffix,
      );
    }
  }

  /// Displays the full-width TOP notification (Covers status bar).
  /// Use this for connection errors or system alerts.
  void showTopSnackBar({
    required String title,
    String? message,
    bool isError = false,
    Duration duration = const Duration(seconds: 4),
    Widget? prefix,
    Widget? suffix,
    Alignment alignment = Alignment.center,
  }) {
    SnackbarHelper.showTop(
      context: this,
      message: title,
      details: message,
      isError: isError,
      duration: duration,
      prefixIcon: prefix,
      suffixIcon: suffix,
      alignment: alignment,
    );
  }

  /// Displays a standard fixed BOTTOM snackbar.
  /// Use this for generic "Undo" actions or simple info.
  void showStandardSnackBar({
    required String message,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
    bool isError = false,
  }) {
    // Helper to convert SnackBarAction into a widget for the overlay
    Widget? actionWidget;

    if (action != null) {
      actionWidget = TextButton(
        onPressed: action.onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          action.label.toUpperCase(),
          style: TextStyle(
            color: Colors.white, // Or use context.readColors.white
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
      );
    }

    SnackbarHelper.showBottom(
      context: this,
      message: message,
      isError: isError,
      duration: duration,
      suffixIcon: actionWidget, // Pass the converted action here
    );
  }
}
