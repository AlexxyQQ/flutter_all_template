import 'package:flutter/material.dart';
import 'package:flutter_all_template/config/constants/paths/app_path.dart';
import 'package:flutter_all_template/core/common/domain/services/navigation/navigation_service.dart';
import 'package:flutter_all_template/core/common/presentation/routes/app_router.dart';
import 'package:flutter_all_template/features/home/presentation/views/screens/home_screen.dart';
import 'package:flutter_all_template/features/splash/presentation/views/screens/splash_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  setUpAll(loadTestTranslations);

  testWidgets('splash shows the brand then replaces itself with home', (
    tester,
  ) async {
    final router = AppRouter();
    await tester.pumpWidget(routerApp(router.config()));
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byKey(const Key('splash_logo')), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);

    await tester.pump(SplashScreen.displayDuration);
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byKey(const Key('home_title')), findsOneWidget);
    expect(find.byType(SplashScreen), findsNothing);
    // `replace` leaves home as the only page: no back button.
    expect(router.stack, hasLength(1));
    expect(router.current.name, HomeRoute.name);
  });

  testWidgets('a cold notification destination opens on the first frame', (
    tester,
  ) async {
    final router = AppRouter();
    final navigation = NavigationService(appRouter: router);
    await navigation.navigateToPath(AppPaths.home);
    expect(navigation.modalContext, isNull);

    await tester.pumpWidget(routerApp(router.config()));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(navigation.modalContext, router.navigatorKey.currentContext);
    expect(navigation.modalContext, isNotNull);
    expect(navigation.canPop(), isFalse);

    await tester.pumpWidget(const SizedBox.shrink());
    expect(navigation.modalContext, isNull);
  });

  testWidgets('a notification during splash leaves its destination in place', (
    tester,
  ) async {
    final router = AppRouter();
    final navigation = NavigationService(appRouter: router);
    await tester.pumpWidget(routerApp(router.config()));
    await tester.pump();

    await navigation.navigateToPath(AppPaths.home);
    await tester.pump();
    await tester.pump(SplashScreen.displayDuration);
    await tester.pumpAndSettle();

    expect(router.stack, hasLength(1));
    expect(navigation.current.name, HomeRoute.name);
    expect(navigation.canPop(), isFalse);
  });
}
