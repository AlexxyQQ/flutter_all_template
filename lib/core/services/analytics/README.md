# Analytics

Per-user analytics for actions, screens and errors, with errors correlated to
the action that caused them. Events are queued and retained in an encrypted
local history using `EncryptedHiveStore`. A custom API and Firebase Analytics
can receive the same events. Collection is off by default.

```
bloc / route observer / error handlers
        │ trackAction · trackScreen · trackError
        ▼
AnalyticsSanitizer ──► AnalyticsServiceImpl ──► durable queue (encrypted)
                         stamps identity              │ batches, retries
                                                      ▼
                    LocalAnalyticsDestination · API · Firebase Analytics
```

## Enable it

1. In `env/<flavor>.json`:

   ```json
   "ANALYTICS_ENABLED": true,
   "ANALYTICS_API_URL": "https://analytics.example.com/v1/events",
   "ANALYTICS_FIREBASE_ENABLED": false
   ```

   Set `ANALYTICS_ENABLED: true` alone for local history. On native platforms,
   `LocalAnalyticsDestination.readRecent(identity: ...)` returns that
   identity's recent events for internal diagnostics. The local history keeps
   the latest 500 events across all accounts on the device.
2. **Custom API** (`ANALYTICS_API_URL`): the app `POST`s

   ```json
   {
     "sent_at": "2026-01-01T10:00:00.000Z",
     "events": [
       {
         "id": "uuid", "type": "action|screen|error", "name": "todo_create",
         "occurred_at": "ISO-8601 UTC", "anonymous_id": "uuid",
         "user_id": "opaque id or null", "session_id": "uuid",
         "correlation_id": "uuid or null",
         "parameters": { "title_length": 12 }
       }
     ]
   }
   ```

   Answer any `2xx` to acknowledge the batch. Anything else, or no answer, is
   retried later (up to 10 attempts per event). **De-duplicate on `id`**: a
   batch can arrive twice if the app is killed before it reads the response.
   The request goes through its own Dio with **no auth headers**; if your
   endpoint needs a public ingestion key, add it in `AnalyticsModule`
   (never a secret: everything in `env/` ships inside the app).
3. **Firebase** (projects generated with `use_firebase`): configure FlutterFire
   and set `ANALYTICS_FIREBASE_ENABLED: true`. Native collection starts disabled
   in the Android and iOS configuration. Bootstrap enables the SDK when both
   analytics flags are enabled. Once enabled, the SDK also collects automatic
   events such as `first_open` and `session_start`.

## Identity (sign-in / sign-out)

The template has no login screen, so events are **anonymous** (a random,
per-install `anonymous_id`) until your auth flow identifies the user:

```dart
await sl<ISessionManager>().signIn(tokens: tokens);
await sl<IAnalyticsService>().identify(userId: user.id); // opaque id only
```

- `identify` never throws. An e-mail or phone number is rejected with a logged
  warning and the identity is cleared instead (events must not stay attributed
  to the previous user): pass a database id/UUID.
- Sign-out is wired in `bootstrap.dart` as a `ISessionManager` logout hook:
  `clearIdentity()` drops the user id and rotates the app's anonymous id, so
  later events use a fresh identity on a shared device. It
  also runs at start-up when no session was restored.
- Each queued event keeps the identity it was tracked under: events tracked
  before sign-in stay anonymous even if they are delivered afterwards.
- `session_id` is one random id per launch **and identity**: it is renewed on
  sign-in and sign-out so two users are never linked through a shared session.
- Destinations learn about the user once per identity change (`setUserId`), not
  per event; Firebase skips replayed events queued under another user.

## Tracking

```dart
final correlationId = _analytics.trackAction(
  name: 'todo_create',
  parameters: {'title_length': title.length}, // describe data, never send it
);
final result = await _createTodo(params: params);
result.fold(
  (failure) => _analytics.trackError(
    source: 'todo_create',
    error: failure,
    correlationId: correlationId,
  ),
  (_) {},
);
```

Inject `IAnalyticsService` (blocs get it through their constructor; tests pass
a mock or a no-op fake from your tests). What is already wired:

| Entry point | Events |
|---|---|
| `AppRouteObserver` | `screen_view` with the route **name** only (no path, no arguments); dialogs and sheets are ignored |
| `TodoListBloc` | list loads, pagination, create, toggle, delete, search and refresh, plus correlated `app_error`s |
| `AppErrorReporter` (`app/error`) | `app_error` for Flutter framework errors, platform errors, `guard()`'s unexpected errors and uncaught zone errors (also logged; see the logger README) |
| `AnalyticsLifecycleObserver` | flushes the queue when the app goes to the background |

Pass the `correlationId` returned by `trackAction` to `trackError` to link a
failure to the action that caused it; without it the error stands alone.

## Privacy rules (enforced by `AnalyticsSanitizer`)

- Names become `snake_case`, 40 characters at most; at most 25 parameters per
  event, values up to 100 characters (Firebase limits, applied everywhere).
- Parameters whose key mentions personal or secret data (`email`, `phone`,
  `title`, `query`, `token`, `password`, `message`, `location`, ...) are
  dropped, unless they only describe it with a number/bool (`title_length`,
  `has_email`, `is_note_empty`).
- String values that look like e-mails, phone/card numbers, JWTs, bearer
  tokens, URLs or long keys are dropped.
- Errors are recorded by **kind** only: `Failure` type, status code and
  localization key, or a fixed category (`app_network`, `timeout`, `state`, ...;
  never `runtimeType`, which `--obfuscate` mangles). Never its message or stack.
- Nothing analytics-related is logged except counts and error types. An invalid
  `ANALYTICS_API_URL` is reported with a warning (the value is not echoed) and
  the custom API destination is disabled.

## Tuning

`AnalyticsConfig` (built in `AnalyticsModule`): batch size 20, flush every 30
seconds, at most 500 queued events (oldest dropped first), 10 attempts per
event.

## Adding a destination

Implement `IAnalyticsDestination` (unique, never-changing `id`; throw from
`send` when the batch was not accepted) and add it to
`AnalyticsModule.analyticsDestinations`. Events are tracked per destination,
so a failing destination never causes duplicates in the others.
