import 'package:flutter_all_template/core/common/domain/entities/failure.dart';
import 'package:flutter_all_template/core/common/domain/services/notification/data/push_token_repository_impl.dart';
import 'package:flutter_all_template/core/common/domain/services/notification/notification_api_paths.dart';
import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/network/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  late _MockApiClient api;
  late PushTokenRepositoryImpl repository;

  setUp(() {
    api = _MockApiClient();
    repository = PushTokenRepositoryImpl(api);
  });

  test('register POSTs the token to the push-token endpoint', () async {
    when(
      () => api.post<void>(
        any(),
        body: any(named: 'body'),
        decode: any(named: 'decode'),
      ),
    ).thenAnswer((_) async {});

    final result = await repository.register('t');

    expect(result.isRight(), isTrue);
    final body =
        verify(
              () => api.post<void>(
                NotificationApiPaths.pushToken,
                body: captureAny(named: 'body'),
                decode: any(named: 'decode'),
              ),
            ).captured.single
            as Map<String, Object?>;
    expect(body['token'], 't');
    expect(body['platform'], isA<String>());
  });

  test('unregister maps API errors to a Failure', () async {
    when(
      () => api.delete<void>(
        any(),
        body: any(named: 'body'),
        decode: any(named: 'decode'),
      ),
    ).thenThrow(const UnauthorizedException());

    final result = await repository.unregister('t');

    expect(result.getLeft().toNullable()?.type, FailureType.unauthorized);
  });
}
