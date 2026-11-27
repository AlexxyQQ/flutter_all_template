import 'package:injectable/injectable.dart';

import '../../../../core/error/typedef.dart';
import '../entities/app_permission.dart';
import '../entities/app_permission_status.dart';
import '../repositories/permission_repository.dart';

/// Reads the current OS status of a permission without prompting.
@lazySingleton
class CheckPermissionUseCase {
  const CheckPermissionUseCase({required IPermissionRepository repository})
    : _repository = repository;

  final IPermissionRepository _repository;

  ResultFuture<AppPermissionStatus> call({required AppPermission permission}) =>
      _repository.check(permission: permission);
}
