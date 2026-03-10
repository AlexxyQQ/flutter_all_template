# Flutter Permission Handling Module

A robust, Clean Architecture-based module for managing permissions in Flutter applications. This module uses `flutter_bloc` for state management, `injectable` for dependency injection, `auto_route` for navigation guarding, and `permission_handler` / `geolocator` for the underlying platform logic.

It supports **checking**, **requesting**, and **skipping** permissions, with persistent caching to remember if a user chose to "skip" a permission request.

---

## 📦 Dependencies

Ensure your `pubspec.yaml` includes the following packages:

```yaml
dependencies:
  flutter:
    sdk: flutter
  permission_handler: ^12.0.1   # Handle OS-level permission requests
  geolocator: ^14.0.2           # Robust Location/GPS service access
  app_settings: ^7.0.0          # Open device Settings from the app (for permanent denial)
  flutter_bloc: ^9.1.1
  fpdart: ^1.2.0
  injectable: ^2.7.1+4
  get_it: ^9.2.0
  freezed_annotation: ^4.9.0
  auto_route: ^11.1.0

dev_dependencies:
  build_runner: ^2.7.1
  injectable_generator: ^2.8.1
  freezed: ^3.2.3
  auto_route_generator: ^10.2.4
```

> **Note:** `device_info_plus` is **not** required. The `permission_handler` package handles Android API level differences internally when using `Permission.storage`.

---

## 📁 File Structure

The module lives at `lib/core/common/features/permission/`:

```
lib/
└── core/
    └── common/
        └── features/
            └── permission/
                ├── README.md
                ├── data/
                │   └── repository/
                │       └── permission_repository_impl.dart
                ├── domain/
                │   ├── entities/
                │   │   ├── permission_cache_entity.dart
                │   │   └── permission_cache_entity.freezed.dart
                │   ├── repository/
                │   │   └── permission_repository.dart
                │   └── services/
                │       └── permission_cache_service.dart
                └── presentation/
                    ├── bloc/
                    │   ├── permission_bloc.dart
                    │   ├── permission_bloc.freezed.dart
                    │   ├── permission_event.dart
                    │   └── permission_state.dart
                    ├── routes/
                    │   ├── guard/
                    │   │   └── permission_guard.dart
                    │   └── permission_route.dart
                    └── view/
                        ├── screens/
                        │   ├── activity_recognition_permission_screen.dart
                        │   ├── bluetooth_permission_screen.dart
                        │   ├── calendar_permission_screen.dart
                        │   ├── camera_permission_screen.dart
                        │   ├── contacts_permission_screen.dart
                        │   ├── location_permission_screen.dart
                        │   ├── microphone_permission_screen.dart
                        │   ├── notification_permission_screen.dart
                        │   ├── phone_permission_screen.dart
                        │   └── storage_permission_screen.dart
                        ├── widgets/
                        │   └── dialog/
                        │       └── permission_dialog.dart
                        └── wrapper/
                            └── permission.wrapper.dart
```

---

## 🍎 iOS Configuration

### Step 1: `Info.plist`

Open `ios/Runner/Info.plist` and add the keys for the permissions you use inside the root `<dict>`:

```xml
<!-- ── Notifications (required for Firebase/local push) ── -->
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
<key>NSLocalNetworkUsageDescription</key>
<string>Used for local notifications.</string>

<!-- ── Camera ── -->
<key>NSCameraUsageDescription</key>
<string>This app requires access to the camera to take profile pictures.</string>

<!-- ── Microphone ── -->
<key>NSMicrophoneUsageDescription</key>
<string>This app requires access to the microphone for voice notes.</string>

<!-- ── Location ── -->
<!-- Required for "while in use" location access -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs your location to show nearby services.</string>
<!-- Required on iOS 11+ to request "always on" location access -->
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs your location to track rides even when in the background.</string>
<!-- Legacy key for iOS 10 and below — keep for backward compatibility -->
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs your location to track rides in the background.</string>

<!-- ── Photos / Storage ── -->
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to your gallery to upload images.</string>

<!-- ── Contacts ── -->
<key>NSContactsUsageDescription</key>
<string>This app needs access to your contacts.</string>

<!-- ── Calendar ── -->
<!-- iOS 17+: use NSCalendarsFullAccessUsageDescription -->
<key>NSCalendarsFullAccessUsageDescription</key>
<string>This app needs full access to your calendar to manage events.</string>
<!-- iOS 16 and below fallback -->
<key>NSCalendarsUsageDescription</key>
<string>This app needs access to your calendar to manage events.</string>

<!-- ── Bluetooth ── -->
<key>NSBluetoothAlwaysUsageDescription</key>
<string>This app uses Bluetooth to connect to nearby devices.</string>
<!-- Legacy key — kept for older iOS versions -->
<key>NSBluetoothPeripheralUsageDescription</key>
<string>This app uses Bluetooth to connect to nearby devices.</string>

<!-- ── Activity Recognition / Motion ── -->
<key>NSMotionUsageDescription</key>
<string>This app needs motion and fitness data to track your activity.</string>
```

