import 'package:injectable/injectable.dart';

import '../../../../../../config/constants/type_defs/typedef.dart';
import '../entities/app_permission.dart';
import '../repository/permission_repository.dart';

/// Remembers that the user chose "maybe later". Skipping is not granting.
@lazySingleton
class MarkPermissionSkippedUseCase {
  const MarkPermissionSkippedUseCase({
    required IPermissionSkipRepository repository,
  }) : _repository = repository;

  final IPermissionSkipRepository _repository;

  ResultFuture<void> call({required AppPermission permission}) =>
      _repository.markSkipped(permission: permission);
}
