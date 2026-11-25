import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import '../../../../features/gallery/presentation/routes/gallery_route.dart';
import '../../../../features/home/presentation/routes/home_route.dart';
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
    HomeRoutes.route,
    ...GalleryRoutes.routes,
    PermissionRoute.routes,
    ...DialogRoutes.all,
    ...BottomSheetRoute.all,
  ];
}
