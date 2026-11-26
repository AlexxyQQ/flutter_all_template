import 'package:auto_route/auto_route.dart';

import '../../../../../../config/constants/paths/app_path.dart';
import '../../../../presentation/routes/app_router.gr.dart';

/// Route config for the permission feature. Referenced by `AppRouter`.
class PermissionRoute {
  /// `/permission/:permission` → [PermissionScreenRoute].
  static final routes = AutoRoute(
    path: AppPaths.permissionPattern,
    page: PermissionScreenRoute.page,
  );
}
