import 'package:injectable/injectable.dart';

import '../../../storage/key_value_stores.dart';

/// The user's global "push notifications on/off" choice for this device.
@lazySingleton
class NotificationPreferences {
  NotificationPreferences({required IPreferencesStore prefs}) : _prefs = prefs;

  /// `bool`, defaults to `true`. Also read by the FCM background isolate
  /// straight from `SharedPreferences` (no DI there), so keep the key stable.
  static const String enabledKey = 'app_notifications_enabled';

  final IPreferencesStore _prefs;

  bool get areEnabled => _prefs.getBool(key: enabledKey) ?? true;

  Future<void> setEnabled({required bool value}) =>
      _prefs.setBool(key: enabledKey, value: value);
}