> **Location note:** `NSLocationAlwaysAndWhenInUseUsageDescription` is **required** on iOS 11+ when calling `Geolocator.requestPermission()` for background location. Without it the OS will silently deny the request.

### Step 2: `Podfile` — `permission_handler` macros

The `permission_handler` plugin requires you to explicitly enable each permission at compile time. Open `ios/Podfile` and add the following inside your `post_install` block:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)

    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',

        # Set to 1 to enable the permission, 0 to disable and strip its code.
        'PERMISSION_CAMERA=1',
        'PERMISSION_MICROPHONE=1',
        'PERMISSION_LOCATION=1',           # Required even when using Geolocator
        'PERMISSION_PHOTOS=1',             # Required for iOS gallery/storage access
        'PERMISSION_NOTIFICATIONS=1',
        'PERMISSION_CONTACTS=1',
        'PERMISSION_CALENDAR=1',
        'PERMISSION_BLUETOOTH=1',
        'PERMISSION_SENSORS=1',            # Required for Activity Recognition on iOS
      ]
    end
  end
end
```

> **Important:** Only enable the permissions your app actually uses. Enabling unused permissions may cause App Store rejection.

---

## 🤖 Android Configuration

### `AndroidManifest.xml`

Open `android/app/src/main/AndroidManifest.xml` and add the relevant `<uses-permission>` entries **before** the `<application>` tag:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- ── Network (required for Firebase / general internet) ── -->
    <uses-permission android:name="android.permission.INTERNET" />

    <!-- ── Notifications ── -->
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />        <!-- Android 13+ -->
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />

    <!-- ── Camera ── -->
    <uses-permission android:name="android.permission.CAMERA" />

    <!-- ── Microphone ── -->
    <uses-permission android:name="android.permission.RECORD_AUDIO" />

    <!-- ── Location ── -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <!-- Uncomment if you need background location (requires separate runtime request) -->
    <!-- <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" /> -->

    <!-- ── Storage ── -->
    <!-- Legacy storage for Android 12 (API 32) and below -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
        android:maxSdkVersion="32" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
        android:maxSdkVersion="32" />
    <!-- Granular media permissions for Android 13 (API 33) and above -->
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
    <uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />

    <!-- ── Contacts ── -->
    <uses-permission android:name="android.permission.READ_CONTACTS" />
    <uses-permission android:name="android.permission.WRITE_CONTACTS" />

    <!-- ── Calendar ── -->
    <uses-permission android:name="android.permission.READ_CALENDAR" />
    <uses-permission android:name="android.permission.WRITE_CALENDAR" />

    <!-- ── Bluetooth ── -->
    <!-- Android 12 (API 31)+ — granular bluetooth permissions -->
    <uses-permission android:name="android.permission.BLUETOOTH_SCAN"
        android:usesPermissionFlags="neverForLocation" />
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />
    <!-- Android 11 (API 30) and below -->
    <uses-permission android:name="android.permission.BLUETOOTH"
        android:maxSdkVersion="30" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN"
        android:maxSdkVersion="30" />

    <!-- ── Phone ── -->
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <uses-permission android:name="android.permission.CALL_PHONE" />

    <!-- ── Activity Recognition (API 29+) ── -->
    <uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />

    <application ...>
        ...
    </application>
</manifest>
```

> **Storage note:** `permission_handler` v12+ automatically maps `Permission.storage` to the correct API — `READ_EXTERNAL_STORAGE` on API ≤ 32 and `READ_MEDIA_*` on API 33+. Both sets of manifest entries are required.

---

## ✅ Quick Reference: What to Add Per Permission

Use this table as a checklist when adding a new permission to your app.

