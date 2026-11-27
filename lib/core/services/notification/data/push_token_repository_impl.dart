import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/constants/api/api_paths.dart';
import '../../../error/guard.dart';
import '../../../error/typedef.dart';
import '../../../network/api_client.dart';
import '../domain/push_token_repository.dart';

@LazySingleton(as: IPushTokenRepository)
class PushTokenRepositoryImpl implements IPushTokenRepository {
  const PushTokenRepositoryImpl({required IApiClient api}) : _api = api;

  final IApiClient _api;

  @override
  ResultFuture<void> register({required String token}) => guard(
    () => _api.post<void>(
      ApiPaths.pushToken,
      body: {'token': token, 'platform': _platform},
      decode: Decoders.ignore,
    ),
  );

  @override
  ResultFuture<void> unregister({required String token}) => guard(
    () => _api.delete<void>(
      ApiPaths.pushToken,
      body: {'token': token},
      decode: Decoders.ignore,
    ),
  );

  /// Lowercase (`android`, `ios`) so the backend sees one spelling.
  String get _platform => defaultTargetPlatform.name.toLowerCase();
}
