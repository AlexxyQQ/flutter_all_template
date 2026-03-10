import 'package:auto_route/auto_route.dart';

import '../../../../config/constants/paths/app_path.dart';
import '../../../../core/common/presentation/routes/app_router.gr.dart';

class SplashRoute {
  static final routes = AutoRoute(
    page: SplashWrapperRoute.page,
    path: AppPaths.splashRoute,
    initial: true,
    children: [AutoRoute(page: SplashScreenRoute.page, initial: true)],
  );
}
