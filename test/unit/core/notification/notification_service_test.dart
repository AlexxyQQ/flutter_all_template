import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_all_template/config/constants/paths/app_path.dart';
import 'package:flutter_all_template/core/common/domain/entities/failure.dart';
import 'package:flutter_all_template/core/common/domain/services/logger/logger_service.dart';
import 'package:flutter_all_template/core/common/domain/services/navigation/navigation_service.dart';
import 'package:flutter_all_template/core/common/domain/services/notification/domain/push_token_repository.dart';
import 'package:flutter_all_template/core/common/domain/services/notification/helpers/notification_prefs.dart';
import 'package:flutter_all_template/core/common/domain/services/notification/notification_route_allowlist.dart';
import 'package:flutter_all_template/core/common/domain/services/notification/notification_service.dart';
import 'package:flutter_all_template/core/common/domain/services/notification/push/push_messaging_client.dart';
import 'package:flutter_all_template/core/session/session.dart';
import 'package:flutter_all_template/core/storage/key_value_stores.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockPush extends Mock implements PushMessagingClient {}

class _MockAwesome extends Mock implements AwesomeNotifications {}

class _MockPrefs extends Mock implements PreferencesStore {}

class _MockTokens extends Mock implements PushTokenRepository {}

class _MockSession extends Mock implements SessionManager {}

class _MockNavigation extends Mock implements NavigationService {}

class _MockLogger extends Mock implements ILoggerService {}

const _token = 'device-token';

