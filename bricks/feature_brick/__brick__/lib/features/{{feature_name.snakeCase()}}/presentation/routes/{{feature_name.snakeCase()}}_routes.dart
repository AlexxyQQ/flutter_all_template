import 'package:auto_route/auto_route.dart';

import '../../../../app/router/app_router.gr.dart';

class {{feature_name.pascalCase()}}Routes {
  static const String path = '{{{route_path}}}';

  static final route = AutoRoute(
    page: {{feature_name.pascalCase()}}Route.page,
    path: path,
    children: [AutoRoute(page: {{feature_name.pascalCase()}}ListRoute.page, initial: true)],
  );
}
