import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import '../config/constants/locales/app_locales.dart';
{{#use_notifications}}
import 'common/domain/services/notification/notification_service.dart';
{{/use_notifications}}
import 'common/locator/service_locator.dart';

FutureOr<void> bootstrap({
  required FutureOr<Widget> Function() builder,
  required Future<Null> Function() initializers,
}) async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await EasyLocalization.ensureInitialized();
      BindingBase.debugZoneErrorsAreFatal = true;

      // To make the app orientation in portrait mode
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      // Service Locator initialization
      await configureInjection();
      await GetIt.instance.allReady();

      await initializers();

{{#use_notifications}}
      // Notification
      await NotificationService.instance.initialize();
{{/use_notifications}}

      // Run the app
      final app = await EasyLocalization(
        supportedLocales: AppLocales.appLocales,
        // ignore: avoid_hardcoded_strings_in_widgets
        path: 'assets/translations',
        fallbackLocale: AppLocales.en,
        saveLocale: false,
        useFallbackTranslations: true,
        child: await builder(),
      );

      runApp(app);
    },
    (error, stackTrace) {
      if (kDebugMode) {
        print('Error: ${error.toString()}, stackTrace: $stackTrace');
      }
    },
  );
}
