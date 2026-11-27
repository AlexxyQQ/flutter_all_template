import 'package:injectable/injectable.dart';

import '../../domain/entities/app_permission.dart';
import '../../domain/usecases/check_permission_use_case.dart';
import '../../domain/usecases/is_permission_skipped_use_case.dart';

/// Decides whether navigation to a permission-protected screen may proceed.
///
/// Access is allowed when the permission is granted, or — when
/// [allowIfSkipped] is true — when the user explicitly skipped it. A skipped
/// permission is still *not granted*; the protected screen must degrade
/// gracefully.
@lazySingleton
class PermissionGate {
  const PermissionGate({
    required CheckPermissionUseCase check,
    required IsPermissionSkippedUseCase isSkipped,
  }) : _check = check,
       _isSkipped = isSkipped;

  final CheckPermissionUseCase _check;
  final IsPermissionSkippedUseCase _isSkipped;

  Future<bool> canProceed({
    required AppPermission permission,
    bool allowIfSkipped = true,
  }) async {
    if (allowIfSkipped && _isSkipped(permission: permission)) {
      return true;
    }
    final result = await _check(permission: permission);
    return result.fold((_) => false, (status) => status.isGranted);
  }
}
