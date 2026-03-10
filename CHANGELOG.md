# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [1.0.3] — 2026-03-10

### Added
- **`bricks/feature_brick/`** — new Mason brick that generates a complete clean-architecture feature module; prompts for `feature_name`, `use_local_datasource`, and `use_params`. Generates:
  - `data/models/` — Freezed + JSON model with `toEntity()` mapper
  - `data/data_sources/` — abstract interface + remote data source (`ApiHandler`); optional local data source (`ISecureStorageDataSource`) behind `use_local_datasource`
  - `data/repositories/` — `@lazySingleton` repository impl with `mapModelToEntity` helpers
  - `domain/entities/` — Freezed entity; optional typed `RequestParams` class behind `use_params`
  - `domain/repositories/` — abstract `I{{Feature}}Repository` interface
  - `presentation/bloc/` — `@injectable` BLoC extending `BaseCrudBloc` with all CRUD + search + pagination mixins
  - `hooks/post_gen.dart` — deletes `params/` if `use_params=false`; deletes `local/` if `use_local_datasource=false`; prints next-steps guide

### Changed
- **Brick directories consolidated** — `brick/` renamed to `bricks/project_brick/` and `feature_brick/` moved to `bricks/feature_brick/`; all bricks now live under a single top-level `bricks/` directory
- **`analysis_options.yaml`** — updated analyzer `exclude` from `brick/**` to `bricks/**` to cover the new unified directory
- **`README.md`** — updated `brick/README.md` link to `bricks/project_brick/README.md`

---

## [1.0.2] — 2026-03-10

### Changed
- **`FOLDER_STRUCTURE.md`** — added a new **Example Feature Structure** section showing the real file tree of `lib/features/example/` as a reference implementation
- **`FOLDER_STRUCTURE.md`** — `lib/features/` listing updated from placeholder `another/` to `example/`
- **`FOLDER_STRUCTURE.md`** — Feature Anatomy diagram updated: `use_cases/` directory removed; `domain/entities/params/` sub-directory added to reflect actual layout

### Removed
- **`use_cases/` layer dropped** — the `domain/use_cases/` directory is no longer part of the standard feature anatomy. Business logic previously placed in use cases now lives directly in the BLoC / Cubit, keeping the call chain flat (`BLoC → Repository → DataSource`). A note in `FOLDER_STRUCTURE.md` explains the rationale and how to reintroduce the layer if needed.
- `lib/features/example/domain/entities/params/example_entity_converters.dart` — removed stale converter file superseded by the Freezed param models

---

## [1.0.1] — 2026-03-09

### Security
- **Removed real Firebase API keys** from all tracked files — replaced with clearly-labelled placeholders (`YOUR_ANDROID_API_KEY`, `YOUR_IOS_API_KEY`, etc.) in:
  - `android/app/google-services.json`
  - `ios/Runner/GoogleService-Info.plist`
  - `lib/config/firebase/firebase_options.dart`
  - `bricks/project_brick/__brick__/` copies of the above
- **Updated `.gitignore`** — added a documented section explaining how to prevent future accidental commits of real Firebase config files; real `.env` files are now explicitly ignored
- **Added `TODO.md` security section (§0)** — step-by-step checklist to rotate the exposed keys, purge them from git history via `git filter-repo`, enable Firebase App Check, and restrict API keys by package name / bundle ID

> **Action required before making this repo public:** follow the steps in `TODO.md §0` to rotate the exposed keys and purge git history.

---

## [1.0.0] — 2026-03-09

### Added
- **Mason brick** (`brick/`) — users can now generate a tailored project by running `mason make flutter_all_template` and answering 5 questions:
  - `app_name` — sets the Flutter package name (auto snake_cased)
  - `app_org` — sets the Android applicationId / namespace organisation prefix
  - `use_firebase` — optionally includes `firebase_core` + `firebase_messaging`; removes `lib/config/firebase/` when disabled
  - `use_notifications` — optionally includes `awesome_notifications` + the full `NotificationService`; removes `lib/core/common/domain/services/notification/` when disabled
  - `use_permissions` — optionally includes `permission_handler`, `geolocator`, `app_settings`, all 10 permission screens, `PermissionBloc`, and route guards; removes `lib/core/common/features/permission/` when disabled
