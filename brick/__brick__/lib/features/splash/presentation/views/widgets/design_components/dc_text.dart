import 'package:flutter/material.dart';

import '../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../core/common/presentation/extensions/size/size_extension.dart';
import '../../../../../../core/common/presentation/extensions/theme/theme_extension.dart';
import '../../../../../../core/common/presentation/views/widgets/system/text/app_text_widget.dart';

class DcText extends StatelessWidget {
  const DcText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 16.horizontalPadding,
      child: Column(
        children: [
          // AppText
          AppText(
            LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_this_is_app_text,
            style: context.textStyles.headlineLarge.copyWith(
              color: context.colors.primary,
            ),
          ),
          12.verticalGap,
          AppText.note(
            data: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_text_this_is_a_note_text,
          ),
        ],
      ),
    );
  }
}
