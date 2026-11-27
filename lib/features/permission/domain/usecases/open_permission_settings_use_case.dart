import 'package:injectable/injectable.dart';

import '../../../../core/error/typedef.dart';
import '../repositories/permission_repository.dart';

/// Opens the app's page in the system settings. Right(true) if it opened.
@lazySingleton
class OpenPermissionSettingsUseCase {
  const OpenPermissionSettingsUseCase({
    required IPermissionRepository repository,
  }) : _repository = repository;

  final IPermissionRepository _repository;

  ResultFuture<bool> call() => _repository.openSettings();
}
