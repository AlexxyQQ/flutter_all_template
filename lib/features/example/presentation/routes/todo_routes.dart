import 'package:auto_route/auto_route.dart';

import '../../../../app/router/app_router.gr.dart';

abstract final class TodoRoutes {
  static const String path = '/todos';

  static final route = AutoRoute(
    page: TodoRoute.page,
    path: path,
    children: [AutoRoute(page: TodoListRoute.page, initial: true)],
  );
}
