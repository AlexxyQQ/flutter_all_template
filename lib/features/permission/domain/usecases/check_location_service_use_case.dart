import 'package:injectable/injectable.dart';

import '../../../../core/error/typedef.dart';
import '../repositories/permission_repository.dart';

/// Whether the device's location switch is on (not the app's permission).
@lazySingleton
class CheckLocationServiceUseCase {
  const CheckLocationServiceUseCase({required IPermissionRepository repository})
    : _repository = repository;

  final IPermissionRepository _repository;

  ResultFuture<bool> call() => _repository.isLocationServiceEnabled();
}
