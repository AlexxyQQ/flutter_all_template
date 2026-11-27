# Notification module

Push notifications (Firebase Cloud Messaging) rendered as local notifications
(`awesome_notifications`).

## Files (`lib/core/services/notification/`)

| File | Responsibility |
|---|---|
| `data/notification_service.dart` | `@lazySingleton` start-up + on/off switch: `initialize()`, `toggleNotifications()`, `showNotification()`, `cancelNotification()`. Wires the collaborators below. |
| `data/helpers/notification_display_helper.dart` | Plugin init + rendering of local notifications. Also used (built by hand) by the FCM background isolate. |
| `data/notification_tap_router.dart` | Tap -> navigation through the allowlist; stores the cold-start tap and implements `INotificationLaunch`. |
| `data/push_token_sync.dart` | Registers / unregisters the FCM token with the backend, tied to the session (and the logout hook). |
| `data/notification_permission_service.dart` | `INotificationPermissionApi` implementation (OS permission). |
| `data/notification_preferences.dart` | The user's global on/off flag (`IPreferencesStore`). |
| `data/notification_route_allowlist.dart` | Maps payload `type` / `route` keys to known app paths (security allowlist). |
| `data/push/push_messaging_client.dart` | `IPushMessagingClient` seam over `FirebaseMessaging` (token, permission, streams, background handler). |
| `data/push_token_repository_impl.dart` + `domain/push_token_repository.dart` | `POST` / `DELETE` `ApiPaths.pushToken` through `IApiClient`. |
| `data/helpers/fcm_background_handler.dart` | `FcmBackgroundHandler.handle`: the static background/terminated-state entry point. |
| `data/helpers/notification_channels.dart` | Android channel definitions (`NotificationChannelConfig`). |
| `data/notification_module.dart` | Injectable `@module`: `AwesomeNotifications` and the `INotificationLaunch` alias. |
| `domain/notification_permission_api.dart` | Interface other modules (the permission feature) use for the notification permission. |
| `domain/notification_launch.dart` | `INotificationLaunch.openPendingLaunchDestination()`: cold-start hand-off (see below). |

## Lifecycle

1. Bootstrap: `Firebase.initializeApp(...)`, DI, then **once**
   `await sl<NotificationService>().initialize();`
2. `initialize()` registers the channels, starts the tap listener (and stores
   the notification that launched the app, if any), registers the FCM
   background handler, subscribes to foreground messages and starts
   `PushTokenSync`.
3. `PushTokenSync` subscribes to `ISessionManager.statusStream`. The stream
   replays the current status, so an already signed-in start registers the
   token without a separate call. Every trigger (session change, permission
   granted, toggled on) goes through `sync()`, which shares one in-flight
   request: the token is POSTed once, not once per trigger. It is also
   re-registered on FCM token refresh.
4. Logout hook: `unregisterAndDelete()` unregisters the token
   (`DELETE devices/push-token`) and deletes it locally so the next user never
   receives the previous user's pushes.

The token itself is never logged. The platform sent with the token is
lowercase (`android`, `ios`).

## Permission

`NotificationPermissionService.requestPermission()` asks for both the local
display permission (awesome_notifications) and the FCM authorization
(`FirebaseMessaging.requestPermission`, which is the iOS push prompt). It
returns `true` only when **both** are granted, and registers the token after a
grant.

## Cold-start tap (`INotificationLaunch`)

When the app is launched by tapping a notification there is no router yet, so
`initialize()` only **stores** the allowlisted destination. The splash screen
(`SplashScreen._navigate`, after it replaces itself with the first screen)
calls `INotificationLaunch.openPendingLaunchDestination()`, which opens that
destination once and clears it. A live tap that arrives first supersedes the
stored one. If you replace the splash, call it from whatever screen first has a
mounted router.

## Payload contract & navigation (security)

A push payload is untrusted. Tapping a notification only navigates when the
payload contains `type` (preferred) or `route` whose **value is a key** in
`NotificationRouteAllowlist.defaultRoutes`; the destination path always comes
from that table. Unknown values are ignored and logged (without the value).
Add your notification types there:

```dart
static const Map<String, String> defaultRoutes = {
  'home': AppPaths.home,
  'order_shipped': AppPaths.orders, // example
};
```

## Global toggle

`toggleNotifications(isEnabled: false)` stores the flag in `IPreferencesStore`
(`NotificationPreferences.enabledKey`), unregisters and deletes the FCM token
(FCM stops delivering) and cancels all displayed notifications.
`isEnabled: true` re-registers the token. The background isolate reads the
same flag directly from `SharedPreferences`.

## Channels

`NotificationChannelConfig` defines one high-importance channel. Its name and
description are plain constants: channels are created before localization is
loaded (bootstrap, background isolate), so rename them in code for your
product.

## Background isolate

`FcmBackgroundHandler.handle` runs without the GetIt container: it initialises
Firebase with `DefaultFirebaseOptions.currentPlatform`, reads the toggle from
`SharedPreferences`, and renders **data-only** messages (messages with a
`notification` block are already shown by the OS). Errors go through the
static `AppLogger`, which works in any isolate.

See `NOTIFICATION_SETUP.md` for platform setup.
