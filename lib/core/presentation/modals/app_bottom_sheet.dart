import 'package:flutter/material.dart';

/// Themed content frame for a modal bottom sheet: optional title,
/// scrollable [child] and optional [actions]. It keeps clear of the keyboard
/// and the system insets, so text fields inside it stay visible.
///
/// Present it through `ModalService.showSheet`; pop with
/// `Navigator.of(context).pop(result)` to return a typed result.
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    required this.child,
    this.title,
    this.actions = const [],
    super.key,
  });

  /// Optional heading, already localized by the caller.
  final String? title;

  final Widget child;

  /// Buttons laid out in a trailing row under [child].
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: 12, bottom: keyboard),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                child: Text(title!, style: theme.textTheme.titleLarge),
              ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: child,
              ),
            ),
            if (actions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: OverflowBar(
                  alignment: MainAxisAlignment.end,
                  overflowAlignment: OverflowBarAlignment.end,
                  spacing: 8,
                  children: actions,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
