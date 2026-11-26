import 'package:auto_route/auto_route.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/entities/app_permission.dart';
import 'package:flutter_all_template/core/common/features/permission/presentation/routes/permission_gate.dart';
import 'package:flutter_all_template/core/common/features/permission/presentation/routes/permission_guard.dart';
import 'package:flutter_all_template/core/common/presentation/routes/app_router.gr.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGate extends Mock implements PermissionGate {}

class _MockResolver extends Mock implements NavigationResolver {}

class _MockRouter extends Mock implements StackRouter {}

class _FakeRoute extends Fake implements PageRouteInfo<Object?> {}

void main() {
  late _MockGate gate;
  late _MockResolver resolver;
  late _MockRouter router;

  setUpAll(() {
    registerFallbackValue(AppPermission.camera);
    registerFallbackValue(_FakeRoute());
  });

  setUp(() {
    gate = _MockGate();
    resolver = _MockResolver();
    router = _MockRouter();
  });

  void stubGate({required bool allowed}) => when(
    () => gate.canProceed(any(), allowIfSkipped: any(named: 'allowIfSkipped')),
  ).thenAnswer((_) async => allowed);

  test('continues navigation when the gate allows it', () async {
    stubGate(allowed: true);

    await PermissionGuard(
      AppPermission.camera,
      gate: gate,
    ).onNavigation(resolver, router);

    verify(() => resolver.next()).called(1);
    verifyNever(() => resolver.redirectUntil(any()));
  });

  test('redirects to the permission screen otherwise', () async {
    stubGate(allowed: false);

    await PermissionGuard(
      AppPermission.location,
      gate: gate,
      allowIfSkipped: false,
    ).onNavigation(resolver, router);

    verifyNever(() => resolver.next());
    final captured =
        verify(() => resolver.redirectUntil(captureAny())).captured.single
            as PermissionScreenRoute;
    expect(captured.args!.permission, AppPermission.location.name);
    expect(captured.args!.onResult, isNotNull);
    expect(captured.args!.nextRoute, isNull);
    verify(
      () => gate.canProceed(AppPermission.location, allowIfSkipped: false),
    ).called(1);
  });

  test('screen result resumes or aborts the original navigation', () async {
    stubGate(allowed: false);
    await PermissionGuard(
      AppPermission.camera,
      gate: gate,
    ).onNavigation(resolver, router);
    final route =
        verify(() => resolver.redirectUntil(captureAny())).captured.single
            as PermissionScreenRoute;

    route.args!.onResult!(false);

    verify(() => resolver.next(false)).called(1);
  });
}
