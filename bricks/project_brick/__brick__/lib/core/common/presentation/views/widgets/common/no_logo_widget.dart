import 'package:flutter/material.dart';

import '../../../extensions/text/text_case_extension.dart';
import '../../../extensions/theme/theme_extension.dart';
import '../system/text/app_text_widget.dart';

class NoLogoWidget extends StatelessWidget {
  const NoLogoWidget({super.key, this.title});
  final String? title;

  @override
  Widget build(BuildContext context) {
    // trim the title and get the first letter
    final trimmedTitle = title?.replaceAll(' ', '').trim();
    return Center(
      child: AppText(
        (trimmedTitle != null && trimmedTitle.isNotEmpty)
            ? trimmedTitle[0].toTitleCase
            : 'C',
        translate: false,
        style: context.textStyles.bodyLarge,
      ),
    );
  }
}
