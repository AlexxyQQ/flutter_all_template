import 'package:flutter_all_template/app/router/app_router.dart';
import 'package:flutter_all_template/config/constants/paths/app_path.dart';
import 'package:flutter_all_template/core/services/navigation/presentation/navigation_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppRouter router;
  late NavigationService navigation;

  setUp(() {
    router = AppRouter();
    navigation = NavigationService(router: router);
  });

  test('opens an app path', () async {
    await navigation.navigateToPath(path: AppPaths.home);

    expect(router.topRoute.name, HomeRoute.name);
  });

  test('navigating to the same path reuses its stack entry', () async {
    await navigation.navigateToPath(path: AppPaths.home);
    await navigation.navigateToPath(path: AppPaths.home);

    expect(router.stack, hasLength(1));
    expect(router.topRoute.name, HomeRoute.name);
  });
}
