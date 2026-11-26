import '../../../../../../config/constants/type_defs/typedef.dart';
import '../entities/app_preferences.dart';

/// Reads and writes non-secret user preferences.
abstract interface class IAppPreferencesRepository {
  /// Synchronous: preferences are pre-loaded at startup. Never throws;
  /// returns defaults for missing or unreadable values.
  AppPreferences read();

  /// [localeTag] is a BCP-47 tag with country code, e.g. `en-GB`.
  ResultVoid setLocaleTag({required String localeTag});

  ResultVoid setHasOnboarded({required bool value});
}
