import 'package:auto_route/auto_route.dart';
import 'package:flutter_all_template/app/router/app_router.gr.dart';
import 'package:flutter_all_template/features/permission/domain/entities/app_permission.dart';
import 'package:flutter_all_template/features/permission/presentation/routes/permission_gate.dart';
import 'package:flutter_all_template/features/permission/presentation/routes/permission_guard.dart';
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

  setUpAll(() => registerFallbackValue(_FakeRoute()));

  setUp(() {
    gate = _MockGate();
    resolver = _MockResolver();
    router = _MockRouter();
  });

  /// The gate answers [answers] one call after another (the guard asks once
  /// before and once after showing the permission screen).
  void stubGate(List<bool> answers) {
    var call = 0;
    when(
      () => gate.canProceed(
        permission: any(named: 'permission'),
        allowIfSkipped: any(named: 'allowIfSkipped'),
      ),
    ).thenAnswer((_) async => answers[call++]);
  }

  void stubScreenResult(bool? result) =>
      when(() => router.push<bool>(any())).thenAnswer((_) async => result);

  PermissionGuard guard({
    AppPermission permission = AppPermission.camera,
    bool allowIfSkipped = true,
  }) => PermissionGuard(
    permission: permission,
    gate: gate,
    allowIfSkipped: allowIfSkipped,
  );

  test('continues navigation when the gate allows it', () async {
    stubGate([true]);

    await guard().onNavigation(resolver, router);

    verify(() => resolver.next()).called(1);
    verifyNever(() => router.push<bool>(any()));
  });

  test('shows the permission screen with a typed route otherwise', () async {
    stubGate([false, true]);
    stubScreenResult(true);

    await guard(
      permission: AppPermission.location,
      allowIfSkipped: false,
    ).onNavigation(resolver, router);

    final pushed =
        verify(() => router.push<bool>(captureAny())).captured.single
            as PermissionRoute;
    expect(pushed.args!.permission, AppPermission.location.name);
    verify(
      () => gate.canProceed(
        permission: AppPermission.location,
        allowIfSkipped: false,
      ),
    ).called(2);
  });

  test('resumes the original navigation when the screen finishes', () async {
    stubGate([false, true]);
    stubScreenResult(true);

    await guard().onNavigation(resolver, router);

    verify(() => resolver.next()).called(1);
  });

  test('aborts when the user backs out of the screen', () async {
    stubGate([false]);
    stubScreenResult(null);

    await guard().onNavigation(resolver, router);

    verify(() => resolver.next(false)).called(1);
  });

  test('aborts when a skip does not count for this guard', () async {
    // The screen returns true for "skipped"; the gate rejects it again because
    // allowIfSkipped is off.
    stubGate([false, false]);
    stubScreenResult(true);

    await guard(allowIfSkipped: false).onNavigation(resolver, router);

    verify(() => resolver.next(false)).called(1);
  });
}
