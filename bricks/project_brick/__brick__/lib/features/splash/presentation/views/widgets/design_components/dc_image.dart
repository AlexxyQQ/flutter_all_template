// ignore_for_file: avoid_hardcoded_strings_in_widgets
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../config/constants/colors/material/material_primitive_colors.dart';
import '../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../config/themes/components_theme/app_picture_theme.dart';
import '../../../../../../core/common/presentation/extensions/size/size_extension.dart';
import '../../../../../../core/common/presentation/extensions/theme/theme_extension.dart';
import '../../../../../../core/common/presentation/views/widgets/system/app_divider.dart';
import '../../../../../../core/common/presentation/views/widgets/system/images/app_image_widget.dart';
import '../../../../../../core/common/presentation/views/widgets/system/images/app_svg_picture_widget.dart';
import '../design_components_widgets.dart';

class DcImage extends StatelessWidget {
  const DcImage({super.key});

  // A simple 1x1 transparent pixel in Base64 for testing Memory images
  static String _base64Pixel =
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAAtJREFUGFdjYAACAAAFAAGq1cRzAAAAAElFTkSuQmCC';

  Uint8List get _memoryBytes => base64Decode(_base64Pixel);

  // Use a public stable SVG for testing network
  static String _networkSvgUrl =
      'https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/android.svg';
  static String _errorUrl = 'https://invalid-url.com/missing.svg';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: 16.w.allPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_image_k_1_appimage_bitmap_assets,
          ),
          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_image_normal_asset_fitcontain,
          ),
          // REQ: Ensure you have an asset at this path or it will crash (AppImage lacks errorBuilder)
          const AppImage.fromAsset(
            'assets/images/logo.png', // Replace with a valid asset path in your project
            width: 100,
            height: 100,
            theme: PictureTheme(
              fit: BoxFit.contain,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),

          10.verticalGap,
          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_image_icon_mode_circular_border_back,
          ),
          AppImage.assetIcon(
            'assets/images/logo.png', // Replace with a valid asset path
            width: 60,
            height: 60,
            theme: PictureTheme(
              fit: BoxFit.contain,
              backgroundColor: context.colors.primary,
              borderColor: context.colors.outline,
              borderWidth: 2,
              containerPadding: 8.allPadding, // Padding inside the circle
            ),
          ),

          20.verticalGap,
          AppDivider.horizontal(),
          20.verticalGap,

          const HeaderSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_image_k_2_appimage_memory,
          ),
          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_image_loaded_from_uint8list_base64,
          ),
          Row(
            children: [
              AppImage.fromMemory(
                _memoryBytes,
                width: 50,
                height: 50,
                theme: PictureTheme(
                  backgroundColor: context.colors.success.color,
                ),
              ),
              20.horizontalGap,
              AppImage.memoryIcon(
                _memoryBytes,
                width: 50,
                height: 50,
                theme: PictureTheme(
                  backgroundColor: context.colors.secondary,
                  borderColor: context.colors.primary,
                  borderWidth: 2,
                ),
              ),
            ],
          ),
          20.verticalGap,
          AppDivider.horizontal(),
          20.verticalGap,

          const HeaderSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_image_k_3_appsvgpicture_network,
          ),
          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_image_network_svg_success,
          ),
          AppSvgPicture.fromNetwork(
            _networkSvgUrl,
            width: 100,
            height: 100,
            theme: const PictureTheme(fit: BoxFit.contain),
          ),

          10.verticalGap,
          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_image_network_svg_icon_themed,
          ),
          AppSvgPicture.networkIcon(
            _networkSvgUrl,
            width: 60,
            height: 60,
            theme: PictureTheme(
              backgroundColor: context.colors.tertiary,
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ), // Rounded Rect
              borderColor: AppMaterialPrimitives.black,
              borderWidth: 1,
              color: AppMaterialPrimitives.white, // Tint the SVG white
            ),
          ),

          20.verticalGap,
          AppDivider.horizontal(),
          20.verticalGap,

          const HeaderSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_image_k_4_appsvgpicture_error_states,
          ),
          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_image_network_404_triggers_nodatawid,
          ),
          AppSvgPicture.fromNetwork(
            _errorUrl,
            alt: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_image_profile_image, // Shows 'P'
            width: 80,
            height: 80,
            theme: PictureTheme(
              backgroundColor: context.colors.outlineVariant,
              shape: BoxShape.circle,
            ),
          ),

          10.verticalGap,
          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_image_missing_asset_triggers_nodataw,
          ),
          AppSvgPicture.fromAsset(
            'assets/missing_file.svg',
            alt: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_image_logo, // Shows 'L'
            width: 80,
            height: 80,
            theme: PictureTheme(
              backgroundColor: context.colors.error,
              borderColor: context.colors.error,
              borderWidth: 2,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
          ),

          20.verticalGap,
          AppDivider.horizontal(),
          20.verticalGap,

          const HeaderSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_image_k_5_interactivity,
          ),
          const LabelSection(
            title: LocaleKeys
                .features_splash_presentation_views_widgets_design_components_dc_image_tap_detection,
          ),
          AppSvgPicture.icon(
            // Use a standard flutter icon if you have one, or a path
            'assets/icons/settings.svg',
            width: 50,
            height: 50,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    LocaleKeys
                        .features_splash_presentation_views_widgets_design_components_dc_image_image_tapped,
                  ),
                ),
              );
            },
            theme: PictureTheme(
              backgroundColor: context.colors.warning.onColor,
            ),
          ),
        ],
      ),
    );
  }
}
