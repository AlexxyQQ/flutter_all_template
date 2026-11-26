# Logger

A small logging facade with pluggable sinks and built-in redaction.

| File | Purpose |
|------|---------|
| `logger_service.dart` | `ILoggerService` (d/i/w/e), `LoggerService` (redacts + fans out to sinks), static `AppLogger` facade |
| `log_sinks.dart` | `LogEntry`, `LogSink`, `ConsoleLogSink`, `CrashReporter` + `CrashReporterSink` |
| `log_redactor.dart` | `LogRedactor.redact()` (Bearer/Basic, JWTs, `password=`, `token=`, JSON secret fields) and `redactHeaders()` |
| `logging_module.dart` | Registers the active logger in DI as `ILoggerService` |

## Behaviour

- **Debug builds**: every level goes to the console (`logger` package pretty printer).
- **Release/profile builds**: only **warnings and errors** are kept, and they go to a
  `CrashReporter` (no-op by default). Nothing is written to disk and nothing is uploaded.
- Every message passes through `LogRedactor` before reaching any sink. This is a safety
  net: never log tokens, passwords, storage values, route arguments or push tokens.

## Usage

```dart
AppLogger.debug('Loaded ${items.length} items', name: 'TodoRepository');
AppLogger.warning('Retrying sync', name: 'Sync');
AppLogger.error('Sync failed', error: e, stackTrace: s, name: 'Sync');
```

Classes that need a logger as a real dependency take `ILoggerService` in their constructor.

## Wiring Crashlytics / Sentry

Implement `CrashReporter` and install it through `Bootstrap.run`'s `initializers` callback:

```dart
AppLogger.configure(
  LoggerService.platformDefault(crashReporter: CrashlyticsReporter()),
);
```

See the doc comment on `CrashReporter` in `log_sinks.dart` for a Crashlytics and Sentry example.
`bootstrap.dart` already routes `FlutterError.onError`, `PlatformDispatcher.onError`, zone
errors, `BlocObserver.onError` and `guard()`'s unexpected errors through `AppLogger.error`.

## Remote log upload

Removed from the default path. If you need it, build an opt-in uploader that runs only when
`AppEnv.enableLogUpload && AppEnv.logUploadUrl.isNotEmpty`, uses its **own** `Dio` (never the API
client — it must not carry the bearer token), uploads only redacted warning/error events, and is
started from bootstrap (never from a widget `build`).
