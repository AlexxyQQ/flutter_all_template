import 'package:injectable/injectable.dart';

import '../../../../core/error/typedef.dart';
import '../entities/app_permission.dart';
import '../repositories/permission_skip_repository.dart';

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
