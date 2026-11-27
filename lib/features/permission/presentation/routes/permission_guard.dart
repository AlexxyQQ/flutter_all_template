import 'package:auto_route/auto_route.dart';

import '../../../../app/router/app_router.gr.dart';
import '../../domain/entities/app_permission.dart';
import 'permission_gate.dart';

/// Guards a route behind one [AppPermission].
///
/// * Granted (or skipped, when [allowIfSkipped]) → navigation continues.
/// * Otherwise the [PermissionRoute] is pushed and its result decides: the
///   original navigation resumes when the user grants/skips (and the gate
///   agrees) and is aborted when they back out.
///
/// Build the guard where the router is composed and hand it the injected
/// gate, instead of reaching for the service locator inside a route:
///
/// ```dart
/// @Singleton(as: RootStackRouter)
/// @AutoRouterConfig()
/// class AppRouter extends RootStackRouter {
///   AppRouter({required PermissionGate permissionGate})
///     : _permissionGate = permissionGate;
///
///   final PermissionGate _permissionGate;
///
///   @override
///   List<AutoRoute> get routes => [
///     AutoRoute(
///       page: CameraRoute.page,
///       guards: [
///         PermissionGuard(
///           permission: AppPermission.camera,
///           gate: _permissionGate,
///         ),
///       ],
///     ),
///   ];
/// }
/// ```
class PermissionGuard extends AutoRouteGuard {
  PermissionGuard({
    required this.permission,
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
    if (await _canProceed()) {
      resolver.next();
      return;
    }
    final done = await router.push<bool>(
      PermissionRoute(permission: permission.name),
    );
    // The screen also returns true for "skipped"; the gate has the final word
    // because a skip only counts when [allowIfSkipped] is set.
    if (done == true && await _canProceed()) {
      resolver.next();
    } else {
      resolver.next(false);
    }
  }

  Future<bool> _canProceed() =>
      _gate.canProceed(permission: permission, allowIfSkipped: allowIfSkipped);
}
