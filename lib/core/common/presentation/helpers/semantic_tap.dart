import 'package:flutter/widgets.dart';

/// Wraps [child] in a tappable, accessible button when [onTap] is non-null.
///
/// [label] is announced by screen readers; without it the child's own
/// semantics (if any) are used.
Widget wrapSemanticTap({
  required Widget child,
  VoidCallback? onTap,
  String? label,
}) {
  if (onTap == null) {
    return child;
  }
  return Semantics(
    button: true,
    label: label,
    child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: child,
    ),
  );
}
