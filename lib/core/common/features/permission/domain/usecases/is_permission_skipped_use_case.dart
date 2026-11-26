import 'package:injectable/injectable.dart';

import '../entities/app_permission.dart';
import '../repository/permission_repository.dart';

/// Whether the user previously skipped [permission] (synchronous).
@lazySingleton
class IsPermissionSkippedUseCase {
  const IsPermissionSkippedUseCase({
    required IPermissionSkipRepository repository,
  }) : _repository = repository;

  final IPermissionSkipRepository _repository;

  bool call({required AppPermission permission}) =>
      _repository.isSkipped(permission: permission);
}
