import 'package:injectable/injectable.dart';

import '../../../../core/error/guard.dart';
import '../../../../core/error/typedef.dart';
import '../../../../core/storage/key_value_stores.dart';
import '../../domain/entities/app_permission.dart';
import '../../domain/repositories/permission_skip_repository.dart';

/// Stores "skipped" flags as plain preferences (not a secret). They describe
/// the device, not the signed-in user, so they are deliberately not session-scoped.
@LazySingleton(as: IPermissionSkipRepository)
class PermissionSkipRepositoryImpl implements IPermissionSkipRepository {
  const PermissionSkipRepositoryImpl({required IPreferencesStore prefs})
    : _prefs = prefs;

  final IPreferencesStore _prefs;

  static String keyFor(AppPermission permission) =>
      'permission.skipped.${permission.name}';

  @override
  bool isSkipped({required AppPermission permission}) =>
      _prefs.getBool(key: keyFor(permission)) ?? false;

  @override
  ResultFuture<void> markSkipped({required AppPermission permission}) =>
      guard(() => _prefs.setBool(key: keyFor(permission), value: true));
}
