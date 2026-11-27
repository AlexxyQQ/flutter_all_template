# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Changed

- Layer boundaries: `core/common/domain/services/**` is now `core/services/<name>/{domain,data,presentation}` (domain folders are pure Dart); the app composition root (bootstrap, DI, router, observers, global providers) moved to `lib/app/`; `core/` no longer imports features; `Failure` and `ResultFuture` live in `core/error/`; `permission` and `app_settings` are regular features under `lib/features/`. See `FOLDER_STRUCTURE.md`.
- All abstract interfaces use the `I` prefix (`ISessionManager`, `IApiClient`, `ISecureStore`, `IPreferencesStore`, `ITokenStore`, `ITokenRefresher`, `IPushTokenRepository`, ...); `ILoggerService` methods are `debug`/`info`/`warning`/`error`; `ResultVoid` was removed in favour of `ResultFuture<void>`.
- Route holders are `<Feature>Routes.route`; generated routes drop `Screen`/`Page`/`Wrapper` (`TodoRoute` shell, `TodoListRoute` screen). `*_widget.dart` files lost the suffix; folders are `repositories` and `views` everywhere.
- Translation keys are semantic (`features.permission.camera.title`, `features.home.title`) instead of mirroring file paths.

### Removed

- Dead code: `AppEnv` log-upload settings, `isProd`/`isDev`, `SingleFlightCache`, `LoadCubit`/`LoadState`, `SelectionCubit`, the model helper classes, `GetTodoUseCase`, `TodoModel.fromEntity`, `clearSkipped`, `AllPermissionsChecked`, `getInt`/`setInt`, notification stream and simple/progress notification helpers, `AppLocales.fromString`/`appLocalesNames`, `LocaleState.isInitialized`, `LocalAnalyticsDestination.readRecent`, the legacy token-key migration, and `NoopAnalyticsService` (now a test helper).

---

## [3.0.0]

### Fixed

- To-do offline cache is account-safe: wiped on logout, and cache writes that finish after sign-out or an account switch are dropped (session identity check). Resolve `ITodoRepository` at start-up so its logout hook is always registered.
- To-do cache is now a bounded (LRU, 20 pages), per-query/per-page copy of the server's answers: offline reads replay exactly what the server returned, mutations patch it, and unreadable cache data is repaired instead of wedging reads and writes.
- `PagedListBloc`: a failed query change no longer leaves the previous query's items and paging position; mutations and list loads are serialized (`serialized`), so a stale refresh can't overwrite a mutation.
- `TodoListBloc`: create/toggle respect the active search and "only open" filter; a failed toggle is restored at its original position.

### Changed

- `flutter_feature` brick now generates the route, wrapper, list screen, widgets and a widget test, registers the route in `AppRouter` and adds the translation keys to `en-GB.json` / `ne-NP.json`.
- Consolidate the todo repository's fetch-and-cache logic and improve AutoRoute navigation across nested stacks.
- Require one class per Dart file, with instance or class members in place of top-level state and helpers.

### Added

- Reusable popup dialogs and bottom sheets with typed results.
- Per-user analytics with an encrypted local store and optional Firebase and custom API destinations.
- Hive CE storage with authenticated encryption and keys held in platform secure storage.

## [0.0.1] — 2026--11-26

### Added

- Initial repository created
