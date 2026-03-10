import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../config/constants/text/material/app_material_text_primitives.dart';
import '../../../../../../config/themes/components_theme/components_theme_exports.dart';
import '../../../../domain/entities/failure.dart';
import '../../../extensions/size/size_extension.dart';
import '../../../extensions/theme/theme_extension.dart';
import '../../components/app_color.dart';
import '../system/app_button.dart';
import '../system/icon/app_icon_widget.dart';
import '../system/images/app_image_widget.dart';
import '../system/images/app_svg_picture_widget.dart';
import '../system/text/app_text_widget.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    this.error,
    this.errorMessage,
    this.icon,
    this.image,
    this.onRetry,
    this.svg,
    this.color,
    this.subtitle,
    super.key,
  }) : assert(
         (error != null) != (errorMessage != null),
         'You must provide either an error or an errorMessage, but not both.',
       ),
       assert(
         !((icon != null && image != null) ||
             (icon != null && svg != null) ||
             (image != null && svg != null)),
         'You can only provide one of icon, image, or svg.',
       );

  final Failure? error;
  final String? errorMessage;
  final VoidCallback?
  onRetry; // Changed Function()? to VoidCallback? for better type safety
  final IconData? icon;
  final String? image;
  final String? svg;
  final KAppColor? color;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    // Determine the main title and subtitle
    // Priority: errorMessage string -> error.message -> default
    final title = errorMessage ?? error?.message ?? 'An error occurred';

    // Attempting to extract 'data' from Failure if it exists (based on your usage example)
    // You might need to adjust this depending on the actual Failure class definition
    final String? effectiveSub = error != null
        ? (error as Failure).data
        : subtitle;

    return Center(
      child: SingleChildScrollView(
        padding: 24.allPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildVisualIndicator(context),
            24.verticalGap,
            AppText(
              title,
              textAlign: TextAlign.center,
              style: context.textStyles.headlineSmall.copyWith(
                fontWeight: AppMaterialTextPrimitives.semibold,
              ),
            ),
            if (effectiveSub != null) ...[
              8.verticalGap,
              AppText(
                effectiveSub,
                textAlign: TextAlign.center,
                style: context.textStyles.bodyLarge,
              ),
            ],
            if (onRetry != null) ...[
              32.verticalGap,
              AppButton.secondary(
                onPressed: onRetry,
                prefix: AppIcon(
                  Icons.refresh,
                  size: 18.r,
                  color: context.colors.onSecondary,
                ),
                label: LocaleKeys.common_sentences_tryAgain,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVisualIndicator(BuildContext context) {
    final double size = 120.r;

    if (svg != null) {
      return AppSvgPicture.fromAsset(svg!, height: size, width: size);
    }

    if (image != null) {
      return AppImage.fromAsset(
        image!,
        height: size,
        width: size,
        theme: const PictureTheme(fit: BoxFit.contain),
      );
    }

    // Default or Custom Icon
    return AppIcon(
      icon ?? Icons.error_outline_rounded,
      size: size,
      color: color ?? context.colors.error, // Semantic error color
    );
  }
}
