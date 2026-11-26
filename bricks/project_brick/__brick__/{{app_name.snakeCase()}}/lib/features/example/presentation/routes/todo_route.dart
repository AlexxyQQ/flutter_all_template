import 'package:auto_route/auto_route.dart';

import '../../../../core/common/presentation/routes/app_router.gr.dart';

class TodoRoutes {
  static const String path = '/todos';

  static final route = AutoRoute(
    page: TodoWrapperRoute.page,
    path: path,
    children: [AutoRoute(page: TodoRoute.page, initial: true)],
  );
}
