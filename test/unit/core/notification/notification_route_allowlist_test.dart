import 'package:flutter_all_template/config/constants/paths/app_path.dart';
import 'package:flutter_all_template/core/common/domain/services/notification/helpers/notification_thread.dart';
import 'package:flutter_all_template/core/common/domain/services/notification/notification_route_allowlist.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const allowlist = NotificationRouteAllowlist.custom({
    'home': AppPaths.splashRoute,
    'order': '/orders',
  });

  test('resolves a known type', () {
    expect(allowlist.resolve({'type': 'order'}), '/orders');
  });

  test('falls back to the route key', () {
    expect(allowlist.resolve({'route': 'home'}), AppPaths.splashRoute);
  });

  test('ignores unknown values and raw paths', () {
    expect(allowlist.resolve({'type': '/debug/secret'}), isNull);
    expect(allowlist.resolve({'route': '/orders'}), isNull);
    expect(allowlist.resolve({'redirect_url': '/orders'}), isNull);
    expect(allowlist.resolve({'type': 42}), isNull);
    expect(allowlist.resolve({}), isNull);
  });

  test('hasRoutingKey', () {
    expect(allowlist.hasRoutingKey({'type': 'x'}), isTrue);
    expect(allowlist.hasRoutingKey({'foo': 'x'}), isFalse);
  });

  test('normalizeThreadId strips only the leading prefix', () {
    expect(normalizeThreadId('th_123'), '123');
    expect(normalizeThreadId('123'), '123');
    expect(normalizeThreadId('a_th_1'), 'a_th_1');
  });
}
