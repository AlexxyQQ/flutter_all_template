import 'package:auto_route/auto_route.dart';

import '../../../../config/constants/paths/app_path.dart';
import '../../../../core/common/presentation/routes/app_router.gr.dart';

class HomeRoutes {
  static const String path = AppPaths.home;

  static final route = AutoRoute(page: HomeRoute.page, path: path);
}
