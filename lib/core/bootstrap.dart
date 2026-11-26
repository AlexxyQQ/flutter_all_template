import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/constants/locales/app_locales.dart';
import '../config/observers/app_bloc_observer.dart';
import 'common/domain/services/analytics/analytics_error_reporter.dart';
import 'common/domain/services/analytics/analytics_lifecycle_observer.dart';
import 'common/domain/services/analytics/domain/analytics_service.dart';
import 'common/domain/services/logger/logger_service.dart';
// brick:if use_notifications
import 'common/domain/services/notification/notification_service.dart';
// brick:end
import 'common/features/app_settings/domain/repositories/app_preferences_repository.dart';
import 'common/locator/service_locator.dart';
import 'common/presentation/blocs/locale/locale_cubit.dart';
import 'error/guard.dart';
import 'session/session.dart';

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
    await runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        _installErrorHandlers();

        await EasyLocalization.ensureInitialized();
        await SystemChrome.setPreferredOrientations(supportedOrientations);

        await initializers?.call();

        await configureInjection();
        final session = sl<SessionManager>();
        await session.restore();

        // Analytics: anonymous until your auth flow calls
        // `sl<IAnalyticsService>().identify(userId: user.id)` (an opaque id,
        // never an e-mail); sign-out clears it through the logout hook.
        final analytics = sl<IAnalyticsService>();
        await analytics.initialize();
        sl<AnalyticsErrorReporter>().install();
        sl<AnalyticsLifecycleObserver>().install();
        session.registerLogoutHook(hook: analytics.clearIdentity);
        // Tokens can vanish without a sign-out (expiry, cleared storage): stop
        // attributing events to the previous user.
        if (session.status == SessionStatus.unauthenticated) {
          await analytics.clearIdentity();
        }
        // brick:if use_notifications
        await sl<NotificationService>().initialize();
        // brick:end

        final startLocale = LocaleCubit.resolveStartLocale(
          savedTag: sl<IAppPreferencesRepository>().read().localeTag,
          deviceLocale: PlatformDispatcher.instance.locale,
          supportedLocales: AppLocales.appLocales,
        );

        runApp(
          EasyLocalization(
            supportedLocales: AppLocales.appLocales,
            // ignore: avoid_hardcoded_strings_in_widgets
            path: 'assets/translations',
            fallbackLocale: AppLocales.en,
            startLocale: startLocale,
            // LocaleCubit + PreferencesStore persist the locale.
            saveLocale: false,
            useFallbackTranslations: true,
            child: await builder(),
          ),
        );
      },
      (error, stackTrace) {
        AppLogger.error(
          'Uncaught zone error',
          error: error,
          stackTrace: stackTrace,
          name: 'bootstrap',
        );
        if (sl.isRegistered<AnalyticsErrorReporter>()) {
          sl<AnalyticsErrorReporter>().report(
            source: 'zone',
            error: error,
            fatal: true,
          );
        }
      },
    );
  }

  static void _installErrorHandlers() {
    FlutterError.onError = (details) {
      if (kDebugMode) {
        FlutterError.presentError(details);
      }
      AppLogger.error(
        'Flutter framework error',
        error: details.exception,
        stackTrace: details.stack,
        name: 'FlutterError',
      );
    };

    PlatformDispatcher.instance.onError = (error, stackTrace) {
      AppLogger.error(
        'Uncaught platform error',
        error: error,
        stackTrace: stackTrace,
        name: 'PlatformDispatcher',
      );
      return true;
    };

    Bloc.observer = const AppBlocObserver();

    guardErrorReporter = (error, stackTrace) => AppLogger.error(
      'Unexpected error caught by guard()',
      error: error,
      stackTrace: stackTrace,
      name: 'guard',
    );
  }
}
