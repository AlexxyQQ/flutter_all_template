import 'package:flutter_all_template/config/constants/paths/app_path.dart';
import 'package:flutter_all_template/core/common/domain/services/navigation/navigation_service.dart';
import 'package:flutter_all_template/core/common/presentation/routes/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppRouter router;
  late NavigationService navigation;

  setUp(() {
    router = AppRouter();
    navigation = NavigationService(appRouter: router);
  });

  test('finds no current page before a destination is set', () {
    expect(navigation.checkIfAlreadyOpened(name: HomeRoute.name), isFalse);
    expect(navigation.closeSpecificRoute(name: HomeRoute.name), isFalse);
    expect(navigation.modalContext, isNull);
  });

  test('navigating to the same path reuses its stack entry', () async {
    await navigation.navigateToPath(AppPaths.home);
    await navigation.navigateToPath(AppPaths.home);

    expect(router.stack, hasLength(1));
    expect(navigation.current.name, HomeRoute.name);
  });
}
