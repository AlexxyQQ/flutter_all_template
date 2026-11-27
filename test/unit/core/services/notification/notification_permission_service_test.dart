import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_all_template/core/services/notification/data/notification_permission_service.dart';
import 'package:flutter_all_template/core/services/notification/data/push/push_messaging_client.dart';
import 'package:flutter_all_template/core/services/notification/data/push_token_sync.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAwesome extends Mock implements AwesomeNotifications {}

class _MockPush extends Mock implements IPushMessagingClient {}

class _MockTokens extends Mock implements PushTokenSync {}

void main() {
  late _MockAwesome awesome;
  late _MockPush push;
  late _MockTokens tokens;
  late NotificationPermissionService service;

  setUp(() {
    awesome = _MockAwesome();
    push = _MockPush();
    tokens = _MockTokens();
    when(() => tokens.sync()).thenAnswer((_) async {});
    service = NotificationPermissionService(
      awesome: awesome,
      push: push,
      tokens: tokens,
    );
  });

  void stub({
    required bool displayAllowed,
    required bool displayPrompt,
    required bool pushAllowed,
  }) {
    when(
      () => awesome.isNotificationAllowed(),
    ).thenAnswer((_) async => displayAllowed);
    when(
      () => awesome.requestPermissionToSendNotifications(),
    ).thenAnswer((_) async => displayPrompt);
    when(() => push.requestPermission()).thenAnswer((_) async => pushAllowed);
  }

  test('allowed only when both display and push are granted', () async {
    stub(displayAllowed: false, displayPrompt: true, pushAllowed: true);

    expect(await service.requestPermission(), isTrue);
    verify(() => tokens.sync()).called(1);
  });

  test('denied when push authorization is denied', () async {
    stub(displayAllowed: true, displayPrompt: true, pushAllowed: false);

    expect(await service.requestPermission(), isFalse);
    verifyNever(() => tokens.sync());
  });

  test('denied when local display permission is denied', () async {
    stub(displayAllowed: false, displayPrompt: false, pushAllowed: true);

    expect(await service.requestPermission(), isFalse);
    verifyNever(() => tokens.sync());
  });

  test('isPermissionGranted reflects the display permission', () async {
    stub(displayAllowed: true, displayPrompt: true, pushAllowed: true);

    expect(await service.isPermissionGranted(), isTrue);
  });
}
