import 'package:auto_route/auto_route.dart';

import '../../../../config/constants/paths/app_path.dart';
import '../../../../core/common/presentation/routes/app_router.gr.dart';

class AnotherRoute {
  static final routes = AutoRoute(
    page: AnotherWrapperRoute.page,
    path: AppPaths.anotherFeature,
    children: [
      AutoRoute(
        page: AnotherScreenRoute.page,
        initial: true,
        path: AppPaths.anotherScreen,
      ),
      // AutoRoute(
      //   guards: [NotificationPermissionGuard()],
      //   page: NotificationDebuggerScreenRoute.page,
      //   path: AppPaths.notificationDebugger,
      // ),
      // AutoRoute(
      //   guards: [LocationPermissionGuard()],
      // guards: [CameraPermissionGuard()],
      // guards: [MicrophonePermissionGuard()],
      // guards: [StoragePermissionGuard()],
      // page: PermissionTestScreenRoute.page,
      //   path: AppPaths.permissionTest,
      // ),
    ],
  );
}
