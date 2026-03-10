import 'package:injectable/injectable.dart';

import '../../../../../../generic/data/data_sources/local/secure_storage_data_source.dart';
import '../../../../../domain/services/storage/secure_storage_service.dart';
import '../../../../../locator/service_locator.dart';
import '../../models/app_setting.dart';

@lazySingleton
class AppSettingLocalDataSource extends ISecureStorageDataSource<AppSetting> {
  AppSettingLocalDataSource()
    : super(
        secureStorageService: sl<SecureStorageService>(),
        modelKey: 'app_setting',
      );

  @override
  AppSetting fromJson(Map<String, dynamic> json) {
    return AppSetting.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(AppSetting object) {
    return object.toJson();
  }

  @override
  AppSetting copyWith(AppSetting existingItem, AppSetting newValue) {
    return existingItem.copyWith(
      hasOnboarded: newValue.hasOnboarded,
      loggedUser: newValue.loggedUser,
      notification: newValue.notification,
      theme: newValue.theme,
      refreshToken: newValue.refreshToken,
      token: newValue.token,
      rememberUser: newValue.rememberUser,
    );
  }
}
