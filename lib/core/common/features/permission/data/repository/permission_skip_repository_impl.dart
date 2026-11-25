import 'package:injectable/injectable.dart';

import '../../../../../../config/constants/type_defs/typedef.dart';
import '../../../../../error/guard.dart';
import '../../../../../storage/key_value_stores.dart';
import '../../domain/entities/app_permission.dart';
import '../../domain/repository/permission_repository.dart';

/// Stores "skipped" flags as plain preferences (not a secret).
@LazySingleton(as: IPermissionSkipRepository)
class PermissionSkipRepositoryImpl implements IPermissionSkipRepository {
  const PermissionSkipRepositoryImpl(this._prefs);

  final PreferencesStore _prefs;

  static String keyFor(AppPermission permission) =>
      'permission.skipped.${permission.name}';

  @override
  bool isSkipped(AppPermission permission) =>
      _prefs.getBool(keyFor(permission)) ?? false;

  @override
  ResultFuture<void> markSkipped(AppPermission permission) =>
      guard(() => _prefs.setBool(keyFor(permission), value: true));

  @override
  ResultFuture<void> clearSkipped(AppPermission permission) =>
      guard(() => _prefs.remove(keyFor(permission)));
}
