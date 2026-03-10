import '../../../../../../config/constants/type_defs/typedef.dart';
import '../../data/models/app_setting.dart';

abstract class IAppSettingRepository {
  ResultFuture<AppSetting> getSetting();
  ResultFuture<void> logout();
  ResultFuture<AppSetting> updateSetting({
    required Function(AppSetting currentData) data,
  });
}
