# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [3.0.0] — 2026-11-26

Barebones release. **Breaking** for anything generated from 2.x.

### Removed
- The custom UI component library and the custom theme system (`lib/config/themes`, colour/text
  constants, `ThemeCubit`, text-field/dialog/bottom-sheet widgets, form controllers and
  validation extensions). The app is plain Material 3 with the default `ThemeData`.
- The `gallery` feature and its route; fonts (SF Pro, Anton), Lottie, video and onboarding
  assets; and unused dependencies (`nested`, `connectivity_plus`,
  `jwt_decoder`, `app_settings`, `collection`, `intl`, `path_provider`, `cupertino_icons`).
- Internal planning docs (`TODO.md`, `docs/TEMPLATE_AUDIT_AND_PLAN.md`,
  `docs/REFACTOR_CONTRACTS.md`), `devtools_options.yaml`, unused translation namespaces
  (form fields, calendar, currencies) and the GitHub `security` job with gitleaks.

### Added
- Dependencies are injected through named, `required` constructor parameters everywhere (repositories, data sources, use cases, blocs/cubits, services, interceptors, stores, clients); `RULES.md` §2 documents the rule and the feature brick generates the same style.
- Real Firebase config (`google-services.json`, `GoogleService-Info.plist`, `firebase.json`,
  `firebase_options.dart`) is now git-ignored; `*.example` placeholders are tracked instead.
  `rps firebase:init` / `scripts/firebase_init.sh` creates the real files without overwriting,
  CI and Codemagic run it (Codemagic also decodes optional `FIREBASE_*_BASE64` secrets),
  `scripts/release.sh` refuses a placeholder `google-services.json`, and generated projects
  ship the examples. `.gitignore` also covers signing keys/certificates, service-account JSON,
  `.firebaserc` and local tool state.
- Screens are now splash, home and a Todo list (`features/example`) built with plain
  Material widgets; the permission feature is kept.
- CI/CD redesign (free-tier safe): lean Linux-only PR CI, weekly OSV scan,
  `scripts/release.sh` (local Android build uploaded to a GitHub Release), `codemagic.yaml`
  for manual iOS builds, and `docs/CI_CD.md`.
- Maestro end-to-end flows (`.maestro/`, `scripts/maestro.sh`, `rps maestro`,
  `docs/MAESTRO.md`).

### Changed
- Mason bricks are minimal: the project brick asks for `app_name`, `app_org` and the
  optional `use_firebase`, `use_notifications`, `use_permissions` modules, and ships the CI,
  Codemagic, release script, Maestro flows and docs with the app name and bundle ids
  rewritten. Brick tooling, the changelog and the brick-sync CI step are not shipped. Hook
  `pubspec.lock` files are no longer tracked.
- `flutter_feature` documentation and hook output no longer reference removed widgets.
- README, FOLDER_STRUCTURE and SECURITY rewritten to match the code and CI.

---

## [2.0.0] — 2026-11-26

A security- and architecture-focused rewrite. **Breaking** for anything generated from 1.x: see the migration notes.

### Security
- Removed the committed Google API key text from `TODO.md` (**the key must still be revoked/rotated and git history rewritten — see `SECURITY.md`**).
- Deleted the trust-all-certificates `MyHttpOverrides`; debug-only proxy/self-signed trust is now scoped to the API host and ignored in release builds.
- Bearer tokens are attached only to requests for the API host; added single-flight token refresh that signs the user out when refresh fails.
- Tokens moved out of the settings blob into a dedicated `TokenStore` on secure storage; preferences live in `PreferencesStore`.
- Logger redacts tokens/credentials; stored values, FCM tokens and route arguments are never logged; periodic remote log upload and file logging removed.
- Push-notification `redirect_url` is validated against an allow-list; permission screens only accept typed routes.
- Android: release signing from `key.properties`, R8 shrinking, `allowBackup=false`, no cleartext, dropped unused dangerous permissions. iOS: generic purpose strings, no "Always" location.
- `env/` is no longer bundled as an asset; configuration comes from `--dart-define-from-file=env/<flavor>.json` (`AppEnv`). Added CI secret scanning (gitleaks), OSV scanning and Dependabot.

### Fixed
- Example feature deleted/updated **every** row (`(id) => id == id`), its repository was never registered in DI, delete used `POST`.
- `204`/`201` responses were reported as failures; server error bodies never reached callers.
- Pagination off-by-one, ignored cursors, concurrent page loads and data loss on search failure.
- `skip` on a permission was treated as *granted*; `MaterialApp` was rebuilt (losing navigation state) on every locale change.
- 7 failing tests, 24 analyzer warnings, 7 undeclared dependencies, and unused `uuid`.

### Changed
- **Architecture:** `Failure` is pure Dart; data sources throw a sealed `AppException`, repositories convert once with `guard()`; constructor injection replaces service-locator lookups; `ApiClient` interface replaces the static `ApiHandler`.
- **CRUD:** the 25-field `BaseCrudBloc` + 8 mixins are replaced by `LoadState`/`LoadCubit`, `PagedListBloc` (page + cursor, `bloc_concurrency`) and `SelectionCubit`. `ISecureStorageDataSource` is replaced by `JsonCollectionStore`.
- **Permissions:** 10 screens + 10 guards + 30 events collapsed into one config-driven `PermissionScreen`/`PermissionGuard`/`PermissionBloc`.
- **Theming:** one Material 3 `ColorScheme` + `AppTokens` extension; the parallel custom theme system and `AppMaterialColors` globals are removed. `AppButton` variants share one implementation.
- Example feature rewritten as a small Todo slice; `feature_brick` regenerated from it.
- Flutter pinned to 3.44.1; dependencies refreshed within their constraints; stricter analysis (`strict-casts/inference/raw-types`, async-safety lints); generated code is no longer committed.

### Added
- `bricks/project_brick` is now **generated** from the repository by `tool/sync_brick.dart` (CI fails if stale); it renders into `<app_name>/`, moves `MainActivity.kt`, sets the iOS bundle id, and was verified by generating, analyzing and testing three module combinations.
- Dev/staging/prod flavors, CI workflow, `SECURITY.md`, `docs/FLAVORS.md`, `docs/CODE_SIGNING.md`, `docs/PLATFORM_SETUP.md`.
- DI smoke test, ~270 tests (network, storage, session, permissions, notifications, paging, widgets).

### Removed
- `flutter_dotenv`, `features/another`, `notification_no_logger.zip`, compiled Mason hook binaries and machine-specific Mason state from git.

### Migration notes
- Replace `ApiHandler.*` with an injected `ApiClient` and `guard()`; replace `AppSettingBloc`/`AppSetting` with `IAppPreferencesRepository` + `SessionManager`.
- Replace `BaseCrudBloc` mixins with `PagedListBloc`/`LoadCubit`; move request params to `domain/params/`.
- Create `env/<flavor>.json` from the `*.example.json` files and run with `--dart-define-from-file`.
- Run `rps gen` after checkout: generated files are git-ignored.

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
