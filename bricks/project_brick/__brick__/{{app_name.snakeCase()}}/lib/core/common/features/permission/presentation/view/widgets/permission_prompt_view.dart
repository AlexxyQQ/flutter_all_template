import 'package:flutter/material.dart';

import '../../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../presentation/extensions/size/size_extension.dart';
import '../../../../../presentation/views/widgets/system/app_button.dart';
import '../../../../../presentation/views/widgets/system/text/app_text_widget.dart';
import '../../../permission_spec.dart';

/// Illustration, title, explanation and the continue / maybe-later buttons
/// for one [PermissionSpec].
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
    final imageAsset = spec.imageAsset;
    return SafeArea(
      child: Padding(
        padding: 16.allPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageAsset != null)
              Image.asset(imageAsset, height: 200, width: 200)
            else
              Icon(spec.icon, size: 120, color: theme.colorScheme.primary),
            24.verticalGap,
            AppText(
              spec.titleKey,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            12.verticalGap,
            Padding(
              padding: 32.horizontalPadding,
              child: AppText(
                spec.messageKey,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
            ),
            32.verticalGap,
            AppButton.primary(
              isLoading: isLoading,
              onPressed: onContinue,
              label: LocaleKeys.common_words_continue,
            ),
            20.verticalGap,
            AppButton.ghost(
              isDisabled: isLoading,
              onPressed: onSkip,
              label: LocaleKeys.common_sentences_mayBeLater,
            ),
            48.verticalGap,
          ],
        ),
      ),
    );
  }
}
