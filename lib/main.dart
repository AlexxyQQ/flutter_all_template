// brick:if use_firebase
import 'package:firebase_core/firebase_core.dart';

import 'config/firebase/firebase_options.dart';
// brick:end
import 'config/observers/route_observer.dart';
import 'core/app.dart';
import 'core/bootstrap.dart';
// brick:if use_firebase
import 'core/common/domain/services/analytics/firebase/firebase_analytics_setup.dart';
// brick:end
import 'core/common/locator/service_locator.dart';
import 'core/common/presentation/routes/app_router.dart';

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
    router: sl<AppRouter>(),
    // A fresh observer per router: root and nested navigators each get one.
    navigatorObservers: () => [sl<AppRouteObserver>()],
  ),
);
