{{#use_firebase}}
import 'package:firebase_core/firebase_core.dart';

import 'config/firebase/firebase_options.dart';
{{/use_firebase}}
import 'config/observers/route_observer.dart';
import 'core/app.dart';
import 'core/bootstrap.dart';
import 'core/common/locator/service_locator.dart';
import 'core/common/presentation/routes/app_router.dart';

/// Run with a flavor config, e.g.
/// `flutter run --dart-define-from-file=env/dev.json` (see `AppEnv`).
Future<void> main() => bootstrap(
{{#use_firebase}}
  initializers: () async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  },
{{/use_firebase}}
  builder: () =>
      App(router: sl<AppRouter>(), routeObserver: sl<AppRouteObserver>()),
);
