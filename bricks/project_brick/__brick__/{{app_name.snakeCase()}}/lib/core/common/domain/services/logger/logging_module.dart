import 'package:injectable/injectable.dart';

import 'logger_service.dart';

/// Exposes the active [AppLogger] service to DI so classes that need a logger
/// as a real dependency can take an [ILoggerService] in their constructor.
@module
abstract class LoggingModule {
  @lazySingleton
  ILoggerService get logger => AppLogger.service;
}
