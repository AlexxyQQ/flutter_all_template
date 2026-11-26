import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../presentation/helpers/file_picker_helper.dart';
import 'service_locator.config.dart';

/// The service locator. Only the composition root (`bootstrap.dart`,
/// `main.dart`) and widget-tree roots (`BlocProvider(create: …)`, route/page
/// roots) may resolve from it; everything else uses constructor injection.
final GetIt sl = GetIt.instance;

/// Registers every `@injectable` class and `@module` (network, storage,
/// logging) generated into `service_locator.config.dart`.
@InjectableInit(initializerName: 'initGetIt')
Future<void> configureInjection() async {
  sl.registerLazySingleton<IFileSelectorHelper>(FileSelectorHelperImpl.new);
  await sl.initGetIt();
}
