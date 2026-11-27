/// Logging contract. Inject it where a logger is a real dependency; use the
/// static [AppLogger] facade for incidental logging.
abstract interface class ILoggerService {
  void debug(String message, {String? name});
  void info(String message, {String? name});
  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? name,
  });
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? name,
  });
}
