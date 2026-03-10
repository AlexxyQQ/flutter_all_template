# Secure Storage Service

A thin wrapper around [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage) that provides encrypted key-value persistence and integrates with the project's `AppLogger` for consistent debug output.

## Files

| File | Purpose |
|------|---------|
| `secure_storage_service.dart` | Main service class (read / write / delete / clear) |

## Dependencies

```yaml
dependencies:
  flutter_secure_storage: ^10.0.0
```

## Android Configuration

The service uses `EncryptedSharedPreferences` on Android automatically via:

```dart
AndroidOptions(encryptedSharedPreferences: true)
```

No additional `AndroidManifest.xml` changes are required.

## iOS Configuration

No additional `Info.plist` keys are required for basic secure storage. Data is stored in the iOS Keychain.

## Setup

`SecureStorageService` is **not** annotated with `@injectable` — it is registered manually in `service_locator.dart` so the constructor options are explicit:

```dart
// lib/core/common/locator/service_locator.dart
sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
```

## Usage

```dart
final storage = sl<SecureStorageService>();

// Write
await storage.write(key: 'access_token', value: token);

// Read
final token = await storage.read(key: 'access_token');

// Delete a single key
await storage.delete(key: 'access_token');

// Wipe everything (e.g., on logout)
await storage.clear();
```

### Recommended key constants

Define keys in a dedicated constants file to avoid typos:

```dart
class StorageKeys {
  static const String accessToken  = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId       = 'user_id';
}
```

## Error Handling

All methods catch `Exception` and re-throw with the original stack trace so the caller's error boundary can handle it. `AppLogger.error` is called before re-throwing, so errors always appear in the log.

## Copying to a New Project

1. Copy `secure_storage_service.dart`.
2. Add `flutter_secure_storage` to `pubspec.yaml`.
3. Register it in your `service_locator.dart`:
   ```dart
   sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
   ```
4. Inject or resolve it from `GetIt` wherever you need secure key-value access.