| Permission | iOS `Info.plist` key(s) | iOS `Podfile` macro | Android `AndroidManifest.xml` |
|---|---|---|---|
| **Camera** | `NSCameraUsageDescription` | `PERMISSION_CAMERA=1` | `CAMERA` |
| **Microphone** | `NSMicrophoneUsageDescription` | `PERMISSION_MICROPHONE=1` | `RECORD_AUDIO` |
| **Location (while in use)** | `NSLocationWhenInUseUsageDescription` | `PERMISSION_LOCATION=1` | `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION` |
| **Location (always/background)** | `NSLocationWhenInUseUsageDescription` + `NSLocationAlwaysAndWhenInUseUsageDescription` + `NSLocationAlwaysUsageDescription` | `PERMISSION_LOCATION=1` | `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`, `ACCESS_BACKGROUND_LOCATION` |
| **Storage / Gallery** | `NSPhotoLibraryUsageDescription` | `PERMISSION_PHOTOS=1` | `READ_EXTERNAL_STORAGE` (maxSdk 32), `WRITE_EXTERNAL_STORAGE` (maxSdk 32), `READ_MEDIA_IMAGES`, `READ_MEDIA_VIDEO`, `READ_MEDIA_AUDIO` |
| **Notifications** | `UIBackgroundModes` (fetch, remote-notification), `NSLocalNetworkUsageDescription` | `PERMISSION_NOTIFICATIONS=1` | `POST_NOTIFICATIONS`, `VIBRATE`, `WAKE_LOCK`, `RECEIVE_BOOT_COMPLETED` |
| **Contacts** | `NSContactsUsageDescription` | `PERMISSION_CONTACTS=1` | `READ_CONTACTS`, `WRITE_CONTACTS` |
| **Calendar** | `NSCalendarsFullAccessUsageDescription` (iOS 17+), `NSCalendarsUsageDescription` (iOS 16 fallback) | `PERMISSION_CALENDAR=1` | `READ_CALENDAR`, `WRITE_CALENDAR` |
| **Bluetooth** | `NSBluetoothAlwaysUsageDescription`, `NSBluetoothPeripheralUsageDescription` | `PERMISSION_BLUETOOTH=1` | `BLUETOOTH_SCAN`, `BLUETOOTH_CONNECT`, `BLUETOOTH_ADVERTISE` (API 31+); `BLUETOOTH`, `BLUETOOTH_ADMIN` (maxSdk 30) |
| **Phone** | *(not required on iOS — permission always granted)* | *(none)* | `READ_PHONE_STATE`, `CALL_PHONE` |
| **Activity Recognition** | `NSMotionUsageDescription` | `PERMISSION_SENSORS=1` | `ACTIVITY_RECOGNITION` (API 29+) |

---

## 🛠 Implementation Guide

### 1. Dependency Injection

The repository and cache service use `@LazySingleton` / `@injectable`. Run the build runner after any changes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 2. Implement External Dependencies

The code references two services outside this module that you must provide:

- **`NotificationService`** — used in `requestNotificationPermission()`. Must expose:
  - `NotificationService.instance.requestPermission()` → `Future<bool>`
  - `NotificationService.instance.fcmToken` → `String?`
- **`PermissionCacheService`** — wraps `BaseSingleCacheService<PermissionCacheEntity>` using your preferred storage (SharedPreferences / Hive / Isar).

### 3. Setting Up Route Guards

Guards intercept navigation and redirect the user to the permission screen if the permission is not granted or skipped.

```dart
@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [

    // Example: protect a map screen behind location permission
    AutoRoute(
      page: MapRoute.page,
      path: '/map',
      guards: [LocationPermissionGuard()],
    ),

    // Example: protect a camera screen
    AutoRoute(
      page: CameraRoute.page,
      guards: [CameraPermissionGuard()],
    ),

    // Register the permission screens (required for guards to redirect)
    ...PermissionRoute.routes,
  ];
}
```

Available guards: `NotificationPermissionGuard`, `LocationPermissionGuard`, `CameraPermissionGuard`, `MicrophonePermissionGuard`, `StoragePermissionGuard`, `ContactsPermissionGuard`, `CalendarPermissionGuard`, `BluetoothPermissionGuard`, `PhonePermissionGuard`, `ActivityRecognitionPermissionGuard`.

### 4. Using the Bloc in UI

The permission screens already handle all state. If you need to build a custom screen, use `PermissionBloc`:

```dart
class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PermissionBloc>()
        ..add(const PermissionEventCheckLocationPermission()),
      child: BlocConsumer<PermissionBloc, PermissionState>(
        listener: (context, state) {
          if (state.locationPermissionStatus.isGranted) {
            context.router.replace(const MapRoute());
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              const Text('We need location access'),
              ElevatedButton(
                onPressed: () => context.read<PermissionBloc>()
                    .add(const PermissionEventRequestLocationPermission()),
                child: const Text('Grant Permission'),
              ),
              TextButton(
                onPressed: () => context.read<PermissionBloc>()
                    .add(const PermissionEventSkipLocationPermission()),
                child: const Text('Skip for now'),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

---

## 🔄 How the Flow Works

1. **User navigates** to a guarded route (e.g. `/map`).
2. **Guard intercepts** — `LocationPermissionGuard` runs before the route resolves.
3. **Cache check** — if `skippedLocationPermission == true` in `PermissionCacheService`, the guard allows navigation immediately.
4. **System check** — queries the OS permission status (via Geolocator for location, `permission_handler` for others):
   - `Granted` → navigation continues.
   - `Denied` or `PermanentlyDenied` → guard redirects to the permission screen.
5. **User action** on the permission screen:
   - **Grant** — Bloc dispatches a request, state updates to `isGranted`, listener navigates to the destination.
   - **Skip** — Bloc writes `skipped = true` to cache. Next visit, Step 3 passes immediately.
   - **Permanently denied** — a dialog is shown with a button to open device Settings via `app_settings`.

---

## ⚠️ FCM Token / `setFcm`

The `setFcm` method in `PermissionRepositoryImpl` is currently a placeholder (`throw UnimplementedError()`). Implement it to persist the FCM token to your backend (e.g. Supabase, Firebase Firestore, a REST API) after notification permission is granted.
