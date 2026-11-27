import 'package:injectable/injectable.dart';

import '../../../../core/error/typedef.dart';
import '../entities/app_permission.dart';
import '../entities/app_permission_status.dart';
import '../repositories/permission_repository.dart';

/// Shows the OS prompt for a permission and returns the resulting status.
@lazySingleton
class RequestPermissionUseCase {
  const RequestPermissionUseCase({required IPermissionRepository repository})
    : _repository = repository;

  final IPermissionRepository _repository;

  ResultFuture<AppPermissionStatus> call({required AppPermission permission}) =>
      _repository.request(permission: permission);
}
