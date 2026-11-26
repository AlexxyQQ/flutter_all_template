import 'package:auto_route/auto_route.dart';

import '../../../../core/common/presentation/routes/app_router.gr.dart';

class {{feature_name.pascalCase()}}Routes {
  static const String path = '/{{feature_name.paramCase()}}s';

  static final route = AutoRoute(
    page: {{feature_name.pascalCase()}}WrapperRoute.page,
    path: path,
    children: [AutoRoute(page: {{feature_name.pascalCase()}}Route.page, initial: true)],
  );
}
