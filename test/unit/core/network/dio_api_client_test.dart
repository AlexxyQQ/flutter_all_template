import 'package:dio/dio.dart';
import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/network/api_client.dart';
import 'package:flutter_all_template/core/network/dio_api_client.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_http_adapter.dart';

void main() {
  late FakeHttpAdapter adapter;
  late DioApiClient client;

  setUp(() {
    adapter = FakeHttpAdapter((_) async => jsonBody({'ok': true}, 200));
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com/'))
      ..httpClientAdapter = adapter;
    client = DioApiClient(dio: dio);
  });

  group('success statuses', () {
    test('200 decodes the JSON body', () async {
      final result = await client.get('items', decode: Decoders.object);
      expect(result, {'ok': true});
      expect(adapter.requests.single.method, 'GET');
    });

    test('201 is a success', () async {
      adapter.handler = (_) async => jsonBody({'id': '1'}, 201);
      final result = await client.post(
        'items',
        body: {'name': 'a'},
        decode: Decoders.object,
      );
      expect(result['id'], '1');
    });

    test('204 with empty body decodes null', () async {
      adapter.handler = (_) async => jsonBody(null, 204);
      Object? decoded = 'sentinel';
      await client.delete<void>('items/1', decode: (json) => decoded = json);
      expect(decoded, isNull);
      expect(adapter.requests.single.method, 'DELETE');
    });

    test('PUT and PATCH use the right verb', () async {
      await client.put('a', decode: Decoders.ignore);
      await client.patch('a', decode: Decoders.ignore);
      expect(adapter.requests.map((r) => r.method), ['PUT', 'PATCH']);
    });
  });

  group('error statuses', () {
    Future<Object?> callWith(int status, [Object? body]) async {
      adapter.handler = (_) async => jsonBody(body, status);
      try {
        await client.get('x', decode: Decoders.ignore);
      } catch (e) {
        return e;
      }
      return null;
    }

    test(
      '400 -> ValidationException with safe message + field errors',
      () async {
        final e = await callWith(400, {
          'message': 'Email taken',
          'errors': {
            'email': ['already used'],
            'name': 'required',
          },
        });
        expect(e, isA<ValidationException>());
        final v = e! as ValidationException;
        expect(v.serverMessage, 'Email taken');
        expect(v.fieldErrors, {'email': 'already used', 'name': 'required'});
      },
    );

    test('422 -> ValidationException', () async {
      expect(await callWith(422), isA<ValidationException>());
    });

    test('401 -> UnauthorizedException', () async {
      expect(await callWith(401), isA<UnauthorizedException>());
    });

    test('403 -> ForbiddenException', () async {
      expect(await callWith(403), isA<ForbiddenException>());
    });

    test('404 -> NotFoundException', () async {
      expect(await callWith(404), isA<NotFoundException>());
    });

    test('500 -> ServerException without leaking the body', () async {
      final e = await callWith(500, {'message': 'SQL error at line 3'});
      expect(e, isA<ServerException>());
      final s = e! as ServerException;
      expect(s.statusCode, 500);
      expect(s.serverMessage, isNull);
    });
  });

  test('decoder errors become ParseException', () async {
    adapter.handler = (_) async => jsonBody([1, 2], 200);
    expect(
      () => client.get('x', decode: Decoders.object),
      throwsA(isA<ParseException>()),
    );
  });

  test('adapter failure maps to an AppException', () async {
    adapter.handler = (options) async => throw DioException.connectionError(
      requestOptions: options,
      reason: 'offline',
    );
    expect(
      () => client.get('x', decode: Decoders.ignore),
      throwsA(isA<NetworkException>()),
    );
  });
}
