// brick:if use_permissions
import 'package:flutter_all_template/core/common/features/permission/domain/repository/permission_repository.dart';
import 'package:flutter_all_template/core/common/features/permission/presentation/bloc/permission_bloc.dart';
import 'package:flutter_all_template/core/common/features/permission/presentation/routes/permission_gate.dart';
// brick:end
import 'package:flutter_all_template/core/common/locator/service_locator.dart';
import 'package:flutter_all_template/core/common/presentation/blocs/locale/locale_cubit.dart';
import 'package:flutter_all_template/core/common/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter_all_template/core/common/presentation/routes/app_router.dart';
import 'package:flutter_all_template/core/network/api_client.dart';
import 'package:flutter_all_template/core/session/session.dart';
import 'package:flutter_all_template/core/storage/key_value_stores.dart';
import 'package:flutter_all_template/features/example/domain/repositories/todo_repository.dart';
import 'package:flutter_all_template/features/example/presentation/bloc/todo_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// Guards against the class of bug where a repository/service is annotated
/// incorrectly (or not at all) and only fails at runtime when first resolved.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    await sl.reset();
    await configureInjection();
  });

  tearDownAll(() => sl.reset());

  test('core infrastructure resolves', () {
    expect(sl<ApiClient>(), isNotNull);
    expect(sl<SecureStore>(), isNotNull);
    expect(sl<PreferencesStore>(), isNotNull);
    expect(sl<TokenStore>(), isNotNull);
    expect(sl<SessionManager>(), isNotNull);
  });

  test('features resolve through their interfaces', () {
    expect(sl<ITodoRepository>(), isNotNull);
    expect(sl<TodoListBloc>(), isNotNull);
  });

  // brick:if use_permissions
  test('permission module resolves', () {
    expect(sl<IPermissionRepository>(), isNotNull);
    expect(sl<PermissionGate>(), isNotNull);
    expect(sl<PermissionBloc>(), isNotNull);
  });
  // brick:end

  test('presentation roots resolve', () {
    expect(sl<AppRouter>(), isNotNull);
    expect(sl<ThemeCubit>(), isNotNull);
    expect(sl<LocaleCubit>(), isNotNull);
  });
}
