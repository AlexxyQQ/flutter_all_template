import 'package:auto_route/auto_route.dart';
// brick:if use_firebase
import 'package:firebase_core/firebase_core.dart';
// brick:end

import 'app/app.dart';
import 'app/bootstrap.dart';
import 'app/di/service_locator.dart';
import 'app/observers/route_observer.dart';
// brick:if use_firebase
import 'config/firebase/firebase_options.dart';
// brick:end
// brick:if use_firebase
import 'core/services/analytics/data/firebase/firebase_analytics_setup.dart';
// brick:end

/// Run with a flavor config, e.g.
/// `flutter run --dart-define-from-file=env/dev.json` (see `AppEnv`).
Future<void> main() => Bootstrap.run(
  // brick:if use_firebase
  initializers: () async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAnalyticsSetup.configure();
  },
  // brick:end
  builder: () => App(
    router: sl<RootStackRouter>(),
    // A fresh observer per router: root and nested navigators each get one.
    navigatorObservers: () => [sl<AppRouteObserver>()],
  ),
);
