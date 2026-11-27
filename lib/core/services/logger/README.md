# Logger

A small logging facade with pluggable sinks and built-in redaction.

| File | Purpose |
|------|---------|
| `domain/logger_service.dart` | `ILoggerService` (`debug`/`info`/`warning`/`error`), pure Dart |
| `data/logger_service.dart` | `LoggerService`: redacts every message and fans it out to sinks |
| `data/app_logger.dart` | static `AppLogger` facade (also re-exports `ILoggerService`) |
| `data/log_sinks.dart` | `LogEntry`, `ILogSink`, `ConsoleLogSink`, `ICrashReporter` + `CrashReporterSink` |
| `data/log_redactor.dart` | `LogRedactor.redact()` (Bearer/Basic, JWTs, `password=`, `token=`, JSON secret fields) and `redactHeaders()` |
| `data/app_logger_delegate.dart` | The DI `ILoggerService`: forwards to `AppLogger`, so the injected and static logger are always the same, even after `AppLogger.configure` |

## Behaviour

- **Debug builds**: every level goes to the console (`logger` package pretty printer).
- **Release/profile builds**: only **warnings and errors** are kept, and they go to a
  `ICrashReporter` (no-op by default). Nothing is written to disk and nothing is uploaded.
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

Implement `ICrashReporter` and install it through `Bootstrap.run`'s `initializers` callback:

```dart
AppLogger.configure(
  LoggerService.platformDefault(crashReporter: CrashlyticsReporter()),
);
```

See the doc comment on `ICrashReporter` in `data/log_sinks.dart` for a Crashlytics and Sentry example.
`AppErrorReporter` (`lib/app/error/`), installed once by `Bootstrap.run`, is the only place
that assigns `FlutterError.onError`, `PlatformDispatcher.onError` and the `guard()` hook (and
handles zone errors). Each error goes through `AppLogger.error` (redacted; the crash reporter
sink receives the redacted description plus the original stack trace) and, once DI is up,
`IAnalyticsService.trackError`.

