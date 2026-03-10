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

The service depends on `ILoggerService` and `NavigationService`. Register these in your `service_locator.dart` (or `injection.dart`) before initializing the app.

```dart
// inside your setupLocator function
sl.registerLazySingleton<ILoggerService>(() => LoggerServiceImpl());
sl.registerLazySingleton<NavigationService>(() => NavigationServiceImpl());

```

## 5. FCM Token Registration (Crucial Step)

The service automatically retrieves the FCM token, but it **does not send it to your backend automatically**. You must implement this bridge.

**Step A: Connect Toggle Logic to API**
Open `notification_logic_helper.dart` and locate the `setAppNotificationsEnabled` method. You need to connect this to your User Repository or API Service so the server knows this device is active.

```dart
// inside notification_logic_helper.dart

Future<void> setAppNotificationsEnabled(bool isEnabled) async {
    // ... existing logic ...

    if (isEnabled) {
      String? token = await _firebaseMessaging.getToken();

      // [TODO] CALL YOUR API HERE
      // await sl<UserRepository>().updateFcmToken(token);

      _logger.i('Notifications Enabled. New Token: $token');
    } else {
      // ... existing logic ...
    }
}

```

**Step B: Sync on Login**
In your **Login/Auth Bloc**, after a user successfully logs in, you must ensure the current token is synced:

```dart
// In your AuthBloc / LoginLogic
final token = await NotificationService.instance.fcmToken;
if (token != null) {
   await _userRepository.registerDeviceToken(token);
}

```

## 6. Initialization in `main.dart`

The service must be initialized **after** Firebase but **before** `runApp` to ensure background handlers attach correctly.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase
  await Firebase.initializeApp();

  // 2. Setup Dependency Injection
  setupLocator();

  // 3. Initialize Notification Service
  await NotificationService.instance.initialize();

  runApp(MyApp());
}

```

## 7. Handling Background Messages

The `firebaseMessagingBackgroundHandler` is defined as a top-level function with `@pragma('vm:entry-point')`.

- **Important:** Do not move this function inside a class (unless static). It must remain accessible to the VM isolate when the app is terminated.

---
