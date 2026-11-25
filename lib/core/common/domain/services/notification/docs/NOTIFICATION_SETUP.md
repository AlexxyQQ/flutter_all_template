# Notification Service Setup Guide

## 1. Dependencies

Ensure the following packages are added to your `pubspec.yaml`:

```yaml
dependencies:
  firebase_messaging: ^14.7.9
  awesome_notifications: ^0.9.3+1
  shared_preferences: ^2.2.2
  get_it: ^7.6.0 # For service_locator
```

---

## 2. Firebase Configuration (FlutterFire CLI)

You must configure your app with Firebase using the FlutterFire CLI. This generates the `firebase_options.dart` file needed for initialization.

**Prerequisites:**

- Node.js installed.
- Firebase CLI installed (`sudo npm install -g firebase-tools`).

**Steps:**

1. **Log in to Firebase:**

```bash
firebase login

```

2. **Activate FlutterFire CLI:**

```bash
dart pub global activate flutterfire_cli

```

3. **Configure the App:**
   Run this command in your project root. Follow the prompts to select your project and platforms (Android/iOS).

```bash
# Production
flutterfire configure \
  --project=flutter-all-template \
  --out=lib/config/firebase/firebase_options.dart \
  --ios-bundle-id=com.alexxy.flutterAllTemplate \
  --ios-out=ios/Runner/GoogleService-Info.plist \
  --android-package-name=com.alexxy.flutter_all_template \
  --android-out=android/app/google-services.json \
  --yes
```

---

## 3. Platform Configuration

### Android (`android/app/src/main/AndroidManifest.xml`)

Add the necessary permissions and the Awesome Notifications receiver inside the `<application>` tag.

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.your.package">

    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.VIBRATE"/>
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <uses-permission android:name="android.permission.ACCESS_NOTIFICATION_POLICY"/>

    <application>
        <receiver android:name="me.carda.awesome_notifications.DartNotificationActionReceiver"
            android:exported="true" />

        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="high_importance" />
    </application>
</manifest>

```

### iOS (`ios/Runner/Info.plist` & Capabilities)

1. **Info.plist:** Add permission descriptions.

```xml
<key>UIBackgroundModes</key>
<array>
   <string>fetch</string>
   <string>remote-notification</string>
</array>
<key>NSLocalNetworkUsageDescription</key>
<string>Used for local notifications</string>

```

2. **XCode:**

- Open `Runner.xcworkspace`.
- Go to **Signing & Capabilities**.
- Add **Push Notifications**.
- Add **Background Modes** -> Check **Background fetch** and **Remote notifications**.
- _Note:_ `AwesomeNotifications` usually requires a Service Extension for advanced image layouts on iOS.

## 4. Service Locator Registration

Everything is registered by `injectable` (`@lazySingleton` / `@module`). The
service needs implementations of `ApiClient`, `PreferencesStore` and
`SessionManager` (provided by core infrastructure). Regenerate after changes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 5. FCM Token Registration

Already wired: `PushTokenRepository` posts the token to
`NotificationApiPaths.pushToken` while the session is authenticated, after
token refreshes and after the notification permission is granted, and a
logout hook unregisters + deletes it. Adapt the endpoint/body in
`notification_api_paths.dart` and `data/push_token_repository_impl.dart` to
your backend.

## 6. Initialization

Bootstrap initializes the service **once**, after Firebase and DI, before
`runApp`:

```dart
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
await configureInjection();
await sl<NotificationService>().initialize();
```

## 7. Handling Background Messages

`firebaseMessagingBackgroundHandler` is a top-level function with
`@pragma('vm:entry-point')`. It runs in its own isolate (no DI): it initializes
Firebase itself and builds what it needs directly. Do not move it into a class.
