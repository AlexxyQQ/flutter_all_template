// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_all_template/config/observers/route_observer.dart'
    as _i21;
import 'package:flutter_all_template/core/common/domain/services/logger/logger_service.dart'
    as _i392;
import 'package:flutter_all_template/core/common/domain/services/navigation/navigation_service.dart'
    as _i702;
import 'package:flutter_all_template/core/common/domain/services/network/dio_service.dart'
    as _i601;
import 'package:flutter_all_template/core/common/domain/services/network/interceptor/authentication_interceptor.dart'
    as _i659;
import 'package:flutter_all_template/core/common/domain/services/network/interceptor/connectivity_interceptor.dart'
    as _i513;
import 'package:flutter_all_template/core/common/domain/services/network/interceptor/error_interceptor.dart'
    as _i618;
import 'package:flutter_all_template/core/common/domain/services/network/interceptor/http_override.dart'
    as _i991;
import 'package:flutter_all_template/core/common/features/app_settings/data/data_sources/local/app_setting_local_data_source.dart'
    as _i204;
import 'package:flutter_all_template/core/common/features/app_settings/data/repositories/app_setting_repository_impl.dart'
    as _i857;
import 'package:flutter_all_template/core/common/features/app_settings/domain/repositories/app_setting_repository.dart'
    as _i669;
import 'package:flutter_all_template/core/common/features/app_settings/domain/services/cache/app_setting_cache.dart'
    as _i974;
import 'package:flutter_all_template/core/common/features/app_settings/presentation/bloc/app_setting_bloc.dart'
    as _i611;
import 'package:flutter_all_template/core/common/features/permission/data/repository/permission_repository_impl.dart'
    as _i454;
import 'package:flutter_all_template/core/common/features/permission/domain/repository/permission_repository.dart'
    as _i765;
import 'package:flutter_all_template/core/common/features/permission/domain/services/permission_cache_service.dart'
    as _i374;
import 'package:flutter_all_template/core/common/features/permission/presentation/bloc/permission_bloc.dart'
    as _i448;
import 'package:flutter_all_template/core/common/presentation/blocs/locale/locale_cubit.dart'
    as _i142;
import 'package:flutter_all_template/core/common/presentation/blocs/theme/theme_cubit.dart'
    as _i947;
import 'package:flutter_all_template/core/common/presentation/helpers/date_time_helper.dart'
    as _i696;
import 'package:flutter_all_template/core/common/presentation/routes/app_router.dart'
    as _i1069;
import 'package:flutter_all_template/features/another/bloc/test_cubit.dart'
    as _i364;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt initGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i21.AppRouteObserver>(() => _i21.AppRouteObserver());
    gh.factory<_i142.LocaleCubit>(() => _i142.LocaleCubit());
    gh.factory<_i947.ThemeCubit>(() => _i947.ThemeCubit());
    gh.singleton<_i1069.AppRouter>(() => _i1069.AppRouter());
    gh.lazySingleton<_i601.DioService>(() => _i601.DioService());
    gh.lazySingleton<_i513.ConnectivityInterceptor>(
      () => _i513.ConnectivityInterceptor(),
    );
    gh.lazySingleton<_i618.ErrorInterceptor>(() => _i618.ErrorInterceptor());
    gh.lazySingleton<_i991.MyHttpOverrides>(() => _i991.MyHttpOverrides());
    gh.lazySingleton<_i204.AppSettingLocalDataSource>(
      () => _i204.AppSettingLocalDataSource(),
    );
    gh.lazySingleton<_i696.DateTimeHelper>(() => _i696.DateTimeHelper());
    gh.lazySingleton<_i765.IPermissionRepository>(
      () => _i454.PermissionRepositoryImpl(),
    );
    gh.lazySingleton<_i392.ILoggerService>(() => _i392.AppLogger());
    gh.lazySingleton<_i374.PermissionCacheService>(
      () => _i374.PermissionCacheService(
        repository: gh<_i765.IPermissionRepository>(),
      ),
    );
    gh.factory<_i448.PermissionBloc>(
      () => _i448.PermissionBloc(repository: gh<_i765.IPermissionRepository>()),
    );
    gh.factory<_i702.NavigationService>(
      () => _i702.NavigationService(gh<_i1069.AppRouter>()),
    );
    gh.lazySingleton<_i669.IAppSettingRepository>(
      () => _i857.AppSettingRepositoryImpl(
        localDataSource: gh<_i204.AppSettingLocalDataSource>(),
      ),
    );
    gh.factory<_i364.TestCubit>(
      () => _i364.TestCubit(gh<_i765.IPermissionRepository>()),
    );
    gh.lazySingleton<_i659.AuthenticationInterceptor>(
      () => _i659.AuthenticationInterceptor(
        appSettingRepo: gh<_i669.IAppSettingRepository>(),
      ),
    );
    gh.factory<_i611.AppSettingBloc>(
      () => _i611.AppSettingBloc(repository: gh<_i669.IAppSettingRepository>()),
    );
    gh.lazySingleton<_i974.AppSettingCache>(
      () =>
          _i974.AppSettingCache(repository: gh<_i669.IAppSettingRepository>()),
    );
    return this;
  }
}
