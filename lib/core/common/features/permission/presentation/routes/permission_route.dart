import 'package:auto_route/auto_route.dart';

import '../../../../../../config/constants/paths/app_path.dart';
import '../../../../presentation/routes/app_router.gr.dart';

class PermissionRoute {
  static final routes = AutoRoute(
    path: AppPaths.permission,
    page: PermissionWrapperRoute.page,
    children: [
      AutoRoute(
        path: AppPaths.notificationPermission,
        page: NotificationPermissionScreenRoute.page,
      ),
      AutoRoute(
        path: AppPaths.locationPermission,
        page: LocationPermissionScreenRoute.page,
      ),
      AutoRoute(
        path: AppPaths.storagePermission,
        page: StoragePermissionScreenRoute.page,
      ),
      AutoRoute(
        path: AppPaths.cameraPermission,
        page: CameraPermissionScreenRoute.page,
      ),
      AutoRoute(
        path: AppPaths.microphonePermission,
        page: MicrophonePermissionScreenRoute.page,
      ),
      AutoRoute(
        path: AppPaths.contactsPermission,
        page: ContactsPermissionScreenRoute.page,
      ),
      AutoRoute(
        path: AppPaths.calendarPermission,
        page: CalendarPermissionScreenRoute.page,
      ),
      AutoRoute(
        path: AppPaths.bluetoothPermission,
        page: BluetoothPermissionScreenRoute.page,
      ),
      AutoRoute(
        path: AppPaths.phonePermission,
        page: PhonePermissionScreenRoute.page,
      ),
      AutoRoute(
        path: AppPaths.activityRecognitionPermission,
        page: ActivityRecognitionPermissionScreenRoute.page,
      ),
    ],
  );
}
