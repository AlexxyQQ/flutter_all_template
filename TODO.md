# Flutter All Template — Feature Backlog

A living document of everything that **can** be added to this template.
Items are grouped by theme and roughly ordered by how foundational they are (add earlier items before later ones that depend on them).

Tick a box and move the item into `CHANGELOG.md` once shipped.

---

## Legend

| Symbol | Meaning |
|--------|---------|
| `[ ]` | Not started |
| `[~]` | In progress / partially done |
| `[x]` | Complete |

---

## 0. Security (Action Required)

### 0.1 — Rotate Exposed Firebase Keys

> **IMPORTANT:** The Firebase API keys previously committed to this repo have been replaced
> with placeholders, but the real values exist in git history. You must revoke and rotate them
> from the Firebase console before this repo goes public.

- [ ] **Rotate Android API key** — Go to [Google Cloud Console → Credentials](https://console.cloud.google.com/apis/credentials), find the Android key for project `flutter-all-template`, and delete or restrict it. Run `flutterfire configure` to generate a fresh key.
- [ ] **Rotate iOS API key** — Same as above for the iOS API key. The old key (`AIzaSyBtU1CXHdIpVqQaRUKvbHH9awbN4Dmf4Jc`) must be revoked.
- [ ] **Purge keys from git history** — Use `git filter-repo` or BFG Repo Cleaner to remove the old commits containing real keys. Then force-push `main` and notify collaborators to re-clone. Command:
  ```bash
  # Install: pip install git-filter-repo
  git filter-repo --replace-text <(echo 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX==>REMOVED_KEY')
  git filter-repo --replace-text <(echo 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
  ```
- [ ] **Set up Firebase App Check** — After rotating keys, enable [Firebase App Check](https://firebase.google.com/docs/app-check) (Play Integrity on Android, DeviceCheck on iOS) to prevent API abuse even if keys are ever leaked again.
- [ ] **Restrict API keys by package name / bundle ID** — In Google Cloud Console, restrict both keys to only accept requests from your specific Android package name and iOS bundle ID. This limits damage if keys are leaked in the future.

---

## 1. Authentication & Identity

### 1.1 — Core Auth Flow
- [ ] **JWT Authentication module** — A complete `features/auth/` slice following the same Clean Architecture pattern already used in this template. Includes: `LoginBloc`, `RegisterBloc`, `IAuthRepository` + `AuthRepositoryImpl`, `AuthLocalDataSource` (persists tokens via `SecureStorageService`), and `AuthRemoteDataSource` (calls the login/register endpoints via `ApiHandler`). The `AppSettingBloc` should be extended with an `isLoggedIn` flag so the splash screen can decide whether to push the user to the dashboard or the login page.
- [ ] **Token refresh interceptor** — A Dio interceptor (add inside `DioService`) that detects HTTP 401 responses, silently calls the refresh-token endpoint, saves the new access token to secure storage, then retries the original request — all without the caller knowing. Should handle the race condition where multiple requests 401 simultaneously (use a lock/queue pattern with `rxdart`).
- [ ] **Auth route guard** — An `auto_route` guard (`AuthGuard`) that reads `isLoggedIn` from `AppSettingBloc` before every navigation. Unauthenticated users are redirected to `/login`. The guard should live in `lib/core/common/presentation/routes/guards/`.
- [ ] **Logout flow** — A `LogoutEvent` that clears the FCM token (already done by `NotificationService.disableNotifications()`), wipes the JWT from secure storage, resets `AppSettingBloc`, and navigates the user to the login screen. Ensure cache and any in-memory BLoC state is also cleared.

### 1.2 — Social / Federated Auth
- [ ] **Google Sign-In** — Integrate `google_sign_in`. Wrap the native SDK call in `GoogleAuthDataSource`, returning an `Either<Failure, SocialAuthResult>`. `SocialAuthResult` is a Freezed model holding the `idToken` and `accessToken` so the backend can verify them. Add the `google-services.json` / `GoogleService-Info.plist` setup steps to a `docs/SOCIAL_AUTH.md` file.
- [ ] **Apple Sign-In** — Integrate `sign_in_with_apple`. Required for any iOS app that offers third-party sign-in (App Store policy). Guard the button with `SignInWithApple.isAvailable()` and only show it on Apple platforms. Store the opaque `userIdentifier` in secure storage for future credential revocation checks.
- [ ] **Facebook Login** — Integrate `flutter_facebook_auth`. Add a `FacebookAuthDataSource`. Document the app ID setup in `AndroidManifest.xml` and `Info.plist` inside a dedicated section of `docs/SOCIAL_AUTH.md`.

### 1.3 — Biometrics & App Lock
- [ ] **Biometric authentication** — Integrate `local_auth`. Add a `BiometricService` behind an `IBiometricService` interface in `lib/core/common/domain/services/biometric/`. Expose `canAuthenticate()`, `authenticate(reason)`, and `getBiometricTypes()`. Persist whether the user has opted in via `AppSetting` (add an `isBiometricEnabled` field). Show a biometric prompt on app resume if enabled.
- [ ] **App lock / PIN lock** — A full-screen lock overlay triggered when the app returns from background (listen to `AppLifecycleState`). The user sets a 4–6 digit PIN (stored as a bcrypt hash in secure storage, never plain text). After 5 failed attempts, require biometric or full password re-entry. This module should live at `lib/core/common/features/app_lock/`.

---

## 2. Data Persistence & Offline-First

### 2.1 — Local Database
- [ ] **Isar local database** — Add `isar` and `isar_flutter_libs` as dependencies. Create a generic `IsarService` (injectable singleton) that opens the database with all registered schemas. Extend the `BaseCacheService` abstraction to support Isar as a backend so any feature can swap from in-memory to persistent storage with a one-line change. Write a `docs/ISAR_SETUP.md` explaining schema registration and the `rps build` code-gen step.
- [ ] **Hive alternative** — For projects that prefer a lighter box-based store (config objects, user preferences beyond what secure storage handles), add `hive_flutter` + `hive_generator` as an optional alternative layer alongside Isar. Both should implement the same `ILocalDataSource<T>` interface.

### 2.2 — HTTP Caching
- [ ] **Dio cache interceptor** — Add `dio_cache_interceptor` with a `HiveCacheStore` (or `IsarCacheStore`). Centralise cache policy constants (TTL per endpoint family) in `lib/config/constants/cache_constants.dart`. GET requests should be served from cache when offline and refreshed in the background when online (stale-while-revalidate pattern). Clear the cache on logout.

### 2.3 — Offline Sync
- [ ] **Connectivity-aware request queue** — Use the existing `connectivity_plus` dependency to detect going offline. Queue mutating requests (POST/PUT/DELETE) in an Isar collection and drain the queue when connectivity is restored. Expose `SyncBloc` with states: `SyncIdle`, `SyncPending(count)`, `SyncInProgress`, `SyncComplete`, `SyncFailed`. Show a persistent banner (see UI section §8.1) when there are pending sync items.

---

## 3. Navigation & Deep Linking

### 3.1 — Deep Links
- [ ] **Universal links / App links** — Configure `AssetLinks.json` (Android) and Apple App Site Association (iOS) for `https://` deep links. Add a `DeepLinkService` that listens to incoming URIs via `app_links` and calls `NavigationService.navigateTo(parsedRoute)`. Map URL paths to `auto_route` named routes in a `DeepLinkRouter` class. Document the server-side file hosting requirement.
- [ ] **Firebase Dynamic Links (or Branch.io)** — Add a `DynamicLinkService` that both generates shareable short links and handles incoming ones at cold start and while running. Wire into the notification payload's `redirect_url` field already handled by `NotificationService`.

### 3.2 — In-App Navigation Enhancements
- [ ] **Back-button intercept / exit confirmation** — A `PopScope`-based mixin for top-level screens that shows a "Are you sure you want to exit?" dialog on Android back-button press. The dialog uses the existing `AppButton` and `AppTextWidget` components.
- [ ] **Bottom navigation state preservation** — If a bottom navigation bar is added, implement `IndexedStack` + separate `auto_route` stacks per tab so each tab preserves its own scroll position and navigation history when switching tabs.

---

## 4. Notifications & Real-Time

### 4.1 — In-App Notifications
- [ ] **In-app notification centre** — A `features/notifications/` slice that fetches paginated notification history from an API, marks items as read, and renders them in a `NotificationListScreen`. Use the `PaginatedCrudMixin` from `BaseCrudBloc`. Add an unread-count badge that updates via WebSocket or polling.
- [ ] **Scheduled local notifications** — Extend `NotificationService` with a `scheduleNotification(DateTime triggerAt, ...)` method using `awesome_notifications`'s schedule API. Useful for reminders, subscription renewals, etc.

### 4.2 — Real-Time Messaging
- [ ] **WebSocket service** — A `WebSocketService` backed by `websocket_channel` (or `socket_io_client` for Socket.IO servers). Implements `IWebSocketService` with `connect()`, `disconnect()`, `send(Map)`, and a `Stream<dynamic> messages` getter. The service should auto-reconnect with exponential backoff on disconnection. Use `rxdart`'s `BehaviorSubject` to hold connection state.
- [ ] **Chat / messaging feature** — A `features/chat/` module with `ChatBloc` consuming the `WebSocketService`. Messages are modelled as a Freezed `ChatMessage` entity (id, senderId, text, timestamp, status). The UI uses `flutter_chat_ui` (or a custom implementation using existing `AppButton`/`AppTextWidget` components) inside a `ChatScreen`.

---

## 5. Media & Device Hardware

### 5.1 — Camera & Image Editing
- [ ] **Image cropping** — After picking an image with the existing `image_picker` integration, pipe it through `image_cropper` to let the user crop and rotate before upload. Add a `CropperHelper` in `lib/core/common/presentation/helpers/` that wraps the platform UI configuration (toolbar colours matching `AppColors`, crop aspect ratios as named constants).
- [ ] **Camera preview widget** — A fullscreen `CameraScreen` using `camera` package with torch toggle, front/back camera swap, tap-to-focus, and a circular capture button. Captured photos are passed back via `auto_route`'s return value.
- [ ] **Video recording** — Extend `CameraScreen` with a long-press-to-record video mode. Show a progress ring for max recording duration (configurable constant). Compress recorded video using `video_compress` before upload.

### 5.2 — QR / Barcode
- [ ] **QR/Barcode scanner** — A `QrScannerScreen` using `mobile_scanner` that overlays a scan window on the camera feed. The scanned value is returned to the caller via `auto_route`. Also add a `QrGeneratorWidget` using `qr_flutter` to render QR codes from a string.

### 5.3 — Audio
- [ ] **Audio player** — A `features/audio/` module using `just_audio` with `audio_service` for background playback and lock-screen controls. Expose play/pause/seek/stop via `AudioBloc`. UI: `MiniPlayerWidget` (persistent bottom bar) and `FullPlayerScreen`.
- [ ] **Audio recorder** — Using `record` package, expose a `RecorderService` behind `IRecorderService`. Display waveform amplitude using a `WaveformWidget` (animate a `CustomPainter` with amplitude values from the stream). Save recordings to the app documents directory via `path_provider`.

### 5.4 — Maps & Location
- [ ] **Google Maps widget** — A `MapWidget` wrapping `google_maps_flutter` with: current-location button (reuses existing `geolocator`), custom marker support (`BitmapDescriptor` from SVG via `flutter_svg`), polyline/polygon drawing, and a `MapBloc` that manages camera position and marker state. Add the API key to `env/.env` and load it via `flutter_dotenv`.
- [ ] **Geofencing** — Using `geofence_service`, define circular or polygon geofences as Isar-persisted `GeofenceEntity` objects. Fire `GeofenceEnteredEvent` / `GeofenceExitedEvent` into a `GeofenceBloc`. Run in background with `workmanager`.

### 5.5 — NFC
- [ ] **NFC reading / writing** — Using `nfc_manager`, add a `NfcService` with `readTag()` and `writeTag(Map<String,dynamic> payload)`. Guard with `NfcManager.instance.isAvailable()`. Write a dedicated README in `lib/core/common/domain/services/nfc/README.md`.

---

## 6. Payments & Monetization

### 6.1 — In-App Purchases
- [ ] **RevenueCat integration** — Add `purchases_flutter`. Create a `PurchaseService` behind `IPurchaseService` that wraps `Packages`, `Offerings`, `CustomerInfo`. Store entitlement status in `AppSetting` (add an `activeEntitlements: List<String>` field). Add a `PaywallScreen` that lists offerings using `AppButton` variants. Write `docs/IAP_SETUP.md` covering App Store Connect and Play Console product configuration.
- [ ] **Stripe payments** — For apps that charge one-time fees via a backend payment intent flow, integrate `flutter_stripe`. Implement `StripeService` with `initPaymentSheet(clientSecret)` and `presentPaymentSheet()`. The server is responsible for creating the payment intent; this module only handles the client-side presentation.

### 6.2 — Ads
- [ ] **Google AdMob** — Integrate `google_mobile_ads`. Add an `AdService` (singleton) that initialises the SDK, loads banner/interstitial/rewarded ads, and exposes `BannerAdWidget`. Respect GDPR via the User Messaging Platform (UMP) — show consent dialog on first launch and persist the user's choice in `AppSetting`.

---

## 7. Analytics & Monitoring

### 7.1 — Crash Reporting
- [ ] **Firebase Crashlytics** — Add `firebase_crashlytics`. In `bootstrap()`, set `FlutterError.onError` and `PlatformDispatcher.instance.onError` to forward to Crashlytics. Tag crashes with user ID and device locale (from `AppSettingBloc`). Ensure PII is never logged (no tokens, no passwords).

### 7.2 — Analytics
- [ ] **Firebase Analytics** — Add `firebase_analytics`. Create an `AnalyticsService` behind `IAnalyticsService` so the concrete provider can be swapped (e.g. Mixpanel, Amplitude). Add an `AnalyticsObserver` to `AppRouter` for automatic screen-view events. Expose `logEvent(name, parameters)` and `setUserProperty(name, value)` methods.
- [ ] **Performance monitoring** — Add `firebase_performance`. Create HTTP traces automatically in a `PerformanceInterceptor` added to `DioService`. Add custom traces around expensive operations (e.g. image processing, Isar queries).

### 7.3 — Remote Config
- [ ] **Firebase Remote Config** — Add `firebase_remote_config`. Create a `RemoteConfigService` that fetches and activates config on startup with a short fetch interval in debug and a longer one in release. Expose typed getters (e.g. `featureFlags.enableNewCheckout`). Use this to roll out features behind flags without a new app release.

---

## 8. UI & UX Enhancements

### 8.1 — Connectivity Banner
- [ ] **Offline / reconnecting banner** — A `ConnectivityBanner` widget that slides in from the top when `connectivity_plus` reports no connection and slides out on reconnection. The banner respects the theme's colour palette and uses the `AppTextWidget`. Wire it into `app.dart` above the router so it appears on every screen.

### 8.2 — Skeleton / Shimmer Loading
- [ ] **Shimmer loading placeholders** — Replace "isLoading" spinner usage with `shimmer`-based skeleton screens in list and detail views. Add a `ShimmerWrapper` widget that uses `BoxDecoration` with the theme's `surfaceVariant` colour as the base. Document which `BaseCrudState.isLoading` flag to watch.

### 8.3 — Onboarding Flow
- [ ] **Onboarding module** — A `features/onboarding/` module with a `PageView`-based flow. Each page is a `OnboardingPage` Freezed model (title, subtitle, `LocaleKeys` keys, lottie animation path). `AppSettingBloc` gains an `onboardingComplete` boolean so the splash screen skips onboarding on subsequent launches. Include dot indicators and skip/next/done `AppButton` variants.

### 8.4 — Rich Content
- [ ] **Markdown renderer** — Add `flutter_markdown`. Create an `AppMarkdownWidget` that applies the current theme's `TextStyle` tokens from `AppTextWidget` to the Markdown style sheet. Useful for rendering server-driven content (FAQs, privacy policy, release notes).
- [ ] **PDF viewer** — Add `syncfusion_flutter_pdfviewer` (or `pdfx` for FOSS preference). Create an `AppPdfViewerScreen` that accepts a URL or local file path, shows a loading indicator while downloading (via `Dio`), and supports pinch-to-zoom and scroll.
- [ ] **PDF generation** — Add `pdf` and `printing`. Create a `PdfGenerator` utility class with `generateInvoicePdf(InvoiceEntity)` → `Uint8List`. Wire into the share sheet (§8.6).

### 8.5 — Charts & Data Visualisation
- [ ] **fl_chart integration** — Add `fl_chart`. Create themed wrappers (`AppLineChart`, `AppBarChart`, `AppPieChart`) that accept typed data models and auto-apply colours from the current theme. All charts should respond to `ThemeCubit` changes without rebuild.

### 8.6 — Share & Export
- [ ] **Share sheet** — Add `share_plus`. Create a `ShareHelper` in `lib/core/common/presentation/helpers/` with `shareText(text)`, `shareFile(XFile)`, and `shareUri(uri)`. Integrate into PDF generator and media picker flows.
- [ ] **Clipboard manager** — Add a `ClipboardHelper` with `copy(text)` (shows a `SnackbarHelper.success` confirmation) and `paste() → Future<String?>`. Useful for invite codes, tracking IDs, etc.

### 8.7 — Accessibility
- [ ] **Semantic labels audit** — Go through every system widget in `lib/core/common/presentation/views/widgets/system/` and add `Semantics` wrappers with meaningful `label`, `hint`, and `value` properties. Add a `TextScalerClamp` wrapper at the `MaterialApp` level to cap font scaling at 1.3× to prevent layout overflow.
- [ ] **Focus traversal** — Ensure all form screens define explicit `FocusTraversalGroup` with `OrderedTraversalPolicy` so keyboard/switch-access users tab through fields in the correct order. Add `autofocus: true` to the first field of every form.
- [ ] **High-contrast theme** — Add a third theme variant (`AppHighContrastTheme`) with 7:1 contrast ratios across all text/background pairs. Register it via `ThemeData.highContrastTheme` and detect via `MediaQuery.of(context).highContrast`.

### 8.8 — Animations
- [ ] **Lottie animations** — Add `lottie`. Create an `AppLottieWidget` that loads from the `assets/lottie/` directory (already declared in `pubspec.yaml`) with configurable repeat, autoplay, and fit. Use in onboarding and empty-state screens.
- [ ] **Hero transitions** — Add `Hero` tags to image list → detail transitions. Create a `HeroTag` constant class so tag strings are never duplicated between list and detail screens.
- [ ] **Page transition themes** — Abstract `auto_route`'s `CustomRouteBuilder` into named transitions (fade, slide-up, scale) stored in `lib/core/common/presentation/routes/transitions/`. Different route families can then declare their preferred transition in one place.

---

## 9. App Distribution & CI/CD

### 9.1 — Build Flavors
- [ ] **Flavor configuration** — Set up `dev`, `staging`, and `prod` flavors. Each flavor has its own `main_<flavor>.dart`, `.env.<flavor>` file, app name suffix (`MyApp Dev`), and bundle ID suffix (`.dev`). Firebase projects should be separate per flavor. Document flavor build commands in the root `README.md`.

### 9.2 — CI/CD Pipelines
- [ ] **GitHub Actions — PR checks** — A workflow (`.github/workflows/pr_checks.yml`) that runs on every PR: `flutter analyze`, `dart run custom_lint`, `flutter test --coverage`, and uploads the coverage report as an artifact.
- [ ] **GitHub Actions — Release build** — A workflow (`.github/workflows/release.yml`) triggered by a version tag (`v*.*.*`) that builds the APK + App Bundle (Android) and IPA (iOS) and uploads them to a GitHub Release draft. Secrets are stored as GitHub Actions secrets.
- [ ] **Codemagic integration** — Alternatively, provide a `codemagic.yaml` that mirrors the above: test → build → sign → deploy to Firebase App Distribution (internal testers) on every `develop` push, and to Play Store / TestFlight on `main`.

### 9.3 — Code Signing
- [ ] **Keystore setup documentation** — Add a `docs/CODE_SIGNING.md` explaining how to generate an Android keystore, store the `.jks` in a GitHub secret (base64 encoded), decode it in CI, and reference it in `android/app/build.gradle`. Mirror for iOS with a Fastlane `match` or manual profile export explanation.

### 9.4 — OTA Updates
- [ ] **Shorebird patch workflow** — The `pubspec.yaml` already has Shorebird scripts commented out. Add a GitHub Actions workflow that creates a Shorebird patch on demand (workflow-dispatch trigger), reads the `--release-version` from the tag, and runs both Android and iOS patch commands. Add a guard that only runs this workflow for the `prod` flavor.

---

## 10. Testing

### 10.1 — Unit Tests
- [ ] **Service layer tests** — Add unit tests for `DioService` (mock `Dio` via `mockito`), `SecureStorageService`, `NavigationService`, and `AppLogger`. Place tests in `test/core/common/domain/services/`.
- [ ] **Repository tests** — For every `RepositoryImpl`, verify the happy path and the two failure paths (network error → `NetworkFailure`, server error → `ServerFailure`). Mock the data sources.
- [ ] **BLoC tests** — For every `*Bloc`, use `bloc_test` to verify that each event produces the expected sequence of states. Aim for ≥ 80 % branch coverage on BLoC files.

### 10.2 — Widget Tests
- [ ] **System widget tests** — For every widget in `lib/core/common/presentation/views/widgets/system/`, write a widget test that pumps the widget in both light and dark `ThemeData`, takes a golden screenshot, and asserts the golden hasn't regressed. Use `network_image_mock` (already in dev deps) for image widgets.
- [ ] **Screen smoke tests** — For each feature screen, write a smoke test that pumps the screen with a stub BLoC and asserts it doesn't throw or overflow. Use `MockNavigator` from `mocktail` to stub route dependencies.

### 10.3 — Integration Tests
- [ ] **Full login flow integration test** — Using `integration_test`, write an end-to-end test that launches the app, taps through the permission screens, fills in the login form, and asserts that the dashboard is reached. Run against a local mock server.
- [ ] **Golden tests workflow** — Add a `rps goldens:update` script that runs `flutter test --update-goldens` and commits the updated golden files. Add a `rps goldens:check` script used in CI.

---

## 11. Internationalisation (i18n)

### 11.1 — Additional Locales
- [ ] **RTL support** — Add Arabic (`ar`) or Hebrew (`he`) as a supported locale. Verify every screen with `Directionality(textDirection: TextDirection.rtl, ...)` to catch layout issues. Audit all `Padding`/`EdgeInsets` to use `EdgeInsetsDirectional` instead of `EdgeInsets` (start/end instead of left/right).
- [ ] **Locale auto-detection** — On first launch, instead of defaulting to `en-GB`, detect the device locale via `PlatformDispatcher.instance.locale` and set the closest supported locale automatically. Persist the chosen locale in `AppSetting` as today. Only show a manual locale picker in settings.
- [ ] **Pluralisation** — Add pluralisation rules to the translation JSON (`one`, `many`, `other` keys) and use `easy_localization`'s `.plural()` method. Update the `LocaleKeys` code-gen command to include `--format keys_with_plurals`.

---

## 12. Developer Experience

### 12.1 — Code Generation Scripts
- [ ] **Feature scaffold script** — A `scripts/new_feature.dart` CLI that takes a feature name and generates the full `lib/features/<name>/` tree (data/domain/presentation folders, stub files, `@injectable` registration, an `auto_route` `@RoutePage`, and a stub BLoC extending `BaseCrudBloc`) in one command. Add a `rps feature` script alias.
- [ ] **Export barrel generator** — The `scripts/generate_exports.dart` already exists. Extend it to also detect circular imports and print a warning rather than silently generating a bad barrel file.

### 12.2 — Debugging Tools
- [ ] **Network inspector overlay** — In debug mode only, mount `alice` (or `dio_inspector`) so developers can inspect all HTTP traffic in-app without needing a proxy. The overlay should be unreachable in release builds (guard with `kDebugMode`).
- [ ] **BLoC state inspector** — Add a `BlocObserver` subclass (`AppBlocObserver`) that logs every event/transition/error to `AppLogger.debug()`. Already straightforward — register it in `bootstrap()` via `Bloc.observer = AppBlocObserver()`. Add a TODO note to mute verbose state printing in prod.
- [ ] **Flutter DevTools extensions** — Evaluate `devtools_extensions` for adding a custom tab that displays the current DI graph from `GetIt` (registered singletons, factories, lazy singletons). This is purely a dev-time tool and has zero impact on release builds.

### 12.3 — Documentation
- [ ] **Architecture decision records (ADRs)** — Add a `docs/adr/` folder. Write the first ADR (`0001-use-bloc-over-riverpod.md`) explaining why BLoC was chosen, what alternatives were considered, and how to challenge the decision. New decisions (e.g. switching from Hive to Isar) should each get an ADR.
- [ ] **Video walkthroughs** — Record short (< 5 min) Loom videos for the three highest-friction parts of the template: setting up Firebase, adding a new feature slice, and customising the theme. Link them from the root `README.md`.

---

## 13. Platform-Specific

### 13.1 — Android
- [ ] **App shortcuts (launcher shortcuts)** — Add static and dynamic shortcuts via the `quick_actions` package. Shortcuts should be defined as a `List<ShortcutItem>` constant and registered in `bootstrap()`. Each shortcut navigates to a deep link handled by `DeepLinkService`.
- [ ] **Edge-to-edge / system bar styling** — Set `SystemUiOverlayStyle` from `AppColors` so the status bar and navigation bar colours match the current theme. Listen to `ThemeCubit` changes and update the overlay style reactively. Avoid hardcoding `Brightness.dark` — derive it from the current `ThemeData`.
- [ ] **Adaptive icons (already done via icons_launcher)** — Verify monochrome adaptive icon renders correctly on Android 13+ themed icon mode. Add themed icon colour reference to `docs/THEMING.md`.

### 13.2 — iOS
- [ ] **iOS widgets (WidgetKit)** — Research feasibility of a simple iOS home-screen widget using `home_widget` package. Widget data is written from the Flutter side into `UserDefaults` shared with the widget extension. The widget reads the latest state and displays a summary (e.g. current task count, health metric).
- [ ] **iOS background fetch** — Use `workmanager` to register a `BGAppRefreshTask` on iOS that syncs data while the app is in the background. Ensure background capability is enabled in Xcode's "Signing & Capabilities" tab and documented in `docs/BACKGROUND_TASKS.md`.
- [ ] **Live Activities (iOS 16+)** — Investigate `push_to_talk` or custom native channels for displaying real-time updates on the Dynamic Island / Lock Screen. Provide a stub `LiveActivityService` with platform-channel bindings even if the full implementation is left to the consuming project.

### 13.3 — Web & Desktop
- [ ] **Web build** — The `rps build:web` script already exists but is untested. Audit every plugin used in the template for web compatibility (`permission_handler`, `flutter_secure_storage`, and `awesome_notifications` are known non-web packages). Add `kIsWeb` guards and web-specific fallback implementations for at least the storage and notification services.
- [ ] **macOS / Windows / Linux** — Mirror the web audit for desktop. `flutter_secure_storage` supports macOS and Windows. Notification support requires `local_notifier` on desktop. Create platform-specific `DataSource` implementations behind the existing service interfaces.

---

## 14. Health, Fitness & Sensors

### 14.1 — HealthKit / Google Fit
- [ ] **Health data integration** — Add `health`. Create a `HealthService` behind `IHealthService` that requests read permissions for steps, calories, heart rate, and sleep. Expose `getMetrics(DateRange) → Future<Either<Failure, HealthSummary>>`. `HealthSummary` is a Freezed model. Add the required `Info.plist` entries (`NSHealthShareUsageDescription`, `NSHealthUpdateUsageDescription`) to the permission README.

### 14.2 — Pedometer / Motion
- [ ] **Step counter** — Add `pedometer`. Create a `PedometerService` that wraps the step-count stream and exposes a daily step total. Persist daily totals to Isar. Display in a `StepCountWidget` using `fl_chart`.

---

## 15. Miscellaneous

- [ ] **App review prompt** — Add `in_app_review`. Trigger `InAppReview.instance.requestReview()` after a positive user action (e.g. completing an order, reaching a milestone). Guard with a minimum install age (> 7 days) and a "has prompted before" flag in `AppSetting` to avoid spamming the dialog.
- [ ] **Rate limiting / debounce helpers** — Add a `Debouncer` utility class (backed by `Timer`) and a `Throttler` to `lib/core/common/presentation/helpers/`. Document the difference and add usage examples in the helpers README. The `SearchableMixin` in `BaseCrudBloc` should use `Debouncer` internally.
- [ ] **Haptic feedback service** — Add `HapticService` using `HapticFeedback` (Flutter SDK, no extra dependency). Expose `lightTap()`, `mediumTap()`, `heavyTap()`, `success()`, `error()`, `warning()`. Inject into `AppButton` and form validation feedback so all haptics come from one place and can be globally enabled/disabled via `AppSetting`.
- [ ] **App update enforcement** — The `upgrader` package is already in `pubspec.yaml`. Wire it into `app.dart` using `UpgradeAlert` wrapping the root `Router.withDelegate`. Configure minimum version (`minAppVersion`) server-side so critical patches can be enforced without a new release.
- [ ] **Screenshot prevention** — On sensitive screens (e.g. payment, auth tokens), call `FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE)` on Android and `NativeChannel.call('enableScreenShield')` on iOS to prevent screenshots and screen recording. Wrap in a `SecureScreenMixin` that activates in `initState` and deactivates in `dispose`.
- [ ] **Encrypted log upload** — Extend `AppLogger`'s existing log-upload mechanism to encrypt the log file with AES-256 (via the `encrypt` package and a server-provided public key) before transmitting. The server decrypts with its private key. This prevents log content from being intercepted in transit even over plain HTTP (useful in restrictive network environments).
- [ ] **Changelog screen** — A `ChangelogScreen` that reads `CHANGELOG.md` bundled in `assets/` and renders it with `AppMarkdownWidget`. Shown automatically when the app version in `AppSetting` differs from `PackageInfo.version` (use `package_info_plus`). Updates the stored version on dismiss.

---

*Last updated: 2026-03-09*
