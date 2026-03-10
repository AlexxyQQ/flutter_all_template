import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../config/constants/locales/app_locales.dart';
import '../../../../../../config/constants/type_defs/typedef.dart';
import '../../../../data/models/helpers/model_conversion_helper.dart';
import '../../../../domain/entities/failure.dart';
import '../../../../locator/service_locator.dart';
import '../../domain/repositories/app_setting_repository.dart';
import '../../domain/services/cache/app_setting_cache.dart';
import '../data_sources/local/app_setting_local_data_source.dart';
import '../models/app_setting.dart';

@LazySingleton(as: IAppSettingRepository)
class AppSettingRepositoryImpl implements IAppSettingRepository {
  AppSettingRepositoryImpl({required AppSettingLocalDataSource localDataSource})
    : _localDataSource = localDataSource;
  final AppSettingLocalDataSource _localDataSource;

  @override
  ResultFuture<AppSetting> getSetting() async {
    final data = await _localDataSource.get();
    return data.fold((l) => Left(l), (r) {
      sl<AppSettingCache>().set(r);
      return Right(r);
    });
  }

  @override
  ResultFuture<AppSetting> updateSetting({
    required Function(AppSetting currentData) data,
  }) async {
    final AppSetting currentSetting =
        await _localDataSource.get().rightOrNull ?? const AppSetting();

    final newModel = data(currentSetting);

    final update = await _localDataSource.replaceAll(values: [newModel]);

    sl<AppSettingCache>().set(newModel);

    return update.fold((l) => Left(l), (r) {
      if (r.firstOrNull == null) {
        return const Left(
          Failure(message: LocaleKeys.common_errors_noDataFound),
        );
      } else {
        return Right(r.first);
      }
    });
  }

  @override
  ResultFuture<void> logout() async {
    late AppSetting newModel;
    final AppSetting? current = await _localDataSource.get().rightOrNull;
    if (current == null) {
      newModel = const AppSetting();
    } else {
      newModel = current.copyWith(
        hasOnboarded: current.hasOnboarded,
        locale: AppLocales.en,
        loggedUser: null,
        notification: true,
        rememberUser: true,
        token: null,
        theme: ThemeMode.system,
        refreshToken: null,
      );
    }

    final update = await _localDataSource.replaceAll(values: [newModel]);
    sl<AppSettingCache>().set(newModel);
    return update.fold((l) => Left(l), (r) {
      if (r.firstOrNull == null) {
        return const Left(
          Failure(message: LocaleKeys.common_errors_noDataFound),
        );
      } else {
        return const Right(null);
      }
    });
  }
}
