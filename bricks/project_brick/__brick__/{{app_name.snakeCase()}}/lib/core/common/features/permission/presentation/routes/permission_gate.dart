import 'package:injectable/injectable.dart';

import '../../domain/entities/app_permission.dart';
import '../../domain/repository/permission_repository.dart';

/// Decides whether navigation to a permission-protected screen may proceed.
///
/// Access is allowed when the permission is granted, or — when
/// [allowIfSkipped] is true — when the user explicitly skipped it. A skipped
/// permission is still *not granted*; the protected screen must degrade
/// gracefully.
@lazySingleton
class PermissionGate {
  const PermissionGate(this._permissions, this._skips);

  final IPermissionRepository _permissions;
  final IPermissionSkipRepository _skips;

  Future<bool> canProceed(
    AppPermission permission, {
    bool allowIfSkipped = true,
  }) async {
    if (allowIfSkipped && _skips.isSkipped(permission)) {
      return true;
    }
    final result = await _permissions.check(permission);
    return result.fold((_) => false, (status) => status.isGranted);
  }
}
