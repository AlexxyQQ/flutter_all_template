import 'package:flutter/material.dart';

import '../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../domain/services/navigation/navigation_service.dart';
import '../../../locator/service_locator.dart';
import '../../routes/app_router.dart';
import '../../views/pages/dialogs/app_dialog.dart';

extension DialogExtension on BuildContext {
  // Close Dialog Loader
  void get closeLoader => sl<NavigationService>().closeSpecificRoute(
    name: AppDialogLoaderRoute.name,
  );
  // Close Dialog
  void get closeDialog =>
      sl<NavigationService>().closeSpecificRoute(name: AppDialogRoute.name);

  // Show Dialog Loader
  void showDialogLoader({Duration? duration}) {
    sl<NavigationService>().push(AppDialogLoaderRoute(duration: duration));
  }

  /// Helper to push the route
  void _pushDialog(
    DialogType type, {
    String? title,
    String? message,
    Widget? customContent,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String? confirmText,
    String? cancelText,
    bool isDismissible = false,
  }) {
    sl<NavigationService>().push(
      AppDialogRoute(
        type: type,
        title: title,
        message: message,
        customContent: customContent,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmText: confirmText,
        cancelText: cancelText,
        isDismissible: isDismissible,
      ),
    );
  }

  // 1. Info
  void showInfoDialog({required String title, required String message}) {
    _pushDialog(
      DialogType.info,
      title: title,
      message: message,
      confirmText: LocaleKeys.common_words_close,
    );
  }

  // 2. Error
  void showErrorDialog({required String title, required String message}) {
    _pushDialog(
      DialogType.error,
      title: title,
      message: message,
      confirmText: LocaleKeys.common_words_dismiss,
    );
  }

  // 3. Confirmation
  void showConfirmationDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String? confirmText,
    String? cancelText,
    VoidCallback? onCancel,
  }) {
    _pushDialog(
      DialogType.confirmation,
      title: title,
      message: message,
      onConfirm: onConfirm,
      confirmText: confirmText ?? LocaleKeys.common_words_yes,
      cancelText: cancelText ?? LocaleKeys.common_words_no,
      onCancel: onCancel,
      isDismissible: true,
    );
  }

  // 4. Custom Widget
  void showCustomDialog({required Widget content, bool isDismissible = true}) {
    _pushDialog(
      DialogType.custom,
      customContent: content,
      isDismissible: isDismissible,
    );
  }
}
