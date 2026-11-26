import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import '../../../../features/example/presentation/routes/todo_route.dart';
import '../../../../features/home/presentation/routes/home_route.dart';
import '../../../../features/splash/presentation/routes/splash_route.dart';
// brick:if use_permissions
import '../../features/permission/presentation/routes/permission_route.dart';
// brick:end
export 'app_router.gr.dart';

@Singleton()
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
    SplashRoute.routes,
    HomeRoutes.route,
    TodoRoutes.route,
    // brick:if use_permissions
    PermissionRoute.routes,
    // brick:end
  ];
}
