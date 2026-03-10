# Architecture & Operational Overview

**Filename:** `NOTIFICATION_OVERVIEW.md`

This document explains the internal architecture, logic flows, and features of the `NotificationService`.

---

# Notification Service Overview

## 1. Introduction

The `NotificationService` is a robust wrapper around `firebase_messaging` (remote) and `awesome_notifications` (local display). It creates a unified interface for handling push notifications, specifically designed to handle complex scenarios like chat thread suppression, global toggles, and deep linking.

## 2. Architecture: Separation of Concerns

The service is split into four distinct components to maintain clean code and testability:

| Component   | Class                         | Responsibility                                                                                                                                    |
| ----------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Facade**  | `NotificationService`         | The public entry point. Manages initialization, streams, and delegates tasks.                                                                     |
| **Logic**   | `NotificationLogicHelper`     | Handles business rules: Should a notification show? Is the user in the specific chat thread? Is the global toggle on? **(Needs API integration)** |
| **Display** | `NotificationDisplayHelper`   | Handles UI rendering: Creating the Awesome Notification object, parsing images, showing progress bars, and handling specific platform UI quirks.  |
| **Handler** | `fcm_background_handler.dart` | A standalone isolate entry point that handles messages when the app is **Terminated** or in the **Background**.                                   |

## 3. Key Features & Logic Flows

### A. Global Notification Toggle

- **Function:** Users can completely disable notifications.
- **Mechanism:**
- When `toggleNotifications(false)` is called, the system sets a `SharedPreference` flag.
- **Crucially**, it also calls `deleteToken()` on Firebase. This stops the server from sending messages entirely, saving bandwidth and server resources.
- It cancels all currently active notifications in the system tray.

### B. Intelligent "Context" Suppression

- **Use Case:** If a user is currently looking at Chat Thread A, they should not receive a push notification for a new message in Chat Thread A.
- **How it works:**

1. When entering a screen, call `suppressNotificationsForContext('th_123')`.
2. This saves the ID to `SharedPreferences`.
3. When a message arrives, `NotificationLogicHelper` compares the incoming `thread_id` with the saved ID.
4. If they match, the notification is silently dropped.

### C. Background Isolation Handling

Flutter apps run background tasks in a separate memory isolate.

- **The Problem:** The background isolate cannot access the main app's variables or singleton instances.
- **The Solution:** The `firebaseMessagingBackgroundHandler`:

1. Re-initializes `SharedPreferences` independently.
2. Checks the "Global Toggle" preference directly from disk.
3. Initializes a temporary instance of `NotificationService` to render the display.

### D. Deep Linking (Navigation)

- **Trigger:** User taps a notification.
- **Flow:**

1. `_onActionReceived` captures the event.
2. `NotificationLogicHelper` parses the `payload` (handling JSON strings if necessary).
3. It extracts `redirect_url`.
4. It utilizes the `NavigationService` (via `GetIt`) to push the named route.

## 4. Notification Channels

The service is pre-configured with two specific Android channels (defined in `NotificationChannels`):

1. **High Importance (`high_importance`):**

- Max priority, plays sound, LED lights, pops up on screen.
- Used for standard messages.

2. **Progress (`progress_channel`):**

- Low priority, no sound.
- Used for the `showProgressNotification` method (e.g., file uploads/downloads) to prevent constant "dinging" sound updates.

## 5. Data Flow Diagram (Conceptual)

```text
[FCM Cloud]
     |
     v
[Device Receives Message]
     |
     +--- Is App Foreground?
     |      |
     |      +-- YES: Fire `onMessage` stream
     |      |      -> Check `LogicHelper.shouldSuppress()`
     |      |      -> IF allowed: `DisplayHelper.showNotification()`
     |      |
     |      +-- NO (Background/Terminated):
     |             -> Spawns Background Isolate
     |             -> `firebaseMessagingBackgroundHandler`
     |             -> Check SharedPrefs (Toggle)
     |             -> `NotificationService.showNotification()`
     v
[User Taps Notification]
     |
     v
[AwesomeNotifications ActionStream]
     |
     v
[NotificationService] -> Parse Payload -> NavigationService -> Push Route

```

## 6. Next Steps for Developers

- **Testing:** Use the "Test Notification" feature in the Firebase Console. Ensure you test whilst the app is Killed, Backgrounded, and in the Foreground.
- **Customization:** Edit `NotificationDisplayHelper` to change the default icons or colors.
- **API Integration:** **Urgent:** You must implement the token registration logic in `NotificationLogicHelper` (as detailed in the Setup Guide) to actually receive messages from your backend.
