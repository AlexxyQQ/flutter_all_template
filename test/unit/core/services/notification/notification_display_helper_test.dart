import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_all_template/core/services/notification/data/helpers/notification_display_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('notificationIdFor', () {
    test('is a stable FNV-1a hash of the message id', () {
      // Known FNV-1a (32-bit) values, masked to 31 bits.
      expect(
        NotificationDisplayHelper.notificationIdFor(
          message: const RemoteMessage(messageId: ''),
        ),
        0x811c9dc5 & 0x7fffffff,
      );
      expect(
        NotificationDisplayHelper.notificationIdFor(
          message: const RemoteMessage(messageId: 'a'),
        ),
        0xe40c292c & 0x7fffffff,
      );
    });

    test('is positive and the same for the same message id', () {
      const message = RemoteMessage(messageId: '0:1700000000000%abc');

      final first = NotificationDisplayHelper.notificationIdFor(
        message: message,
      );

      expect(first, isNonNegative);
      expect(
        NotificationDisplayHelper.notificationIdFor(message: message),
        first,
      );
    });
  });
}
