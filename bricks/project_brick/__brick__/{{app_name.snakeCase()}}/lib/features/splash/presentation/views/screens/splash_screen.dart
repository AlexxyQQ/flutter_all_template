import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../config/constants/gen/assets.gen.dart';
import '../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../core/common/presentation/routes/app_router.gr.dart';

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
    final router = context.router;
    final splash = RouteData.of(context);
    if (router.currentChild != splash) {
      // An external navigation may have opened a destination during splash.
      router.removeRoute(splash);
      return;
    }
    unawaited(router.replace(_resolveNext()));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              identifier: 'splash_logo',
              image: true,
              label: LocaleKeys
                  .features_splash_presentation_screens_splash_screen_logoLabel
                  .tr(),
              excludeSemantics: true,
              child: Image.asset(
                Assets.images.logo.path,
                key: const Key('splash_logo'),
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(key: Key('splash_loader')),
            const SizedBox(height: 12),
            Text(
              LocaleKeys
                  .features_splash_presentation_screens_splash_screen_loading
                  .tr(),
            ),
          ],
        ),
      ),
    );
  }
}
