import 'package:flutter_all_template/config/constants/paths/app_path.dart';
import 'package:flutter_all_template/core/services/notification/data/notification_route_allowlist.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const allowlist = NotificationRouteAllowlist.custom({
    'home': AppPaths.home,
    'order': '/orders',
  });

  test('resolves a known type', () {
    expect(allowlist.resolve({'type': 'order'}), '/orders');
  });

  test('falls back to the route key', () {
    expect(allowlist.resolve({'route': 'home'}), AppPaths.home);
  });

  test('default home destination is the registered home path', () {
    expect(
      NotificationRouteAllowlist().resolve({'type': 'home'}),
      AppPaths.home,
    );
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
}