- **`post_gen` hook** (`brick/hooks/post_gen.dart`) — runs automatically after generation to rename all `package:flutter_all_template/` import paths to the user's chosen package name, update `android/app/build.gradle` applicationId/namespace, and delete disabled feature directories
- **Brick README** (`brick/README.md`) — full usage guide: prerequisites, Option A (local) / Option B (brickhub.dev) installation, variable reference table, what each option includes/excludes, and post-generation steps

### Changed
- Root `README.md` — new "Quick Start (Mason — Recommended)" section added at the top; original manual quick-start retained as "Manual Quick Start"
- `analysis_options.yaml` — added `brick/**` to the analyzer `exclude` list so IDE tools do not try to parse Mustache-syntax template files as Dart

---

## [0.9.1] — 2026-03-03

### Added
- **Locale entries** for all 5 new permission screens in `assets/translations/en-GB.json`:
  - `contacts_permission_screen` — title, message, dialog reAsk title/message
  - `calendar_permission_screen` — title, message, dialog reAsk title/message
  - `bluetooth_permission_screen` — title, message, dialog reAsk title/message
  - `phone_permission_screen` — title, message, dialog reAsk title/message
  - `activity_recognition_permission_screen` — title, message, dialog reAsk title/message
- **30 new `LocaleKeys` constants** manually added to `locale_keys.g.dart` (6 per screen × 5 screens)
- **Translations README** (`assets/translations/README.md`) documenting the key-naming convention, nesting rules, codegen command, manual-update fallback, parameter interpolation, and a per-screen checklist

### Fixed
- All 5 new permission screens were referencing `camera_permission_screen` locale keys as placeholders — updated each screen to use its own correct `LocaleKeys` constant for `title`, `message`, `dialog.reAskTitle`, and `dialog.reAskMessage`

### Changed
- Root `README.md` — Localisation section updated with a link to the new translations README and a note on manual `LocaleKeys` updates when codegen cannot run
- Root `README.md` — Module READMEs table now includes the Translations / Locale Keys entry

---

## [0.9.0] — 2026-03-03

### Added
- **5 new permission types** — Contacts, Calendar, Bluetooth, Phone, Activity Recognition:
  - Abstract methods added to `IPermissionRepository` (check / request / skip × 5)
  - Implementations in `PermissionRepositoryImpl` using `Permission.contacts`, `Permission.calendarFullAccess`, `Permission.bluetooth`, `Permission.phone`, `Permission.activityRecognition`
  - 5 new skip-flags in `PermissionCacheEntity` + manually updated Freezed generated file
  - 15 new BLoC events, 10 new state fields, and 15 new handler methods in `PermissionBloc`
  - Route guards: `ContactsPermissionGuard`, `CalendarPermissionGuard`, `BluetoothPermissionGuard`, `PhonePermissionGuard`, `ActivityRecognitionPermissionGuard`
  - Permission screens: `contacts_permission_screen.dart`, `calendar_permission_screen.dart`, `bluetooth_permission_screen.dart`, `phone_permission_screen.dart`, `activity_recognition_permission_screen.dart`
  - Routes registered in `PermissionRoute` and manually added to `app_router.gr.dart`
  - Path constants added to `AppPaths`
