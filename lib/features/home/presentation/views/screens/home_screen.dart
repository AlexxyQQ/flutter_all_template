import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../core/common/presentation/extensions/size/size_extension.dart';
import '../../../../../core/common/presentation/extensions/theme/theme_extension.dart';
import '../../../../../core/common/presentation/routes/app_router.gr.dart';
import '../../../../../core/common/presentation/views/widgets/system/app_button.dart';
import '../../../../../core/common/presentation/views/widgets/system/default_app_bar.dart';
import '../../../../../core/common/presentation/views/widgets/system/text/app_text_widget.dart';
import '../../../../gallery/presentation/routes/gallery_route.dart';

/// Minimal landing page. Replace with the app's real home.
@RoutePage(name: 'HomeRoute')
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: LocaleKeys
            .features_home_presentation_views_screens_home_screen_title,
      ),
      body: SafeArea(
        child: Padding(
          padding: 24.allPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppText(
                LocaleKeys
                    .features_home_presentation_views_screens_home_screen_welcome,
                style: context.textStyles.headlineMedium,
              ),
              12.verticalGap,
              AppText(
                LocaleKeys
                    .features_home_presentation_views_screens_home_screen_subtitle,
                style: context.textStyles.bodyLarge.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              if (GalleryRoutes.isEnabled) ...[
                32.verticalGap,
                AppButton.stroke(
                  onPressed: () => context.router.push(GalleryRoute()),
                  label: LocaleKeys
                      .features_home_presentation_views_screens_home_screen_openGallery,
                  isExpanded: true,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
