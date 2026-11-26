import 'package:flutter/material.dart';
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
}
