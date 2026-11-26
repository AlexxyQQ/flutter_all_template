import 'package:injectable/injectable.dart';

import '../../../../../../config/constants/type_defs/typedef.dart';
import '../repository/permission_repository.dart';

/// Opens the app's page in the system settings. Right(true) if it opened.
@lazySingleton
class OpenPermissionSettingsUseCase {
  const OpenPermissionSettingsUseCase({
    required IPermissionRepository repository,
  }) : _repository = repository;

  final IPermissionRepository _repository;

  ResultFuture<bool> call() => _repository.openSettings();
}
