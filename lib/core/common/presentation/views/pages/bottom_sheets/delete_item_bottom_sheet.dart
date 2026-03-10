import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../config/constants/colors/material/material_primitive_colors.dart';
import '../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../config/constants/text/material/app_material_text_primitives.dart';
import '../../../extensions/size/size_extension.dart';
import '../../../extensions/theme/theme_extension.dart';
import '../../../themes/styles/button_style.dart';
import '../../widgets/system/app_button.dart';
import '../../widgets/system/text/app_text_widget.dart';

@RoutePage(name: 'DeleteItemBottomSheetRoute')
class DeleteItemBottomSheet extends StatelessWidget {
  const DeleteItemBottomSheet({
    required this.onDelete,
    required this.description,
    required this.title,
    super.key,
  });
  final VoidCallback onDelete;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with warning icon
        Row(
          children: [
            Container(
              padding: 12.allPadding,
              decoration: BoxDecoration(
                color: AppMaterialPrimitives.error90,
                borderRadius: 12.borderCircular,
              ),
              child: Icon(
                Icons.warning_outlined,
                color: context.colors.error,
                size: 24.sp,
              ),
            ),
            16.horizontalGap,
            Expanded(
              child: AppText(
                '${LocaleKeys.common_words_delete.tr()} ${title}',
                style: context.textStyles.titleLarge.copyWith(
                  fontWeight: AppMaterialTextPrimitives.semibold,
                ),
                translate: false,
              ),
            ),
          ],
        ),

        20.verticalGap,

        // Warning message
        AppText(description, style: context.textStyles.bodyLarge),

        8.verticalGap,

        AppText(
          LocaleKeys
              .core_common_presentation_pages_bottom_sheets_delete_item_bottom_sheet_confirmationMessage,
          style: context.textStyles.bodySmall,
        ),

        20.verticalGap,

        // Action buttons
        Row(
          children: [
            Expanded(
              child: AppButton.stroke(
                onPressed: () => Navigator.of(context).pop(),
                label: LocaleKeys.common_words_cancel,
              ),
            ),
            16.horizontalGap,
            Expanded(
              child: AppButton.custom(
                theme: ButtonStyles.destructiveTheme,
                onPressed: () {
                  onDelete();
                  Navigator.of(context).pop();
                },
                label: LocaleKeys.common_words_delete,
              ),
            ),
          ],
        ),
        24.verticalGap,
      ],
    );
  }
}
