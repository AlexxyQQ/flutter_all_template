/// Relative API paths (joined to the configured base URL by `IApiClient`).
///
/// Paths never start with a slash (`'todos'`, `'auth/refresh'`): they are all
/// relative to the base URL, which ends with one (`https://host/v1/`). One
/// constant per resource collection; build item paths in the data source
/// (`'${ApiPaths.todos}/$id'`). The feature brick appends new entries here.
abstract final class ApiPaths {
  static const String todos = 'todos';

  /// `POST` registers a device push token, `DELETE` unregisters it.
  /// Body: `{"token": "...", "platform": "android|ios"}`.
  static const String pushToken = 'devices/push-token';
}
