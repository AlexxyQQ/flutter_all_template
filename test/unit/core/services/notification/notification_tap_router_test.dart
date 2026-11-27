import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_all_template/config/constants/paths/app_path.dart';
import 'package:flutter_all_template/core/services/logger/domain/logger_service.dart';
import 'package:flutter_all_template/core/services/navigation/presentation/navigation_service.dart';
import 'package:flutter_all_template/core/services/notification/data/notification_route_allowlist.dart';
import 'package:flutter_all_template/core/services/notification/data/notification_tap_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAwesome extends Mock implements AwesomeNotifications {}

class _MockNavigation extends Mock implements NavigationService {}

class _MockLogger extends Mock implements ILoggerService {}

void main() {
  late _MockAwesome awesome;
  late _MockNavigation navigation;
  late _MockLogger logger;
  late NotificationTapRouter router;
  late Future<void> Function(ReceivedAction) onAction;

  ReceivedAction actionFor(Map<String, String> payload) =>
      ReceivedAction().fromMap({'payload': payload});

  setUpAll(() {
    registerFallbackValue((ReceivedAction action) async {});
  });

  setUp(() {
    awesome = _MockAwesome();
    navigation = _MockNavigation();
    logger = _MockLogger();

    when(
      () => awesome.getInitialNotificationAction(removeFromActionEvents: true),
    ).thenAnswer((_) async => null);
    when(
      () => awesome.setListeners(
        onActionReceivedMethod: any(named: 'onActionReceivedMethod'),
      ),
    ).thenAnswer((invocation) async {
      onAction =
          invocation.namedArguments[#onActionReceivedMethod]!
              as Future<void> Function(ReceivedAction);
      return true;
    });
    when(
      () => navigation.navigateToPath(
        path: any(named: 'path'),
        onFailure: any(named: 'onFailure'),
      ),
    ).thenAnswer((_) async {});

    router = NotificationTapRouter(
      awesome: awesome,
      navigation: navigation,
      routes: const NotificationRouteAllowlist.custom({'home': AppPaths.home}),
      logger: logger,
    );
  });

  tearDown(() => router.dispose());

  void verifyOpened(int times) => verify(
    () => navigation.navigateToPath(
      path: AppPaths.home,
      onFailure: any(named: 'onFailure'),
    ),
  ).called(times);

  group('cold start', () {
    test('the launch tap is stored, not opened, during start', () async {
      when(
        () =>
            awesome.getInitialNotificationAction(removeFromActionEvents: true),
      ).thenAnswer((_) async => actionFor({'type': 'home'}));

      await router.start();

      verifyNever(
        () => navigation.navigateToPath(
          path: any(named: 'path'),
          onFailure: any(named: 'onFailure'),
        ),
      );
    });

    test('openPendingLaunchDestination opens it exactly once', () async {
      when(
        () =>
            awesome.getInitialNotificationAction(removeFromActionEvents: true),
      ).thenAnswer((_) async => actionFor({'type': 'home'}));
      await router.start();

      await router.openPendingLaunchDestination();
      await router.openPendingLaunchDestination();

      verifyOpened(1);
    });

    test('is a no-op when the app was not launched by a tap', () async {
      await router.start();

      await router.openPendingLaunchDestination();

      verifyNever(
        () => navigation.navigateToPath(
          path: any(named: 'path'),
          onFailure: any(named: 'onFailure'),
        ),
      );
    });

    test('a live tap supersedes the pending launch destination', () async {
      when(
        () =>
            awesome.getInitialNotificationAction(removeFromActionEvents: true),
      ).thenAnswer((_) async => actionFor({'type': 'home'}));
      await router.start();

      await onAction(actionFor({'type': 'unknown'}));
      await router.openPendingLaunchDestination();

      verifyNever(
        () => navigation.navigateToPath(
          path: any(named: 'path'),
          onFailure: any(named: 'onFailure'),
        ),
      );
    });

    test('fails when the plugin cannot listen', () async {
      when(
        () => awesome.setListeners(
          onActionReceivedMethod: any(named: 'onActionReceivedMethod'),
        ),
      ).thenAnswer((_) async => false);

      await expectLater(router.start(), throwsStateError);
    });
  });

  group('allowlist', () {
    test('a live tap navigates to an allowlisted destination', () async {
      await router.start();

      await onAction(actionFor({'type': 'home'}));
      await pumpEventQueue();

      verifyOpened(1);
    });

    test('ignores and logs an unknown route', () async {
      await router.openFromPayload(payload: {'route': '/internal/debug'});
      await router.openFromPayload(payload: {'redirect_url': '/anything'});

      verifyNever(
        () => navigation.navigateToPath(
          path: any(named: 'path'),
          onFailure: any(named: 'onFailure'),
        ),
      );
      verify(() => logger.info(any())).called(1);
    });

    test('a navigation error is logged, not thrown', () async {
      when(
        () => navigation.navigateToPath(
          path: any(named: 'path'),
          onFailure: any(named: 'onFailure'),
        ),
      ).thenThrow(StateError('no router'));

      await router.openFromPayload(payload: {'type': 'home'});

      verify(
        () => logger.error(
          any(),
          error: any(named: 'error'),
          stackTrace: any(named: 'stackTrace'),
        ),
      ).called(1);
    });
  });

  test('parsePayload decodes JSON values only', () {
    expect(
      NotificationTapRouter.parsePayload({
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
