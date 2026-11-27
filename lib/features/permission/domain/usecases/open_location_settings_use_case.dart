import 'package:injectable/injectable.dart';

import '../../../../core/error/typedef.dart';
import '../repositories/permission_repository.dart';

/// Opens the system location settings. Right(true) if it opened.
@lazySingleton
class OpenLocationSettingsUseCase {
  const OpenLocationSettingsUseCase({required IPermissionRepository repository})
    : _repository = repository;

  final IPermissionRepository _repository;

  ResultFuture<bool> call() => _repository.openLocationSettings();
}
