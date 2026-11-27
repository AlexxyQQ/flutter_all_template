import 'package:auto_route/auto_route.dart';
{{#use_firebase}}
import 'package:firebase_core/firebase_core.dart';
{{/use_firebase}}

import 'app/app.dart';
import 'app/bootstrap.dart';
import 'app/di/service_locator.dart';
import 'app/observers/route_observer.dart';
{{#use_firebase}}
import 'config/firebase/firebase_options.dart';
{{/use_firebase}}
{{#use_firebase}}
import 'core/services/analytics/data/firebase/firebase_analytics_setup.dart';
{{/use_firebase}}

/// Run with a flavor config, e.g.
/// `flutter run --dart-define-from-file=env/dev.json` (see `AppEnv`).
Future<void> main() => Bootstrap.run(
{{#use_firebase}}
  initializers: () async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAnalyticsSetup.configure();
  },
{{/use_firebase}}
  builder: () => App(
    router: sl<RootStackRouter>(),
    // A fresh observer per router: root and nested navigators each get one.
    navigatorObservers: () => [sl<AppRouteObserver>()],
  ),
);
