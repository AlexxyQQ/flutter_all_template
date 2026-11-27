import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import '../../features/example/presentation/routes/todo_routes.dart';
import '../../features/home/presentation/routes/home_routes.dart';
// brick:if use_permissions
import '../../features/permission/presentation/routes/permission_routes.dart';
// brick:end
import '../../features/splash/presentation/routes/splash_routes.dart';

export 'app_router.gr.dart';

@Singleton(as: RootStackRouter)
@AutoRouterConfig(replaceInRouteName: 'Page|Screen|Wrapper,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
    SplashRoutes.route,
    HomeRoutes.route,
    TodoRoutes.route,
    // brick:if use_permissions
    PermissionRoutes.route,
    // brick:end
  ];
}
