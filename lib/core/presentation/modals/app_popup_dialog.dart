import 'package:flutter/material.dart';

/// Themed popup frame (a Material [AlertDialog]) with an optional title,
/// [content] and [actions]. Present it through `ModalService.showPopup`; pop
/// with `Navigator.of(context).pop(result)` to return a typed result.
class AppPopupDialog extends StatelessWidget {
  const AppPopupDialog({
    required this.content,
    this.title,
    this.actions = const [],
    super.key,
  });

  /// Optional heading, already localized by the caller.
  final String? title;

  final Widget content;

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title == null ? null : Text(title!),
      content: SingleChildScrollView(child: content),
      actions: actions.isEmpty ? null : actions,
    );
  }
}
