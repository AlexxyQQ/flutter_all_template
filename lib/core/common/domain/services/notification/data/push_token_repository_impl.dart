import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../config/constants/type_defs/typedef.dart';
import '../../../../../error/guard.dart';
import '../../../../../network/api_client.dart';
import '../domain/push_token_repository.dart';
import '../notification_api_paths.dart';

@LazySingleton(as: PushTokenRepository)
class PushTokenRepositoryImpl implements PushTokenRepository {
  const PushTokenRepositoryImpl({required ApiClient api}) : _api = api;

  final ApiClient _api;

  @override
  ResultFuture<void> register({required String token}) => guard(
    () => _api.post<void>(
      NotificationApiPaths.pushToken,
      body: {'token': token, 'platform': defaultTargetPlatform.name},
      decode: Decoders.ignore,
    ),
  );

  @override
  ResultFuture<void> unregister({required String token}) => guard(
    () => _api.delete<void>(
      NotificationApiPaths.pushToken,
      body: {'token': token},
      decode: Decoders.ignore,
    ),
  );
}
