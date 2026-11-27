import 'package:flutter_all_template/core/services/logger/data/app_logger.dart';
import 'package:flutter_all_template/core/session/session.dart';
import 'package:flutter_all_template/core/session/session_manager_impl.dart';
import 'package:flutter_all_template/core/session/session_scope.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/in_memory_preferences_store.dart';

class _MockTokenStore extends Mock implements ITokenStore {}

class _SilentLogger implements ILoggerService {
  int errors = 0;

  @override
  void debug(String message, {String? name}) {}

  @override
  void info(String message, {String? name}) {}

  @override
  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? name,
  }) {}

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? name,
  }) => errors++;
}

void main() {
  late _MockTokenStore tokenStore;
  late InMemoryPreferencesStore preferences;
  late SessionManagerImpl manager;
  late _SilentLogger logger;

  const tokens = AuthTokens(accessToken: 'a');

  setUpAll(() => registerFallbackValue(tokens));

  setUp(() {
    logger = _SilentLogger();
    AppLogger.configure(logger);
    tokenStore = _MockTokenStore();
    preferences = InMemoryPreferencesStore();
    when(tokenStore.clear).thenAnswer((_) async {});
    when(
      () => tokenStore.save(tokens: any(named: 'tokens')),
    ).thenAnswer((_) async {});
    manager = SessionManagerImpl(
      tokenStore: tokenStore,
      preferences: preferences,
    );
  });

  tearDown(() => manager.dispose());

  group('restore', () {
    test('authenticated when tokens exist', () async {
      when(tokenStore.read).thenAnswer((_) async => tokens);
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
      expect(logger.errors, 1);
    });
  });

  test('signIn saves tokens and emits authenticated', () async {
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

    test('removes session-scoped preferences and keeps the others', () async {
      preferences.values.addAll({
        '${SessionScope.keyPrefix}todo.first_page': 'user A cache',
        'prefs.locale': 'en-GB',
      });

      await manager.signOut();

      expect(preferences.values.keys, ['prefs.locale']);
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

    test('a failed preference cleanup is reported, not swallowed', () async {
      preferences.failWrites = true;
      preferences.values['${SessionScope.keyPrefix}x'] = 'y';

      await expectLater(manager.signOut(), throwsA(anything));
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

  group('session generation', () {
    test('changes on sign-in and sign-out', () async {
      final initial = manager.generation;

      await manager.signIn(tokens: tokens);
      final signedIn = manager.generation;
      await manager.signOut();

      expect(signedIn, greaterThan(initial));
      expect(manager.generation, greaterThan(signedIn));
    });

    test('saveRefreshedTokens saves for the current generation', () async {
      await manager.signIn(tokens: tokens);
      const refreshed = AuthTokens(accessToken: 'b');

      final saved = await manager.saveRefreshedTokens(
        generation: manager.generation,
        tokens: refreshed,
      );

      expect(saved, isTrue);
      verify(() => tokenStore.save(tokens: refreshed)).called(1);
    });

    test('saveRefreshedTokens rejects a stale generation', () async {
      await manager.signIn(tokens: tokens);
      final stale = manager.generation;
      await manager.signIn(tokens: const AuthTokens(accessToken: 'other'));
      clearInteractions(tokenStore);

      final saved = await manager.saveRefreshedTokens(
        generation: stale,
        tokens: const AuthTokens(accessToken: 'late'),
      );

      expect(saved, isFalse);
      verifyNever(() => tokenStore.save(tokens: any(named: 'tokens')));
    });

    test('expire signs out the current generation', () async {
      await manager.signIn(tokens: tokens);

      await manager.expire(generation: manager.generation);

      expect(manager.status, SessionStatus.unauthenticated);
      verify(tokenStore.clear).called(1);
    });

    test('expire ignores a stale generation', () async {
      await manager.signIn(tokens: tokens);
      final stale = manager.generation;
      await manager.signIn(tokens: const AuthTokens(accessToken: 'other'));

      await manager.expire(generation: stale);

      expect(manager.status, SessionStatus.authenticated);
      verifyNever(tokenStore.clear);
    });

    test('expire also removes session-scoped preferences', () async {
      await manager.signIn(tokens: tokens);
      preferences.values['${SessionScope.keyPrefix}todo'] = 'cache';

      await manager.expire(generation: manager.generation);

      expect(preferences.values, isEmpty);
    });
  });
}
