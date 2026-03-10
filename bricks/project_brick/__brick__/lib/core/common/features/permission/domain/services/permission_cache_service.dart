import 'package:injectable/injectable.dart';

import '../../../../../generic/domain/services/base_cache_service.dart';
import '../entities/permission_cache_entity.dart';
import '../repository/permission_repository.dart';

@lazySingleton
class PermissionCacheService
    extends BaseSingleCacheService<PermissionCacheEntity> {
  PermissionCacheService({required IPermissionRepository repository})
    : _repository = repository,
      super(key: 'app_permission', ttl: const Duration(minutes: 5));

  final IPermissionRepository _repository;

  @override
  Future<PermissionCacheEntity?> fetch() async {
    return null;
  }
}
