# Logger Service

A structured logging service that writes to both the console and local log files, with optional periodic upload to a remote server.

## Files

| File | Purpose |
|------|---------|
| `logger_service.dart` | Abstract interface + `AppLogger` implementation |
| `../files/file_log_output_service.dart` | Custom `LogOutput` that writes to a daily rotating log file |

## Dependencies

```yaml
dependencies:
  logger: ^2.6.2
  path_provider: ^2.x.x
  dio: ^5.x.x          # Only needed if using log upload feature
  easy_localization: ^3.x.x
  get_it: ^9.x.x
  injectable: ^2.x.x
```

## How It Works

- **Debug logs** (`d()`) use `dart:developer` — appear in DevTools but are **not** written to file.
- **Info logs** (`i()`) and **Error logs** (`e()`) use the `logger` package and are written to both the console (via `ConsoleOutput`) and a daily-rotating local file (via `FileLogOutput`).
- Log files are stored at `<app_documents>/app_logs/app_log_<yyyy-MM-dd>.txt`.
- `startPeriodicUpload()` runs every 15 minutes, uploading any log files from **previous days** to a remote endpoint and deleting them after a successful upload. Today's log is left on device until tomorrow.

## Setup

### 1. Register via Injectable

`AppLogger` is decorated with `@LazySingleton(as: ILoggerService)`. Run the build runner once to generate the DI config:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 2. Start periodic upload in `App.build()`

```dart
// lib/core/app.dart
sl<ILoggerService>().startPeriodicUpload();
```

### 3. Point the upload URL to your server

In `logger_service.dart`, find `_uploadSingleFile` and replace the placeholder:

```dart
// Before
url: 'https://your-server.com/api/logs/upload',
'device_id': 'unique_device_id_here',

// After
url: ApiPaths.uploadLogs,   // your actual endpoint
'device_id': deviceId,      // real device identifier
```

## Usage

### Via static helpers (preferred — no context needed)

```dart
AppLogger.debug('Fetching user profile');
AppLogger.info('User logged in', name: 'AuthService');
AppLogger.error('Token refresh failed', error: e, stackTrace: s, name: 'AuthService');
```

### Via injected interface

```dart
class MyRepository {
  MyRepository(this._logger);
  final ILoggerService _logger;

  void doSomething() {
    _logger.i('Doing something');
  }
}
```

### Force-upload logs immediately (e.g., on logout)

```dart
await sl<ILoggerService>().uploadLogs(force: true);
```

## Copying to a New Project

1. Copy `logger_service.dart` and `file_log_output_service.dart`.
2. Add the dependencies listed above to `pubspec.yaml`.
3. Run `build_runner` to register the singleton.
4. Call `sl<ILoggerService>().startPeriodicUpload()` in `App.build()`.
5. Replace the upload URL and device ID with real values.
