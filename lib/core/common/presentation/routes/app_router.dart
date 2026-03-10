import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import '../../../../features/splash/presentation/routes/splash_route.dart';
import '../../features/permission/presentation/routes/permission_route.dart';
import '../views/routes/dialog/bottom_sheet_route.dart';
import '../views/routes/dialog/dialog_route.dart';
export 'app_router.gr.dart';

@Singleton()
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
    SplashRoute.routes,
    PermissionRoute.routes,
    ..._OverlayRoutes.all,
  ];
}

class _OverlayRoutes {
  static final List<AutoRoute> all = [
    ...DialogRoutes.all,
    ...BottomSheetRoute.all,
    // ...TimeOffRoutes.bottomSheet,
    // ...WorkLogRoutes.bottomSheet,
    // ...CalendarRoutes.bottomSheet,
  ];
}