void main() {
  late _MockPush push;
  late _MockAwesome awesome;
  late _MockPrefs prefs;
  late _MockTokens tokens;
  late _MockSession session;
  late _MockNavigation navigation;
  late _MockLogger logger;
  late NotificationService service;

  setUpAll(() {
    registerFallbackValue(<NotificationChannel>[]);
    registerFallbackValue(() async {});
  });

  setUp(() {
    push = _MockPush();
    awesome = _MockAwesome();
    prefs = _MockPrefs();
    tokens = _MockTokens();
    session = _MockSession();
    navigation = _MockNavigation();
    logger = _MockLogger();

    when(() => prefs.getBool(NotificationPrefs.enabledKey)).thenReturn(true);
    when(
      () => prefs.setBool(any(), value: any(named: 'value')),
    ).thenAnswer((_) async {});
    when(() => session.status).thenReturn(SessionStatus.unauthenticated);
    when(
      () => session.statusStream,
    ).thenAnswer((_) => const Stream<SessionStatus>.empty());
    when(() => push.getToken()).thenAnswer((_) async => _token);
    when(() => push.deleteToken()).thenAnswer((_) async {});
    when(() => push.requestPermission()).thenAnswer((_) async => true);
    when(
      () => push.onMessage,
    ).thenAnswer((_) => const Stream<RemoteMessage>.empty());
    when(
      () => push.onTokenRefresh,
    ).thenAnswer((_) => const Stream<String>.empty());
    when(
      () => tokens.register(token: any(named: 'token')),
    ).thenAnswer((_) async => const Right(null));
    when(
      () => tokens.unregister(token: any(named: 'token')),
    ).thenAnswer((_) async => const Right(null));
    when(
      () => awesome.initialize(any(), any(), debug: any(named: 'debug')),
    ).thenAnswer((_) async => true);
    when(
      () => awesome.setListeners(
        onActionReceivedMethod: any(named: 'onActionReceivedMethod'),
      ),
    ).thenAnswer((_) async => true);
    when(
      () => awesome.getInitialNotificationAction(),
    ).thenAnswer((_) async => null);
    when(() => awesome.cancelAll()).thenAnswer((_) async {});
    when(() => awesome.isNotificationAllowed()).thenAnswer((_) async => true);
    when(() => navigation.pushNamed(any())).thenAnswer((_) async {});

    service = NotificationService(
      push: push,
      awesome: awesome,
      prefs: prefs,
      tokens: tokens,
      session: session,
      navigation: navigation,
      routes: const NotificationRouteAllowlist.custom({
        'home': AppPaths.splashRoute,
      }),
      logger: logger,
    );
  });

  group('navigateFromPayload (allowlist)', () {
    test('navigates to an allowlisted destination', () async {
      await service.navigateFromPayload({'type': 'home'});

      verify(() => navigation.pushNamed(AppPaths.splashRoute)).called(1);
    });

    test('ignores and logs an unknown route', () async {
      await service.navigateFromPayload({'route': '/internal/debug'});
      await service.navigateFromPayload({'redirect_url': '/anything'});

      verifyNever(() => navigation.pushNamed(any()));
      verify(() => logger.i(any())).called(1);
    });
  });

  group('logout hook', () {
    test(
      'initialize registers a hook that unregisters + deletes the token',
      () async {
        await service.initialize();
        final hook =
            verify(
                  () => session.registerLogoutHook(
                    hook: captureAny(named: 'hook'),
                  ),
                ).captured.single
                as LogoutHook;

        await hook();

        verify(() => tokens.unregister(token: _token)).called(1);
        verify(() => push.deleteToken()).called(1);
      },
    );

    test('the hook still deletes the token when unregistering fails', () async {
      when(
        () => tokens.unregister(token: any(named: 'token')),
      ).thenAnswer((_) async => const Left(Failure.unknown()));
      await service.initialize();
      final hook =
          verify(
                () =>
                    session.registerLogoutHook(hook: captureAny(named: 'hook')),
              ).captured.single
              as LogoutHook;

      await hook();

      verify(() => push.deleteToken()).called(1);
    });

    test(
      'initialize runs once and registers the token when signed in',
      () async {
        when(() => session.status).thenReturn(SessionStatus.authenticated);

        await service.initialize();
        await service.initialize();

        verify(
          () => session.registerLogoutHook(hook: any(named: 'hook')),
        ).called(1);
        verify(() => tokens.register(token: _token)).called(1);
      },
    );
  });

  group('toggleNotifications', () {
    test('off: unregisters, deletes the token and cancels all', () async {
      await service.toggleNotifications(isEnabled: false);

      verify(
        () => prefs.setBool(NotificationPrefs.enabledKey, value: false),
      ).called(1);
      verify(() => tokens.unregister(token: _token)).called(1);
      verify(() => push.deleteToken()).called(1);
      verify(() => awesome.cancelAll()).called(1);
      verifyNever(() => awesome.cancel(any()));
    });

    test('on while signed in: registers the token', () async {
      when(() => session.status).thenReturn(SessionStatus.authenticated);

      await service.toggleNotifications(isEnabled: true);

      verify(() => tokens.register(token: _token)).called(1);
    });
  });

  group('suppression', () {
    test('suppresses the thread on screen, ignoring the th_ prefix', () {
      service.suppressNotificationsForThread('th_42');

      expect(
        service.shouldSuppress(const RemoteMessage(data: {'thread_id': '42'})),
        isTrue,
      );
      expect(
        service.shouldSuppress(
          const RemoteMessage(data: {'thread_id': 'th_7'}),
        ),
        isFalse,
      );

      service.clearThreadSuppression();
      expect(
        service.shouldSuppress(const RemoteMessage(data: {'thread_id': '42'})),
        isFalse,
      );
    });

    test('suppresses everything when disabled', () {
      when(() => prefs.getBool(NotificationPrefs.enabledKey)).thenReturn(false);
      expect(service.shouldSuppress(const RemoteMessage()), isTrue);
    });
  });

  test('parsePayload decodes JSON values only', () {
    expect(
      NotificationService.parsePayload({
        'a': '{"b":1}',
        'c': 'plain',
        'd': null,
        'e': '{broken',
      }),
      {
        'a': {'b': 1},
        'c': 'plain',
        'd': null,
        'e': '{broken',
      },
    );
  });
}
