import 'package:auto_route/auto_route.dart';

import '../../../../core/common/presentation/routes/app_router.gr.dart';

class HomeRoutes {
  static const String path = '/home';

  static final route = AutoRoute(page: HomeRoute.page, path: path);
}
