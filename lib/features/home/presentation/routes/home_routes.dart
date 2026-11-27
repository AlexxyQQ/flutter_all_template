import 'package:auto_route/auto_route.dart';

import '../../../../app/router/app_router.gr.dart';
import '../../../../config/constants/paths/app_path.dart';

abstract final class HomeRoutes {
  static const String path = AppPaths.home;

  static final route = AutoRoute(page: HomeRoute.page, path: path);
}
