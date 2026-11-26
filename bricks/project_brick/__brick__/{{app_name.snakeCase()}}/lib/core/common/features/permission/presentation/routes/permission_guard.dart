import 'package:auto_route/auto_route.dart';

import '../../../../presentation/routes/app_router.gr.dart';
import '../../domain/entities/app_permission.dart';
import 'permission_gate.dart';

/// Guards a route behind one [AppPermission].
///
/// * Granted (or skipped, when [allowIfSkipped]) → navigation continues.
/// * Otherwise the [PermissionScreenRoute] is shown via `redirectUntil`; the
///   original navigation resumes when the user grants/skips and is aborted
///   when they back out.
///
/// ```dart
/// AutoRoute(
///   page: CameraRoute.page,
///   guards: [PermissionGuard(AppPermission.camera, gate: sl())],
/// )
/// ```
class PermissionGuard extends AutoRouteGuard {
  PermissionGuard(
    this.permission, {
    required PermissionGate gate,
    this.allowIfSkipped = true,
  }) : _gate = gate;

  final AppPermission permission;
  final bool allowIfSkipped;
  final PermissionGate _gate;

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final allowed = await _gate.canProceed(
      permission,
      allowIfSkipped: allowIfSkipped,
    );
    if (allowed) {
      resolver.next();
      return;
    }
    resolver.redirectUntil(
      PermissionScreenRoute(
        permission: permission.name,
        onResult: resolver.next,
      ),
    );
  }
}
