import 'package:auto_route/auto_route.dart';

import '../../../../app/router/app_router.gr.dart';
import '../../../../config/constants/paths/app_path.dart';

/// Route config for the permission feature. Referenced by `AppRouter`.
class PermissionRoutes {
  /// `/permission/:permission` → [PermissionRoute].
  static final route = AutoRoute(
    path: AppPaths.permissionPattern,
    page: PermissionRoute.page,
  );
}