- **Android** `AndroidManifest.xml`: `READ_CONTACTS`, `WRITE_CONTACTS`, `READ_CALENDAR`, `WRITE_CALENDAR`, `BLUETOOTH_SCAN/CONNECT/ADVERTISE` (API 31+), `BLUETOOTH/BLUETOOTH_ADMIN` (maxSdk 30), `READ_PHONE_STATE`, `CALL_PHONE`, `ACTIVITY_RECOGNITION`
- **iOS** `Info.plist`: `NSContactsUsageDescription`, `NSCalendarsFullAccessUsageDescription`, `NSCalendarsUsageDescription`, `NSBluetoothAlwaysUsageDescription`, `NSBluetoothPeripheralUsageDescription`, `NSMotionUsageDescription`, and the previously missing `NSLocationAlwaysAndWhenInUseUsageDescription`

### Changed
- `README.md` expanded: corrected dependency versions, removed erroneous `device_info_plus` requirement, updated file structure to reflect actual paths, added complete iOS/Android config for all 11 permission types, added Podfile macros for new permissions, updated quick-reference table

---

## [0.8.0] — 2026-02-27

### Fixed
- Colour palette corrections across light and dark themes
- Miscellaneous runtime fixes surfaced during sync testing

### Changed
- Sync test pass to verify parity between local and remote branch

---

## [0.7.0] — 2026-02-18

### Added
- Full **Material 3** colour system with primitive and semantic layers
- `MaterialAppTheme` factory that builds `ThemeData` from semantic tokens
- `AppMaterialColors` / `AppMaterialTextStyle` resolvers for Material roles
- Custom `UpdateSettingEvent` in `AppSettingBloc` for functional in-place updates

### Changed
- Colour constants reorganised into `material/` and `custom/` sub-directories
- Theme architecture refactored to keep Material and custom theming cleanly separated

### Fixed
- `ThemeExtension` resolution and `SnackbarHelper` styling corrected

---

## [0.6.0] — 2026-01-28

### Added
- `AppCachedNetworkImage` wrapper with loading / error placeholder support
- `NoLogoWidget` and `AppDefaultImages` for consistent empty-state imagery
- Delete confirmation bottom sheet component
- `SecureStorageService` extended with `clear()` and improved error logging

### Fixed
- `SnackbarHelper` and theme extension resolved correctly for all display modes

---

## [0.5.0] — 2026-01-27

### Added
- **Permission module** (Clean Architecture):
  - `PermissionBloc` with Check / Request / Skip events for Camera, Microphone, Location, Storage, Notification
  - Android 13+ granular media permission handling (`READ_MEDIA_IMAGES`, etc.)
  - Geolocator-based location permission flow
  - `device_info_plus` integration to branch storage logic by SDK version
  - Route guards (`CameraPermissionGuard`, `LocationPermissionGuard`, …) for `auto_route`
  - Custom permission request screens and dialog widgets
- File picker / file selection screen wired to `IFileSelectorHelper`
- Notification permission request integrated into permission module
- iOS `Info.plist` and `Podfile` setup documented

### Changed
- Remaining hard-coded strings replaced with localisation keys

---

## [0.4.0] — 2026-01-22

### Added
- **Notification service** (`NotificationService`) built on `firebase_messaging` + `awesome_notifications`:
  - Foreground, background, and terminated-state handling
  - Two pre-configured Android channels: high importance and progress
  - Global notification toggle (deletes FCM token on disable)
  - Context-aware suppression to silence notifications for the currently open screen
  - Deep-link navigation via payload `redirect_url`
  - `NotificationLogicHelper` and `NotificationDisplayHelper` for separation of concerns
  - Background isolate handler (`firebaseMessagingBackgroundHandler`)
- iOS push notification support (`UNUserNotificationCenter` wiring)

---

## [0.3.0] — 2026-01-21

### Added
- **Logger service** (`AppLogger` / `ILoggerService`):
  - `dart:developer` for debug logs (DevTools only)
  - `logger` package for info / error logs written to daily-rotating local files
  - Periodic background upload of previous-day log files to a configurable endpoint
  - Static helpers `AppLogger.debug()`, `.info()`, `.error()` usable without context
- Service-level logging added to `DioService`, `SecureStorageService`, and `NavigationService`
- **Localisation** (`easy_localization`):
  - `AppLocales` constants and translation JSON assets
  - `LocaleKeys` code-gen via `easy_localization:generate`
  - `LocaleCubit` persisting the chosen locale to `AppSetting`
