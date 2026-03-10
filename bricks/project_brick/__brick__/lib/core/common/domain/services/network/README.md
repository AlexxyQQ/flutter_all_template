# Network Service (DioService + ApiHandler)

A pre-configured HTTP client built on [Dio](https://pub.dev/packages/dio) with a static `ApiHandler` utility that wraps every request in a functional `Either<Failure, T>` result.

## Files

| File | Purpose |
|------|---------|
| `dio_service.dart` | `DioService` singleton + `ApiHandler` static utility |
| `interceptor/authentication_interceptor.dart` | Adds auth headers to every request |
| `interceptor/connectivity_interceptor.dart` | Rejects requests when offline |
| `interceptor/error_interceptor.dart` | Normalises server error responses |
| `interceptor/token_interceptor.dart` | Handles token refresh (disabled by default) |
| `interceptor/http_override.dart` | Dev-only HTTP override helpers |

## Dependencies

```yaml
dependencies:
  dio: ^5.9.0
  connectivity_plus: ^7.0.0
  fpdart: ^1.2.0
  injectable: ^2.x.x
  get_it: ^9.x.x
```

## Configuration

Open `lib/config/constants/api/api_constants.dart` and set your values:

```dart
class ApiConstants {
  static const String baseAPIURL = 'https://api.your-app.com';
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Map<String, dynamic> defaultHeader = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
```

### Proxy / Bad-certificate bypass (dev only)

Pass environment variables at build time:

```bash
# Android emulator via Charles / mitmproxy
flutter run --dart-define=PROXY=192.168.1.5:8888

# Trust self-signed certs (never in production)
flutter run --dart-define=ALLOW_HTTP=true
```

## `ApiHandler` Usage

`ApiHandler` exposes four static methods: `get`, `post`, `put`, `delete`. Each returns `Future<Either<Failure, T>>`.

### GET

```dart
final result = await ApiHandler.get<User>(
  url: '/users/1',
  onSuccess: (json) async => User.fromJson(json),
);

result.fold(
  (failure) => print(failure.message),
  (user)    => print(user.name),
);
```

### POST

```dart
final result = await ApiHandler.post<User>(
  url: '/users',
  data: {'name': 'Alice', 'email': 'alice@example.com'},
  successCode: 201,               // POST typically returns 201
  onSuccess: (json) async => User.fromJson(json),
  onError:   (json) async => Failure(message: json['error'] ?? 'Failed'),
);
```

### PUT / DELETE

```dart
// PUT
await ApiHandler.put<User>(url: '/users/1', data: {'name': 'Bob'}, onSuccess: ...);

// DELETE
await ApiHandler.delete<void>(url: '/users/1', onSuccess: (_) async {});
```

### Using a custom Dio client

```dart
final result = await ApiHandler.get<String>(
  url: 'https://other-server.com/data',
  client: Dio(),   // bypass the global DioService
  onSuccess: (json) async => json['value'] as String,
);
```

## Interceptors

### `AuthenticationInterceptor`

Add your token-injection logic here. By default, look up the token from `SecureStorageService`:

```dart
// interceptor/authentication_interceptor.dart
@override
void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
  final token = sl<SecureStorageService>().read(key: 'access_token');
  if (token != null) {
    options.headers['Authorization'] = 'Bearer $token';
  }
  handler.next(options);
}
```

### `TokenInterceptor` (disabled by default)

Uncomment `..interceptors.add(sl<TokenInterceptor>())` in `DioService` to enable automatic token refresh on 401.

## Copying to a New Project

1. Copy the `network/` folder.
2. Add `dio`, `connectivity_plus`, `fpdart`, `injectable` to `pubspec.yaml`.
3. Populate `ApiConstants` with your base URL and headers.
4. Implement `AuthenticationInterceptor.onRequest` to attach your token.
5. Run `build_runner` — `DioService` is registered as `@lazySingleton`.
