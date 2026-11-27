import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

{{#use_notifications}}
import '../../../../../app/di/service_locator.dart';
{{/use_notifications}}
import '../../../../../app/router/app_router.gr.dart';
import '../../../../../config/constants/gen/assets.gen.dart';
import '../../../../../config/constants/gen/locale_keys.g.dart';
{{#use_notifications}}
import '../../../../../core/services/notification/domain/notification_launch.dart';
{{/use_notifications}}

/// Brand splash shown on cold start; replaces itself with [HomeRoute] as soon
/// as the first frame is up. Start-up work (session restore, DI) already ran in
/// `Bootstrap`, so there is nothing to wait for and no artificial delay.
///
/// Put start-up decisions (onboarding, signed-in vs signed-out) in
/// `_resolveNext` when those features exist.
@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigate());
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
{{#use_notifications}}
    // The router is mounted and start-up is over: open the destination of a
    // notification that launched the app (no-op when there is none).
    if (sl.isRegistered<INotificationLaunch>()) {
      unawaited(sl<INotificationLaunch>().openPendingLaunchDestination());
    }
{{/use_notifications}}
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
              label: LocaleKeys.features_splash_logoLabel.tr(),
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
            Text(LocaleKeys.features_splash_loading.tr()),
          ],
        ),
      ),
    );
  }
}
