import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/constants/locales/app_locales.dart';
import '../config/env/app_env.dart';
import '../core/services/analytics/domain/analytics_service.dart';
import '../core/services/analytics/presentation/analytics_lifecycle_observer.dart';
import '../core/services/logger/data/app_logger.dart';
// brick:if use_notifications
import '../core/services/notification/data/notification_service.dart';
// brick:end
import '../core/session/session.dart';
import '../features/app_settings/domain/usecases/get_app_preferences_use_case.dart';
import 'di/service_locator.dart';
import 'error/app_error_reporter.dart';
import 'observers/app_bloc_observer.dart';

/// Restores the session and starts the application.
abstract final class Bootstrap {
  /// Orientations the app supports. Remove this lock (or add landscape) if your
  /// app should rotate; tablets/foldables usually should.
  static const List<DeviceOrientation> supportedOrientations = [
    DeviceOrientation.portraitUp,
  ];

  /// Composition root: error handling, DI, session restore, then `runApp`.
  ///
  /// [initializers] runs before DI (e.g. `Firebase.initializeApp`).
  /// To report errors to Crashlytics/Sentry in release builds, configure the
  /// logger at the top of [initializers] (or here) with
  /// `AppLogger.configure(LoggerService.platformDefault(crashReporter: …))`.
  static Future<void> run({
    required FutureOr<Widget> Function() builder,
    Future<void> Function()? initializers,
  }) async {
    // Analytics exists only once DI is up; errors before that are just logged.
    final errors = AppErrorReporter(
      analytics: () =>
          sl.isRegistered<IAnalyticsService>() ? sl<IAnalyticsService>() : null,
    );
    await runZonedGuarded(() async {
      WidgetsFlutterBinding.ensureInitialized();
      errors.install();
      Bloc.observer = const AppBlocObserver();
      // Fail fast on a missing BASE_URL instead of silently sending
      // requests without credentials.
      AppEnv.validate();

      await EasyLocalization.ensureInitialized();
      await SystemChrome.setPreferredOrientations(supportedOrientations);

      await initializers?.call();

      await configureInjection();
      final session = sl<ISessionManager>();
      await session.restore();

      // Analytics: anonymous until your auth flow calls
      // `sl<IAnalyticsService>().identify(userId: user.id)` (an opaque id,
      // never an e-mail); sign-out clears it through the logout hook.
      final analytics = sl<IAnalyticsService>();
      await analytics.initialize();
      sl<AnalyticsLifecycleObserver>().install();
      session.registerLogoutHook(hook: analytics.clearIdentity);
      // Tokens can vanish without a sign-out (expiry, cleared storage): stop
      // attributing events to the previous user.
      if (session.status == SessionStatus.unauthenticated) {
        await analytics.clearIdentity();
      }
      // brick:if use_notifications
      try {
        await sl<NotificationService>().initialize();
      } catch (error, stackTrace) {
        AppLogger.error(
          'NotificationService initialization failed',
          error: error,
          stackTrace: stackTrace,
          name: 'Bootstrap',
        );
      }
      // brick:end

      // Resolved once; EasyLocalization starts with it and LocaleCubit is
      // created with `context.locale` (see GlobalBlocProvider).
      final startLocale = AppLocales.resolveStart(
        savedTag: sl<GetAppPreferencesUseCase>()().localeTag,
        deviceLocale: PlatformDispatcher.instance.locale,
      );

      runApp(
        EasyLocalization(
          supportedLocales: AppLocales.appLocales,
          // ignore: avoid_hardcoded_strings_in_widgets
          path: 'assets/translations',
          fallbackLocale: AppLocales.fallback,
          startLocale: startLocale,
          // LocaleCubit + IPreferencesStore persist the locale.
          saveLocale: false,
          useFallbackTranslations: true,
          child: await builder(),
        ),
      );
    }, errors.onZoneError);
  }
}
