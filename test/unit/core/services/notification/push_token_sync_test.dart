import 'dart:async';

import 'package:flutter_all_template/core/error/failure.dart';
import 'package:flutter_all_template/core/services/logger/domain/logger_service.dart';
import 'package:flutter_all_template/core/services/notification/data/notification_preferences.dart';
import 'package:flutter_all_template/core/services/notification/data/push/push_messaging_client.dart';
import 'package:flutter_all_template/core/services/notification/data/push_token_sync.dart';
import 'package:flutter_all_template/core/services/notification/domain/push_token_repository.dart';
import 'package:flutter_all_template/core/session/session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';

class _MockPush extends Mock implements IPushMessagingClient {}

class _MockTokens extends Mock implements IPushTokenRepository {}

class _MockSession extends Mock implements ISessionManager {}

class _MockSettings extends Mock implements NotificationPreferences {}

class _MockLogger extends Mock implements ILoggerService {}

void main() {
  const token = 'device-token';

  late _MockPush push;
  late _MockTokens tokens;
  late _MockSession session;
  late _MockSettings settings;
  late _MockLogger logger;
  late BehaviorSubject<SessionStatus> statuses;
  late StreamController<String> refreshes;
  late PushTokenSync sync;

  setUp(() {
    push = _MockPush();
    tokens = _MockTokens();
    session = _MockSession();
    settings = _MockSettings();
    logger = _MockLogger();
    statuses = BehaviorSubject<SessionStatus>.seeded(
      SessionStatus.authenticated,
    );
    refreshes = StreamController<String>.broadcast();

    when(() => session.status).thenAnswer((_) => statuses.value);
    when(() => session.statusStream).thenAnswer((_) => statuses.stream);
    when(() => settings.areEnabled).thenReturn(true);
    when(() => push.getToken()).thenAnswer((_) async => token);
    when(() => push.deleteToken()).thenAnswer((_) async {});
    when(() => push.onTokenRefresh).thenAnswer((_) => refreshes.stream);
    when(
      () => tokens.register(token: any(named: 'token')),
    ).thenAnswer((_) async => const Right(null));
    when(
      () => tokens.unregister(token: any(named: 'token')),
    ).thenAnswer((_) async => const Right(null));

    sync = PushTokenSync(
      push: push,
      tokens: tokens,
      session: session,
      settings: settings,
      logger: logger,
    );
  });

  tearDown(() async {
    await sync.dispose();
    await statuses.close();
    await refreshes.close();
  });

  test('start while signed in registers the token exactly once', () async {
    sync.start();
    await pumpEventQueue();

    verify(() => tokens.register(token: token)).called(1);
  });

  test('concurrent syncs share one request', () async {
    final gate = Completer<String?>();
    when(() => push.getToken()).thenAnswer((_) => gate.future);

    final first = sync.sync();
    final second = sync.sync();
    expect(second, same(first));
    gate.complete(token);
    await Future.wait([first, second]);

    verify(() => tokens.register(token: token)).called(1);
  });

  test('an already registered token is not sent again', () async {
    await sync.sync();
    await sync.sync();

    verify(() => tokens.register(token: token)).called(1);
  });

  test('signing in registers the token', () async {
    statuses.add(SessionStatus.unauthenticated);
    sync.start();
    await pumpEventQueue();
    verifyNever(() => tokens.register(token: any(named: 'token')));

    statuses.add(SessionStatus.authenticated);
    await pumpEventQueue();

    verify(() => tokens.register(token: token)).called(1);
  });

  test('nothing is registered while notifications are disabled', () async {
    when(() => settings.areEnabled).thenReturn(false);

    await sync.sync();

    verifyNever(() => tokens.register(token: any(named: 'token')));
  });

  test('a refreshed token is registered while signed in', () async {
    sync.start();
    await pumpEventQueue();

    refreshes.add('new-token');
    await pumpEventQueue();

    verify(() => tokens.register(token: 'new-token')).called(1);
  });

  group('logout hook', () {
    Future<LogoutHook> startAndCaptureHook() async {
      sync.start();
      await pumpEventQueue();
      return verify(
            () => session.registerLogoutHook(hook: captureAny(named: 'hook')),
          ).captured.single
          as LogoutHook;
    }

    test('unregisters and deletes the token', () async {
      final hook = await startAndCaptureHook();

      await hook();

      verify(() => tokens.unregister(token: token)).called(1);
      verify(() => push.deleteToken()).called(1);
    });

    test('still deletes the token when unregistering fails', () async {
      when(
        () => tokens.unregister(token: any(named: 'token')),
      ).thenAnswer((_) async => const Left(Failure.unknown()));
      final hook = await startAndCaptureHook();

      await hook();

      verify(() => push.deleteToken()).called(1);
      verify(() => logger.error(any())).called(1);
    });
  });
}
