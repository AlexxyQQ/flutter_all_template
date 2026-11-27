import 'package:injectable/injectable.dart';

import 'app_logger.dart';

/// The [ILoggerService] registered in DI. It forwards every call to the
/// current `AppLogger.service`, so the injected logger and the static
/// `AppLogger` are always the same logger, even after `AppLogger.configure`.
@LazySingleton(as: ILoggerService)
class AppLoggerDelegate implements ILoggerService {
  const AppLoggerDelegate();

  @override
  void debug(String message, {String? name}) =>
      AppLogger.debug(message, name: name);

  @override
  void info(String message, {String? name}) =>
      AppLogger.info(message, name: name);

  @override
  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? name,
  }) => AppLogger.warning(
    message,
    error: error,
    stackTrace: stackTrace,
    name: name,
  );

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? name,
  }) => AppLogger.error(
    message,
    error: error,
    stackTrace: stackTrace,
    name: name,
  );
}