- **App Settings** feature:
  - `AppSetting` Freezed model with JSON serialisation
  - `AppSettingLocalDataSource` backed by `SharedPreferences`
  - `AppSettingRepositoryImpl` + `IAppSettingRepository` interface
  - `AppSettingBloc` using `ReadCrudMixin` and `UpdateCrudMixin`
  - `ThemeCubit` reading/writing `isDarkMode` from settings
  - Locale and theme mode persisted across app restarts

### Changed
- `DioService` wired with `ConnectivityInterceptor`, `ErrorInterceptor`, and `AuthenticationInterceptor`
- Route observer registered globally via `AppRouteObserver`

---

## [0.2.0] — 2026-01-20

### Added
- **Generic CRUD BLoC framework** (`BaseCrudBloc<Entity>`):
  - Mixin-based capabilities: `ReadCrudMixin`, `CreateCrudMixin`, `UpdateCrudMixin`, `DeleteCrudMixin`
  - `PaginatedCrudMixin` with page/hasMore state
  - `SearchableMixin` for client-side filtering
  - `SelectableMixin` for tracking a selected entity
  - `FilterableCrudMixin` for arbitrary filter state
  - `BaseCrudState` (Freezed) with `entities`, `filteredEntities`, `selectedEntity`, `isLoading`, `error`, `successMessage`
- `PaginationListViewWidget` generic paginated list component
- `SecureStorageDataSource` base for local key-value storage
- `BaseCacheService` in-memory cache abstraction

### Changed
- Size extension renamed and reorganised under `extensions/size/`
- `ErrorWidget` and empty-state widget moved to `widgets/common/`

---

## [0.1.0] — 2026-01-16

### Added
- Project bootstrapped with Clean Architecture folder structure
- **Theme system** (two-layer: primitives → semantics):
  - Custom colour primitives and semantic aliases for light/dark
  - `CustomAppTheme` extension with per-component Freezed theme objects (`AppButtonTheme`, `AppChipTheme`, `AppIconTheme`, `AppPictureTheme`, `AppRadioButtonTheme`, `AppTextFormFieldTheme`)
  - `context.colors`, `context.textStyles`, `context.appTheme` accessor extensions
- **System widget library**:
  - `AppButton` (primary / secondary / text variants)
  - `AppTextWidget` with named text styles
  - `AppTextField` and `AppDropdown` backed by `CustomTextFormFieldWidget`
  - `AppImageWidget` routing asset / network / file sources
  - `AppSvgPictureWidget` SVG renderer
  - `AppChipWidget`, `AppSwitch`, `AppSelectionBox`, `AppDivider`
  - `DefaultAppBar`
  - `AppCircularLoader` and `AppDialogLoader` (blocking overlay)
  - Date range picker and date selector dialogs
- **Context extensions**: snackbar, dialog, size (ScreenUtil wrappers), datetime, currency, validation, text
- `NavigationService` singleton facade over `auto_route`'s `AppRouter`
- `DioService` pre-configured Dio client with proxy and bad-certificate env overrides
- `ApiHandler` static utility returning `Either<Failure, T>` for GET / POST / PUT / DELETE
- `SecureStorageService` with `EncryptedSharedPreferences` on Android
- `AppRouter` with `auto_route` code generation; Cupertino default transitions
- `bootstrap()` initialisation sequence: DI, orientation lock, localization, notifications
- `GlobalBlocProvider` wiring `ThemeCubit` and `LocaleCubit` above `MaterialApp`
- `flutter_gen` asset generation configured in `pubspec.yaml`
- `rps` script shortcuts for build, clean, codegen, analyse, and platform releases
- Splash screen with design component showcase page
- Custom lint rules via `app_custom_lints`

---

## [0.0.1] — 2026-01-08

### Added
- Initial repository created
