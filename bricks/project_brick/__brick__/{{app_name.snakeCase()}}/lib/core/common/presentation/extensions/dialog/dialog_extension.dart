import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../config/constants/gen/locale_keys.g.dart';
import '../../routes/app_router.dart';
import '../../views/pages/dialogs/app_dialog.dart';

/// Dialog helpers built on the app's root [StackRouter].
///
/// `title`/`message`/button texts are localization keys.
extension DialogExtension on BuildContext {
  StackRouter get _rootRouter => router.root;

  /// Pops the route named [name] if it is on top, otherwise removes it from
  /// the stack.
  void _closeRoute(String name) {
    final root = _rootRouter;
    if (root.current.name == name) {
      unawaited(root.maybePop());
    } else {
      root.removeWhere((route) => route.name == name);
    }
  }

  /// Closes the dialog loader.
  void get closeLoader => _closeRoute(AppDialogLoaderRoute.name);

  /// Closes the app dialog.
  void get closeDialog => _closeRoute(AppDialogRoute.name);

  /// Shows the blocking dialog loader.
  void showDialogLoader({Duration? duration}) {
    unawaited(_rootRouter.push(AppDialogLoaderRoute(duration: duration)));
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
    unawaited(
      _rootRouter.push(
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
