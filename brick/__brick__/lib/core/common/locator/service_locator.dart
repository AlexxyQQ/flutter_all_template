import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../domain/services/storage/secure_storage_service.dart';
import '../presentation/helpers/file_picker_helper.dart';
import 'service_locator.config.dart';

final GetIt sl = GetIt.instance;

@InjectableInit(initializerName: 'initGetIt')
Future<void> configureInjection() async {
  // This is a specific registration for Secure Storage Service
  sl
    ..registerLazySingleton<SecureStorageService>(() => SecureStorageService())
    ..registerLazySingleton<IFileSelectorHelper>(
      () => FileSelectorHelperImpl(),
    );
  await sl.initGetIt();
}
