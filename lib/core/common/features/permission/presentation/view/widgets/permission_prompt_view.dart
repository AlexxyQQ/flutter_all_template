import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../permission_spec.dart';

/// Icon, title, explanation and the continue / maybe-later buttons for one
/// [PermissionSpec].
class PermissionPromptView extends StatelessWidget {
  const PermissionPromptView({
    required this.spec,
    required this.onContinue,
    required this.onSkip,
    super.key,
    this.isLoading = false,
  });

  final PermissionSpec spec;
  final VoidCallback onContinue;
  final VoidCallback onSkip;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(spec.icon, size: 96, color: theme.colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              spec.titleKey.tr(),
              key: const Key('permission_title'),
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              spec.messageKey.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Semantics(
              identifier: 'permission_continue_button',
              child: ElevatedButton(
                key: const Key('permission_continue_button'),
                onPressed: isLoading ? null : onContinue,
                child: isLoading
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(LocaleKeys.common_words_continue.tr()),
              ),
            ),
            const SizedBox(height: 12),
            Semantics(
              identifier: 'permission_skip_button',
              child: TextButton(
                key: const Key('permission_skip_button'),
                onPressed: isLoading ? null : onSkip,
                child: Text(LocaleKeys.common_sentences_mayBeLater.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
