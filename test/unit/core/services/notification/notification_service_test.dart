import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_all_template/core/services/logger/domain/logger_service.dart';
import 'package:flutter_all_template/core/services/notification/data/helpers/notification_display_helper.dart';
import 'package:flutter_all_template/core/services/notification/data/notification_preferences.dart';
import 'package:flutter_all_template/core/services/notification/data/notification_service.dart';
import 'package:flutter_all_template/core/services/notification/data/notification_tap_router.dart';
import 'package:flutter_all_template/core/services/notification/data/push/push_messaging_client.dart';
import 'package:flutter_all_template/core/services/notification/data/push_token_sync.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPush extends Mock implements IPushMessagingClient {}

class _MockSettings extends Mock implements NotificationPreferences {}

class _MockDisplay extends Mock implements NotificationDisplayHelper {}

class _MockTaps extends Mock implements NotificationTapRouter {}

class _MockTokens extends Mock implements PushTokenSync {}

class _MockLogger extends Mock implements ILoggerService {}

void main() {
  late _MockPush push;
  late _MockSettings settings;
  late _MockDisplay display;
  late _MockTaps taps;
  late _MockTokens tokens;
  late NotificationService service;
  late StreamController<RemoteMessage> messages;

  setUpAll(() {
    registerFallbackValue(const RemoteMessage());
    registerFallbackValue((RemoteMessage message) async {});
  });

  setUp(() {
    push = _MockPush();
    settings = _MockSettings();
    display = _MockDisplay();
    taps = _MockTaps();
    tokens = _MockTokens();
    messages = StreamController<RemoteMessage>.broadcast();

    when(() => settings.areEnabled).thenReturn(true);
    when(
      () => settings.setEnabled(value: any(named: 'value')),
    ).thenAnswer((_) async {});
    when(() => push.onMessage).thenAnswer((_) => messages.stream);
    when(() => display.initialize()).thenAnswer((_) async {});
    when(() => display.cancelAll()).thenAnswer((_) async {});
    when(() => display.cancel(id: any(named: 'id'))).thenAnswer((_) async {});
    when(
      () => display.showRemoteMessage(message: any(named: 'message')),
    ).thenAnswer((_) async {});
    when(() => taps.start()).thenAnswer((_) async {});
    when(() => tokens.dispose()).thenAnswer((_) async {});
    when(() => tokens.sync()).thenAnswer((_) async {});
    when(() => tokens.unregisterAndDelete()).thenAnswer((_) async {});

    service = NotificationService(
      push: push,
      settings: settings,
      display: display,
      taps: taps,
      tokens: tokens,
      logger: _MockLogger(),
    );
  });

  tearDown(() async {
    await service.dispose();
    await messages.close();
  });

  group('initialize', () {
    test('sets up display, taps, background handler and tokens', () async {
      await service.initialize();

      verifyInOrder([
        () => display.initialize(),
        () => taps.start(),
        () => push.registerBackgroundHandler(handler: any(named: 'handler')),
        () => tokens.start(),
      ]);
    });

    test('runs once however often it is called', () async {
      await service.initialize();
      await service.initialize();

      verify(() => taps.start()).called(1);
      verify(() => tokens.start()).called(1);
    });

    test('concurrent callers share a failed setup and can retry', () async {
      var attempts = 0;
      when(() => taps.start()).thenAnswer((_) async {
        if (++attempts == 1) {
          throw StateError('listener setup failed');
        }
      });

      final first = service.initialize();
      expect(service.initialize(), same(first));
      await expectLater(first, throwsStateError);

      await service.initialize();

      expect(attempts, 2);
      verify(() => tokens.start()).called(1);
    });
  });

  group('foreground messages', () {
    test('are shown while notifications are enabled', () async {
      await service.initialize();

      messages.add(const RemoteMessage());
      await pumpEventQueue();

      verify(
        () => display.showRemoteMessage(message: any(named: 'message')),
      ).called(1);
    });

    test('are dropped while notifications are disabled', () async {
      when(() => settings.areEnabled).thenReturn(false);
      await service.initialize();

      messages.add(const RemoteMessage());
      await pumpEventQueue();

      verifyNever(
        () => display.showRemoteMessage(message: any(named: 'message')),
      );
    });
  });

  group('toggleNotifications', () {
    test('off: unregisters, deletes the token and cancels all', () async {
      await service.toggleNotifications(isEnabled: false);

      verify(() => settings.setEnabled(value: false)).called(1);
      verify(() => tokens.unregisterAndDelete()).called(1);
      verify(() => display.cancelAll()).called(1);
    });

    test('on: registers the token again', () async {
      await service.toggleNotifications(isEnabled: true);

      verify(() => settings.setEnabled(value: true)).called(1);
      verify(() => tokens.sync()).called(1);
      verifyNever(() => tokens.unregisterAndDelete());
    });
  });

  group('showNotification', () {
    test('is skipped while disabled unless forced', () async {
      when(() => settings.areEnabled).thenReturn(false);

      await service.showNotification(message: const RemoteMessage());
      verifyNever(
        () => display.showRemoteMessage(message: any(named: 'message')),
      );

      await service.showNotification(
        message: const RemoteMessage(),
        force: true,
      );
      verify(
        () => display.showRemoteMessage(message: any(named: 'message')),
      ).called(1);
    });
  });

  test('cancelNotification forwards the id', () async {
    await service.cancelNotification(id: 7);

    verify(() => display.cancel(id: 7)).called(1);
  });
}
