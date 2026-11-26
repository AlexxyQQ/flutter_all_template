import 'package:flutter_all_template/core/common/domain/services/logger/logger_service.dart';
import 'package:flutter_all_template/core/session/session.dart';
import 'package:flutter_all_template/core/session/session_manager_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockTokenStore extends Mock implements TokenStore {}

class _SilentLogger implements ILoggerService {
  int errors = 0;

  @override
  void d(String message, {String? name}) {}

  @override
  void i(String message, {String? name}) {}

  @override
  void w(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? name,
  }) {}

  @override
  void e(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? name,
  }) => errors++;
}

void main() {
  late _MockTokenStore tokenStore;
  late SessionManagerImpl manager;
  late _SilentLogger logger;

  setUp(() {
    logger = _SilentLogger();
    AppLogger.configure(logger);
    tokenStore = _MockTokenStore();
    when(tokenStore.clear).thenAnswer((_) async {});
    manager = SessionManagerImpl(tokenStore: tokenStore);
  });

  tearDown(() => manager.dispose());

  group('restore', () {
    test('authenticated when tokens exist', () async {
      when(
        tokenStore.read,
      ).thenAnswer((_) async => const AuthTokens(accessToken: 'a'));
      await manager.restore();
      expect(manager.status, SessionStatus.authenticated);
    });

    test('unauthenticated when no tokens', () async {
      when(tokenStore.read).thenAnswer((_) async => null);
      await manager.restore();
      expect(manager.status, SessionStatus.unauthenticated);
    });

    test('unauthenticated (not crashing) when storage fails', () async {
      when(tokenStore.read).thenThrow(Exception('keystore'));
      await manager.restore();
      expect(manager.status, SessionStatus.unauthenticated);
    });
  });

  test('signIn saves tokens and emits authenticated', () async {
    const tokens = AuthTokens(accessToken: 'a');
    when(() => tokenStore.save(tokens: tokens)).thenAnswer((_) async {});

    final emitted = manager.statusStream.take(2).toList();
    await manager.signIn(tokens: tokens);

    expect(await emitted, [SessionStatus.unknown, SessionStatus.authenticated]);
    verify(() => tokenStore.save(tokens: tokens)).called(1);
  });

  group('signOut', () {
    test('runs every hook, then clears tokens', () async {
      final calls = <String>[];
      manager
        ..registerLogoutHook(hook: () async => calls.add('push'))
        ..registerLogoutHook(hook: () async => calls.add('cache'));
      when(tokenStore.clear).thenAnswer((_) async => calls.add('tokens'));

      await manager.signOut();

      expect(calls, ['push', 'cache', 'tokens']);
      expect(manager.status, SessionStatus.unauthenticated);
    });

    test('a throwing hook does not stop the others and never throws', () async {
      var secondRan = false;
      manager
        ..registerLogoutHook(hook: () async => throw StateError('hook failed'))
        ..registerLogoutHook(hook: () async => secondRan = true);

      await expectLater(manager.signOut(), completes);

      expect(secondRan, isTrue);
      verify(tokenStore.clear).called(1);
      expect(logger.errors, 1);
    });

    test('reports a failed durable logout', () async {
      when(tokenStore.clear).thenThrow(Exception('keystore'));
      await expectLater(manager.signOut(), throwsException);
      expect(manager.status, SessionStatus.unknown);
    });

    test('concurrent calls share a single run', () async {
      var hookRuns = 0;
      manager.registerLogoutHook(hook: () async => hookRuns++);

      await Future.wait([manager.signOut(), manager.signOut()]);

      expect(hookRuns, 1);
      verify(tokenStore.clear).called(1);
    });
  });
}
