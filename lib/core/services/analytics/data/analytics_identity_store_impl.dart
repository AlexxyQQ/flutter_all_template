import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../domain/analytics_identity.dart';
import '../domain/analytics_identity_store.dart';
import '../domain/analytics_storage.dart';

/// [IAnalyticsIdentityStore] persisted in encrypted storage.
@LazySingleton(as: IAnalyticsIdentityStore)
class AnalyticsIdentityStoreImpl implements IAnalyticsIdentityStore {
  AnalyticsIdentityStoreImpl({required IAnalyticsStorage storage})
    : _storage = storage;

  static const String key = 'analytics.identity';

  final IAnalyticsStorage _storage;

  @override
  Future<AnalyticsIdentity?> read() async {
    final raw = await _storage.read(key: key);
    if (raw == null) {
      return null;
    }
    final json = jsonDecode(raw);
    if (json is! Map<String, Object?>) {
      return null;
    }
    final anonymousId = json['anonymous_id'];
    final userId = json['user_id'];
    if (anonymousId is! String || anonymousId.isEmpty) {
      return null;
    }
    return AnalyticsIdentity(
      anonymousId: anonymousId,
      userId: userId is String ? userId : null,
    );
  }

  @override
  Future<void> write({required AnalyticsIdentity identity}) => _storage.write(
    key: key,
    value: jsonEncode({
      'anonymous_id': identity.anonymousId,
      'user_id': identity.userId,
    }),
  );
}
