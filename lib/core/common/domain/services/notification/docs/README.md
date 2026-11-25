# Notification module

Push notifications (Firebase Cloud Messaging) rendered as local notifications
(`awesome_notifications`).

## Files

| File | Responsibility |
|---|---|
| `notification_service.dart` | `@lazySingleton` facade: init, permission, toggle, display, thread suppression, tap navigation, push-token lifecycle. Implements `NotificationPermissionApi`. |
| `notification_permission_api.dart` | Interface used by other modules (the permission feature) to check/request the notification permission. |
| `notification_module.dart` | Injectable `@module`: `AwesomeNotifications` and the `NotificationPermissionApi` alias. |
| `push/push_messaging_client.dart` | `PushMessagingClient` seam over `FirebaseMessaging` (token, permission, streams, background handler). |
| `domain/push_token_repository.dart` / `data/push_token_repository_impl.dart` | Registers / unregisters the device token with the backend through `ApiClient`. |
| `notification_api_paths.dart` | Backend endpoint(s) (`NotificationApiPaths.pushToken`). |
| `notification_route_allowlist.dart` | Maps payload `type` / `route` keys to known app paths (security allowlist). |
| `helpers/notification_display_helper.dart` | Renders notifications; no DI so the background isolate can use it. |
| `helpers/fcm_background_handler.dart` | Top-level `@pragma('vm:entry-point')` background handler. |
| `helpers/notification_channels.dart` | Android channel definitions. |
| `helpers/notification_prefs.dart` | Preference keys shared with the background isolate. |
| `helpers/notification_thread.dart` | `normalizeThreadId` (`th_` prefix handling). |

## Lifecycle

1. Bootstrap: `Firebase.initializeApp(...)`, DI, then **once**
   `await sl<NotificationService>().initialize();`
2. `initialize()` configures channels and listeners, registers the FCM
   background handler, subscribes to foreground messages / token refreshes /
   session status, and registers a `SessionManager` logout hook.
3. While the session is `authenticated` and notifications are enabled, the
   FCM token is registered with the backend (`POST /devices/push-token`),
   also after token refreshes and after the permission is granted.
4. Logout hook: unregisters the token (`DELETE /devices/push-token`) and
   deletes it locally so the next user never receives the previous user's
   pushes.

The token itself is never logged.

## Payload contract & navigation (security)

A push payload is untrusted. Tapping a notification only navigates when the
payload contains `type` (preferred) or `route` whose **value is a key** in
`NotificationRouteAllowlist.defaultRoutes`; the destination path always comes
from that table. Unknown values are ignored and logged (without the value).
Add your notification types there:

```dart
static const Map<String, String> defaultRoutes = {
  'home': AppPaths.splashRoute,
  'order_shipped': '/orders', // example
};
```

## Global toggle

`toggleNotifications(isEnabled: false)` stores the flag in `PreferencesStore`,
unregisters and deletes the FCM token (FCM stops delivering) and cancels all
displayed notifications. `isEnabled: true` re-registers the token. The
background isolate reads the same flag directly from `SharedPreferences`
(`NotificationPrefs.enabledKey`).

## Thread suppression

When the user is looking at a conversation, call
`suppressNotificationsForThread(threadId)`; foreground pushes whose
`thread_id` matches (ignoring an optional `th_` prefix) are not shown.
Call `clearThreadSuppression()` when leaving the screen.

## Background isolate

`firebaseMessagingBackgroundHandler` runs without the GetIt container: it
initialises Firebase with `DefaultFirebaseOptions.currentPlatform`, reads the
toggle from `SharedPreferences`, and renders **data-only** messages (messages
with a `notification` block are already shown by the OS).

See `NOTIFICATION_SETUP.md` for platform setup.
