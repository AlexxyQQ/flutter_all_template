import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../domain/services/navigation/navigation_service.dart';

/// Shows bottom sheets and popup dialogs from anywhere, with a typed result.
///
/// A modal completes with the value passed to `Navigator.pop(result)`, or with
/// `null` when the user dismisses it normally (tap outside, swipe down, back).
///
/// Widgets pass their own `context`; code without one (services, blocs)
/// omits it and the modal opens on the root navigator through
/// [NavigationService.modalContext]. When no context is available, nothing is
/// shown and the result is `null`.
@lazySingleton
class ModalService {
  const ModalService({required NavigationService navigation})
    : _navigation = navigation;

  final NavigationService _navigation;

  /// Shows a modal bottom sheet built by [builder] (usually an
  /// `AppBottomSheet`).
  Future<T?> showSheet<T>({
    required WidgetBuilder builder,
    BuildContext? context,
    bool isDismissible = true,
    bool isScrollControlled = true,
    bool showDragHandle = true,
  }) async {
    final host = context ?? _navigation.modalContext;
    if (host == null || !host.mounted) {
      return null;
    }
    return showModalBottomSheet<T>(
      context: host,
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
  Future<T?> showPopup<T>({
    required WidgetBuilder builder,
    BuildContext? context,
    bool barrierDismissible = true,
  }) async {
    final host = context ?? _navigation.modalContext;
    if (host == null || !host.mounted) {
      return null;
    }
    return showDialog<T>(
      context: host,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }
}
