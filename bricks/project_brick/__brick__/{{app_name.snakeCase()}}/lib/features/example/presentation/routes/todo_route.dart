import 'package:auto_route/auto_route.dart';

import '../../../../core/common/presentation/routes/app_router.gr.dart';

class TodoRoutes {
  static const String path = '/todos';

  static final route = AutoRoute(page: TodoRoute.page, path: path);
}
