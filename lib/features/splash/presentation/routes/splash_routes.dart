import 'package:auto_route/auto_route.dart';

import '../../../../app/router/app_router.gr.dart';
import '../../../../config/constants/paths/app_path.dart';

abstract final class SplashRoutes {
  static final route = AutoRoute(
    page: SplashRoute.page,
    path: AppPaths.splashRoute,
    initial: true,
  );
}
