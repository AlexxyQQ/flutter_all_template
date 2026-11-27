import 'package:flutter/material.dart';

/// Shows bottom sheets and popup dialogs with a typed result.
///
/// Stateless: there is nothing to inject or provide. Pass the `context` of
/// the widget that opens the modal. A modal completes with the value passed
/// to `Navigator.pop(result)`, or with `null` when the user dismisses it
/// normally (tap outside, swipe down, back).
abstract final class ModalService {
  /// Shows a modal bottom sheet built by [builder] (usually an
  /// `AppBottomSheet`).
  static Future<T?> showSheet<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isDismissible = true,
    bool isScrollControlled = true,
    bool showDragHandle = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      isScrollControlled: isScrollControlled,
      showDragHandle: isDismissible && showDragHandle,
      builder: builder,
    );
  }

  /// Shows a popup dialog built by [builder] (usually an `AppPopupDialog`).
  static Future<T?> showPopup<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }
}
