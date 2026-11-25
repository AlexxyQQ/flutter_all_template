/// Relative API paths (joined to the configured base URL by `ApiClient`).
///
/// One constant per resource collection; build item paths in the data source
/// (`'${ApiPaths.todos}/$id'`). The feature brick appends new entries here.
abstract final class ApiPaths {
  static const String todos = '/todos';
}
