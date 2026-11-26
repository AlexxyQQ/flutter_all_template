import 'package:auto_route/auto_route.dart';
import 'package:flutter_all_template/core/common/domain/services/navigation/navigation_service.dart';
import 'package:flutter_all_template/core/common/presentation/routes/app_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRouter extends Mock implements AppRouter {}

class _MockRouteData extends Mock implements RouteData<Object?> {}

void main() {
  late _MockRouter router;
  late NavigationService navigation;

  setUp(() {
    router = _MockRouter();
    navigation = NavigationService(appRouter: router);
  });

  test('pushNamed delegates to pushPath', () async {
    when(() => router.pushPath<Object?>('/x')).thenAnswer((_) async => null);

    await navigation.pushNamed('/x');

    verify(() => router.pushPath<Object?>('/x')).called(1);
  });

  group('closeSpecificRoute', () {
    late _MockRouteData current;

    setUp(() {
      current = _MockRouteData();
      when(() => router.current).thenReturn(current);
    });

    test('pops when the route is on top', () async {
      when(() => current.name).thenReturn('Dialog');
      when(() => router.maybePop<Object?>()).thenAnswer((_) async => true);

      expect(await navigation.closeSpecificRoute(name: 'Dialog'), isTrue);
      verify(() => router.maybePop<Object?>()).called(1);
    });

    test('removes it from the stack otherwise', () async {
      when(() => current.name).thenReturn('Home');
      when(() => router.removeWhere(any())).thenReturn(true);

      expect(await navigation.closeSpecificRoute(name: 'Dialog'), isTrue);
      verifyNever(() => router.maybePop<Object?>());
    });
  });

  test('checkIfAlreadyOpened compares the current route name', () {
    final current = _MockRouteData();
    when(() => router.current).thenReturn(current);
    when(() => current.name).thenReturn('A');

    expect(navigation.checkIfAlreadyOpened(name: 'A'), isTrue);
    expect(navigation.checkIfAlreadyOpened(name: 'B'), isFalse);
  });
}
