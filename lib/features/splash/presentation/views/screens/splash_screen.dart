import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../config/constants/gen/assets.gen.dart';
import '../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../core/common/presentation/extensions/size/size_extension.dart';
import '../../../../../core/common/presentation/extensions/theme/theme_extension.dart';
import '../../../../../core/common/presentation/routes/app_router.gr.dart';
import '../../../../../core/common/presentation/views/widgets/system/images/app_image_widget.dart';
import '../../../../../core/common/presentation/views/widgets/system/loaders/app_circular_loader.dart';
import '../../../../../core/common/presentation/views/widgets/system/text/app_text_widget.dart';

/// Brand splash shown on cold start; replaces itself with [HomeRoute].
///
/// Put start-up decisions (session restore, onboarding) in `_resolveNext`
/// when those features exist.
@RoutePage(name: 'SplashScreenRoute')
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  /// How long the brand is shown before navigating.
  static const Duration displayDuration = Duration(milliseconds: 1200);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(SplashScreen.displayDuration, _navigate);
  }

  PageRouteInfo<Object?> _resolveNext() => const HomeRoute();

  void _navigate() {
    if (!mounted) {
      return;
    }
    unawaited(context.router.replace(_resolveNext()));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              image: true,
              label: LocaleKeys
                  .features_home_presentation_views_screens_home_screen_logoLabel
                  .tr(),
              excludeSemantics: true,
              child: AppImage.fromAsset(
                Assets.images.logo.path,
                width: 120,
                height: 120,
              ),
            ),
            24.verticalGap,
            const AppCircularLoader(),
            12.verticalGap,
            AppText(
              LocaleKeys
                  .features_home_presentation_views_screens_home_screen_splashLoading,
              style: context.textStyles.bodyMedium.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
