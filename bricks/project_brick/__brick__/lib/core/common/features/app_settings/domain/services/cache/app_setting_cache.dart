// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:injectable/injectable.dart';

import '../../../../../../generic/domain/services/base_cache_service.dart';
import '../../../../../data/models/helpers/model_conversion_helper.dart';
import '../../../data/models/app_setting.dart';
import '../../repositories/app_setting_repository.dart';

@lazySingleton
class AppSettingCache extends BaseSingleCacheService<AppSetting> {
  AppSettingCache({required IAppSettingRepository repository})
    : _repository = repository,
      super(key: 'app_setting', ttl: const Duration(minutes: 5));

  final IAppSettingRepository _repository;

  @override
  Future<AppSetting?> fetch() {
    return _repository.getSetting().rightOrNull;
  }
}
