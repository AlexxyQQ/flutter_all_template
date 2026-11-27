import 'package:flutter/material.dart';
import 'package:flutter_all_template/app/router/app_router.dart';
import 'package:flutter_all_template/config/constants/paths/app_path.dart';
import 'package:flutter_all_template/core/services/navigation/presentation/navigation_service.dart';
import 'package:flutter_all_template/features/home/presentation/views/screens/home_screen.dart';
import 'package:flutter_all_template/features/splash/presentation/views/screens/splash_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  setUpAll(loadTestTranslations);

  testWidgets('splash replaces itself with home right after the first frame', (
    tester,
  ) async {
    final router = AppRouter();
    await tester.pumpWidget(routerApp(router.config()));

    // No fixed delay: only the route transition is left to run.
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byKey(const Key('home_title')), findsOneWidget);
    expect(find.byType(SplashScreen), findsNothing);
    // `replace` leaves home as the only page: no back button.
    expect(router.stack, hasLength(1));
    expect(router.topRoute.name, HomeRoute.name);
  });

  testWidgets('a cold notification destination opens on the first frame', (
    tester,
  ) async {
    final router = AppRouter();
    final navigation = NavigationService(router: router);
    await navigation.navigateToPath(path: AppPaths.home);

    await tester.pumpWidget(routerApp(router.config()));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(SplashScreen), findsNothing);
    expect(router.canPop(), isFalse);
  });
}
