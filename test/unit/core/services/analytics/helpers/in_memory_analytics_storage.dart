import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/services/analytics/domain/analytics_storage.dart';

/// [IAnalyticsStorage] in memory; shared between service instances to
/// simulate an app restart.
class InMemoryAnalyticsStorage implements IAnalyticsStorage {
  final Map<String, String> values = {};
  bool failWrites = false;
  bool failKeys = false;

  @override
  Future<String?> read({required String key}) async => values[key];

  @override
  Future<void> write({required String key, required String value}) async {
    if (failWrites) {
      throw const StorageException(debugMessage: 'write failed');
    }
    values[key] = value;
  }

  @override
  Future<void> delete({required String key}) async => values.remove(key);

  @override
  Future<List<String>> keys() async {
    if (failKeys) {
      throw const StorageException(debugMessage: 'keys unavailable');
    }
    return values.keys.toList();
  }
}
