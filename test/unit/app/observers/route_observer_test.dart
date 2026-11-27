import 'package:flutter/material.dart';
import 'package:flutter_all_template/app/observers/route_observer.dart';
import 'package:flutter_all_template/core/services/analytics/domain/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnalytics extends Mock implements IAnalyticsService {}

PageRoute<void> _page(String? name) => MaterialPageRoute<void>(
  builder: (_) => const SizedBox(),
  settings: RouteSettings(name: name, arguments: {'email': 'jane@x.com'}),
);

RawDialogRoute<void> _dialog() => RawDialogRoute<void>(
  pageBuilder: (_, _, _) => const SizedBox(),
  settings: const RouteSettings(name: 'ConfirmDialog'),
);

void main() {
  late MockAnalytics analytics;
  late AppRouteObserver observer;

  setUp(() {
    analytics = MockAnalytics();
    observer = AppRouteObserver(analytics: analytics);
  });

  test('a pushed page is tracked by route name only', () {
    observer.didPush(_page('TodoListRoute'), _page('HomeRoute'));

    verify(() => analytics.trackScreen(name: 'TodoListRoute')).called(1);
    verifyNoMoreInteractions(analytics);
  });

  test('popping a page tracks the page that becomes visible', () {
    observer.didPop(_page('TodoListRoute'), _page('HomeRoute'));

    verify(() => analytics.trackScreen(name: 'HomeRoute')).called(1);
  });

  test('a replaced page tracks the new page', () {
    observer.didReplace(
      newRoute: _page('HomeRoute'),
      oldRoute: _page('SplashRoute'),
    );

    verify(() => analytics.trackScreen(name: 'HomeRoute')).called(1);
  });

  test('dialogs and unnamed routes are not screens', () {
    observer
      ..didPush(_dialog(), _page('HomeRoute'))
      ..didPop(_dialog(), _page('HomeRoute'))
      ..didPush(_page(null), _page('HomeRoute'));

    verifyNever(() => analytics.trackScreen(name: any(named: 'name')));
  });
}
