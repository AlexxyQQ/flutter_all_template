import 'package:dio/dio.dart';

import '../../services/logger/data/app_logger.dart';
import '../../services/logger/data/log_redactor.dart';

/// Debug-only HTTP logging. Added to Dio only when `kDebugMode` is true.
///
/// * Logs method, redacted URL, status and duration.
/// * Headers are logged only when [logHeaders] is true, and always with
///   `Authorization`, `Cookie`, `Set-Cookie` (etc.) masked.
/// * Bodies are never logged unless [logBodies] is explicitly enabled, and are
///   then passed through [LogRedactor].
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({this.logHeaders = false, this.logBodies = false});

  final bool logHeaders;
  final bool logBodies;

  static const String _startKey = 'logStartedAt';
  static const String _name = 'HTTP';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startKey] = DateTime.now().millisecondsSinceEpoch;
    final buffer = StringBuffer('→ ${options.method} ${_url(options.uri)}');
    if (logHeaders) {
      buffer.write(
        '\n  headers: ${LogRedactor.redactHeaders(options.headers)}',
      );
    }
    if (logBodies && options.data != null) {
      buffer.write('\n  body: ${LogRedactor.redact(options.data.toString())}');
    }
    AppLogger.debug(buffer.toString(), name: _name);
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final options = response.requestOptions;
    final buffer = StringBuffer(
      '← ${response.statusCode} ${options.method} ${_url(options.uri)} '
      '(${_elapsed(options)} ms)',
    );
    if (logHeaders) {
      buffer.write(
        '\n  headers: ${LogRedactor.redactHeaders(response.headers.map)}',
      );
    }
    if (logBodies && response.data != null) {
      buffer.write('\n  body: ${LogRedactor.redact(response.data.toString())}');
    }
    AppLogger.debug(buffer.toString(), name: _name);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    AppLogger.debug(
      '✗ ${err.response?.statusCode ?? err.type.name} ${options.method} '
      '${_url(options.uri)} (${_elapsed(options)} ms)',
      name: _name,
    );
    handler.next(err);
  }

  static String _url(Uri uri) => LogRedactor.redact(uri.toString());

  static int _elapsed(RequestOptions options) {
    final start = options.extra[_startKey];
    return start is int ? DateTime.now().millisecondsSinceEpoch - start : -1;
  }
}
