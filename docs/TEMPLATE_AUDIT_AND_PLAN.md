# Flutter All Template — Audit & Modernisation Plan

> Audit date: 2026-11-25 · Commit audited: `f7db2c9` (branch `main`)
> Toolchain used for verification: Flutter 3.44.1 (repo pins 3.38.5 via `.fvmrc`)

This document is a full review of the template: what it is, what is wrong with it
(security, correctness, SOLID/DRY/clean-code, tooling), and a phased plan to fix it.
Every finding cites a file and line so it can be turned directly into an issue.

---

## 0. Executive summary

The template has a solid *intent* — Clean Architecture folders, BLoC, injectable DI,
auto_route, Freezed, Mason bricks, i18n, theming — and a lot of useful widgets. But the
implementation has drifted into a state where:

1. **There is a live secret in the current tree** (a Google API key in `TODO.md`), and
   several patterns that would create vulnerabilities in any app generated from the
   template (trust-all TLS override, bearer token sent to any host, secrets written to
   logs that are then uploaded, push-payload-driven navigation, debug-signed release
   builds, every dangerous Android permission declared).
2. **The reference feature that the Mason brick copies is broken** (`(id) => id == id`
   predicates delete/update *every* row; the repository is never registered in DI so the
   BLoC can't even be constructed).
3. **SOLID/DRY are violated at the core**: a static `ApiHandler` reached through a global
   service locator (153 `sl<…>` calls in 37 files), a 25-field "god state" shared by every
   CRUD bloc, 10 copy-pasted permission screens + 10 copy-pasted guards + 30 near-identical
   bloc handlers, two parallel theme systems, and a Mason "project brick" that is a
   hand-maintained copy of the entire repo (327 files, 11 already drifted).
4. **Quality gates are red**: `flutter analyze` → 121 issues (24 warnings); `flutter test`
   → 40 passed / **7 failed**; 24 direct dependencies behind; 8 packages imported but not
   declared in `pubspec.yaml`; no CI.

### Health scorecard

| Area | Status | Evidence |
|---|---|---|
| Secrets hygiene | 🔴 Critical | API key in `TODO.md:29`; real Firebase project/app IDs in `firebase.json` |
| Network security | 🔴 High | `MyHttpOverrides` trusts all certs; token attached to any host; TLS bypass via dart-define |
| Data-at-rest / logging | 🔴 High | Secure-storage values logged; logs persisted & auto-uploaded; FCM token logged |
| Correctness | 🔴 High | Example data source mutates all rows; DI graph incomplete; bloc handlers never finish |
| Architecture (SOLID) | 🟠 Poor | Service locator everywhere, domain→data/presentation leaks, god state, ISP violations |
| DRY | 🟠 Poor | ~2,200 lines of copy-paste in permissions alone; whole-repo copy in brick |
| Tooling / CI | 🟠 Poor | No CI, broken rps scripts, Shorebird pinned to wrong Flutter, `.dill` binaries committed |
| Tests | 🟠 Poor | 7/47 failing, one test file has no `main`, no repo/network/widget-screen coverage |
| Dependencies | 🟡 Stale | 24 direct deps outdated (several majors), git dep on moving `main` |
| Docs | 🟡 Drifted | README references files that don't exist (`env/.env.example`, `scripts/`) |

---

## 1. What the template is today (inventory)

```
lib/
├── main.dart                     # entry; loads env/example.env, Firebase, notifications
├── config/                       # constants (api, colors, text, paths, enums), themes, firebase_options
├── core/
│   ├── app.dart, bootstrap.dart  # MaterialApp.router + runZonedGuarded bootstrap
│   ├── abstract/                 # abstract colour/text-style contracts (2 parallel systems)
│   ├── common/
│   │   ├── data/models/helpers   # JSON converters, Either extensions, UUID helper
│   │   ├── domain/entities       # Failure (Freezed), FilterParams
│   │   ├── domain/services       # network(Dio+ApiHandler), logger(+upload), storage, notification, navigation
│   │   ├── features/app_settings # settings + tokens persisted in secure storage
│   │   ├── features/permission   # 10 screens, 10 guards, 1 x 645-line bloc
│   │   ├── locator/              # get_it + injectable
│   │   └── presentation/         # cubits (theme/locale), routes, extensions, widgets, dialogs
│   └── generic/                  # BaseCrudBloc + 8 mixins, SecureStorageDataSource<T>, BaseCacheService
└── features/
    ├── example/                  # reference CRUD slice (copied by feature_brick)
    ├── splash/                   # splash = design-components showcase
    └── another/                  # unrouted demo cubit (dead code)
bricks/
├── feature_brick/                # Mason brick for a feature slice
└── project_brick/                # Mason brick = full manual copy of the repo (327 files)
```

Key numbers: ~34.7k lines in `lib/` (incl. 52 committed generated files), 153 `sl<…>` /
`GetIt` look-ups in 37 files, 32 event handlers in `PermissionBloc`.

### Things worth keeping
- Feature-first Clean Architecture folder layout and the `I*Repository` interfaces.
- `Either<Failure, T>` result style (`ResultFuture<T>`), Freezed models, injectable.
- `NotificationService` split into display/logic helpers with injectable dependencies (good testability start).
- Design-system widgets (`AppButton`, `AppText`, text fields, image widgets) and semantic colour tokens.
- `analysis_options.yaml` already enables a strong rule set (`require_trailing_commas`, `prefer_final_locals`, `cancel_subscriptions`, …).
- Existing BLoC/cache/storage unit tests (a base to grow from).
- Mason bricks as the distribution idea.

---

## 2. Verified baseline (commands actually run)

| Command | Result |
|---|---|
| `flutter pub get` | OK; 161 packages have newer versions outside constraints |
| `flutter analyze` | **121 issues** — 0 errors, **24 warnings**, 97 infos |
| `flutter test` | **40 passed, 7 failed** |
| `dart pub outdated` | 24 direct dependencies behind (majors: `firebase_core 5`, `firebase_messaging 17`, `flutter_secure_storage 11`, `permission_handler 13`, `injectable 3`, `equatable 3`, `file_picker 13`, `upgrader 14`, `app_settings 9`, `calendar_date_picker2 4`, `awesome_notifications 0.12`, `cached_network_image 4`) |

**Analyzer warnings (highlights)**: unused imports (`bootstrap.dart:7`, `example_local_data_source.dart:2,6,7`),
11× `dead_null_aware_expression` in `example_local_data_source.dart:28-56`, unused fields
(`notification_service.dart:49`, `permission_cache_service.dart:14`, `example_repository_impl.dart:18`),
unused variable `logger_service.dart:107`, dead code `custom_text_form_field_widget.dart:152`,
non-const `IconData` args (`model_annotation_helper.dart:70-72` — breaks icon tree-shaking),
8× `avoid_print`, 5× deprecated APIs (`withOpacity`, `encryptedSharedPreferences`).

**Failing tests**:
1. `notification_service_test.dart` — file is 1 line, no `main` → load failure.
2. `BaseSingleCacheService … Should propagate error and clean up loading state`.
3. `ISecureStorageDataSource … create returns Failure if item already exists`.
4. `ISecureStorageDataSource … updateWhere updates the correct item` (expected `true`, got `TestUser`).
5-7. `PaginationListView` — retry tap, load-more tap, pull-to-refresh.

**Packages imported but not declared in `pubspec.yaml`** (work only by transitive luck):
`bloc`, `collection`, `freezed_annotation`, `intl`, `path_provider`, `shared_preferences`, `uuid`.

---

## 3. Security findings (ranked)

Severity: **C** critical · **H** high · **M** medium · **L** low.

| # | Sev | Finding | Location | Why it matters | Fix |
|---|---|---|---|---|---|
| S1 | **C** | Real Google/Firebase iOS API key printed in plain text in the TODO that tells you to rotate it | `TODO.md:29` (present in all 5 commits) | Anyone with repo access can abuse the key; history rewrite alone won't help while it's in HEAD | Revoke/rotate key in GCP now; delete it from `TODO.md`; rewrite history with `git filter-repo --replace-text`; add key restrictions + App Check |
| S2 | **C** | `MyHttpOverrides` accepts **every** TLS certificate and is registered in DI | `network/interceptor/http_override.dart:6-11`, exported from `interceptor_exports.dart:10` | One `HttpOverrides.global = sl<MyHttpOverrides>()` and the app is MITM-able; template users will copy it | Delete the class. If needed for local dev, gate behind `kDebugMode && assert` and a self-signed CA pin, never in DI |
| S3 | **H** | TLS bypass and proxy controllable via `--dart-define=ALLOW_HTTP` / `PROXY`, with no build-mode guard | `dio_service.dart:31-47` | A misconfigured release pipeline ships a client that trusts any cert. Name `ALLOW_HTTP` is misleading (it disables cert validation) | Only honour in `kDebugMode`; rename to `DEV_TRUST_SELF_SIGNED`; add certificate pinning option for prod |
| S4 | **H** | Bearer token is attached to **every** request, including absolute URLs to other hosts | `authentication_interceptor.dart:19-23`; triggered by `logger_service.dart:107-108` posting to `https://your-server.com/...` via the same Dio | Token leaks to any third-party/CDN/log endpoint called through `ApiHandler` | Attach only when `options.uri.host` ∈ allowlist (API host); use a separate Dio for third parties |
| S5 | **H** | Secure-storage **values** (tokens) are logged, and error logs go to a file that is auto-uploaded | `secure_storage_service.dart:35,39`; `logger_service.dart:29-31,84-89`; `file_log_output_service.dart` | Tokens/refresh tokens end up in plaintext log files and on a remote server | Never log values; add a redaction layer; make upload opt-in, encrypted, and only for sanitized error events (or replace with Crashlytics/Sentry) |
| S6 | **H** | FCM token logged at info level | `notification_logic_helper.dart:40` | Same file→upload path as S5 | Remove or hash |
| S7 | **H** | Route **arguments** logged on every navigation | `config/observers/route_observer.dart:372,401` (`_showArgs = true`) | Arguments routinely carry IDs, emails, tokens | Default `false`; log route names only; redact |
| S8 | **H** | Push payload `redirect_url` is navigated to without validation | `notification_logic_helper.dart:130-141` | Any party able to send a push (compromised backend, leaked server key) can drive the app to any route, incl. internal/debug screens | Map payload `type` → allowlisted typed routes; reject unknown; require auth guard on targets |
| S9 | **H** | Permission screens navigate to an arbitrary string `next` (`pushNamed(widget.next!)`) | `camera_permission_screen.dart:95` (and 9 siblings) | Open-redirect inside the app via deep links/route params | Accept only `PageRouteInfo` (typed) or an allowlisted enum |
| S10 | **H** | Release build signed with the **debug** key; no R8/minify/obfuscation | `android/app/build.gradle.kts` `release { signingConfig = debug }` | Generated apps are uploadable only by accident and trivially re-signed; no shrinking | Add `key.properties`-based signing config, `isMinifyEnabled`, `isShrinkResources`, `--obfuscate --split-debug-info` in build scripts |
| S11 | **H** | Every dangerous permission declared (contacts R/W, calendar R/W, `CALL_PHONE`, `READ_PHONE_STATE`, activity recognition, BT, location, mic, camera, media) | `android/app/src/main/AndroidManifest.xml`; iOS `Info.plist:49-89` incl. "Always" location with "track rides" text | Play/App Store rejection; over-privilege for every generated app | Ship **none** by default; add per-module via brick flags; generic purpose strings |
| S12 | **M** | `android:allowBackup` not set (defaults to `true`), no `dataExtractionRules` | `AndroidManifest.xml` `<application>` | Shared prefs, log files (with S5 content), caches are included in cloud/ADB backups | `allowBackup="false"` or explicit extraction rules excluding logs/prefs |
| S13 | **M** | Whole `env/` folder is bundled as a Flutter **asset**; app loads `example.env` | `pubspec.yaml:127`; `main.dart:14`; `api_constants.dart:4` | Anything ever put in `env/.env` ships inside the APK/IPA in clear text; real `.env` is never actually used | Use `--dart-define-from-file=env/<flavor>.json`; never treat client config as secret; remove `env/` from assets |
| S14 | **M** | Auth tokens stored inside the same JSON blob as theme/locale/onboarding, cached in memory for 5 min, alongside `dynamic loggedUser` | `app_setting.dart:15-23`; `app_setting_cache.dart:13` | Every theme change rewrites tokens; any code that logs/serialises settings leaks tokens; logout path resets theme too | Separate `TokenStore` (secure storage, its own keys) from `PreferencesStore` (shared_preferences) |
| S15 | **M** | Logout doesn't revoke FCM token, clear caches/other storage, or cancel uploads | `app_setting_repository_impl.dart:56-85` | Next user on the device receives previous user's pushes; stale data | Central `SessionManager.logout()` orchestrating all of it |
| S16 | **M** | Dev dependency pulled from a git **branch** (`ref: main`) and `nested: any` | `pubspec.yaml:31,111-114` | Supply-chain: unpinned code executes in your analyzer/build | Pin to a tag/commit SHA; replace `any` with a range (or drop `nested`, it's transitive via `flutter_bloc`) |
| S17 | **M** | Raw exception text surfaced as user-facing error messages | `dio_service.dart:242-243`; `secure_storage_data_source.dart:109,124,158,…` | Leaks internals (paths, keys, stack details) to UI/telemetry | Map to typed failures + localized message keys; keep details in logs only (redacted) |
| S18 | **L** | Real Firebase project ID / app IDs committed | `firebase.json` | Not secret per se, but identifies your project; contradicts the "placeholders" intent | Replace with placeholders or git-ignore and document `flutterfire configure` |
| S19 | **L** | Compiled Mason hook `.dill` binaries committed; they embed your local paths (`/home/metacloud-aayush/...`) | `bricks/*/hooks/build/**/*.dill`; also `.mason/bricks.json`, `mason-lock.json` absolute paths | Info disclosure + non-reproducible | Git-ignore `hooks/build/`, `.mason/`; commit relative `mason-lock.json` only |
| S20 | **L** | `encryptedSharedPreferences: true` is deprecated in `flutter_secure_storage` 10 | `secure_storage_service.dart:14` | Will be removed in v11 | Drop the option; upgrade to 11 with migration notes |
| S21 | **L** | Name validator only accepts ASCII `[a-zA-Z\s]` while the app ships `ne-NP` | `form_validator_extension.dart:208` | Rejects legitimate names (Devanagari, accents) | Use `\p{L}` with `unicode: true` or don't regex names |

---

## 4. Correctness bugs

| # | Bug | Location | Effect |
|---|---|---|---|
| B1 | Predicates shadow the outer `id`: `where: (id) => id == id` | `example_local_data_source.dart:81,87,102` | `deleteExample` deletes **all** rows, `getExample` returns the first row, `updateExample` updates the first row. The feature brick copies this pattern |
| B2 | `deleteExample` then `r.first` on a now-empty list | `example_local_data_source.dart:82` | Throws `StateError` |
| B3 | `ExampleRepositoryImpl` has no `@LazySingleton(as: IExampleRepository)` | `example_repository_impl.dart:11`; DI config never registers `IExampleRepository` | `sl<ExampleBloc>()` throws at runtime |
| B4 | Remote delete uses `POST` | `example_remote_data_source.dart:26` | Wrong HTTP verb in the reference implementation |
| B5 | Success detection `statusCode == successCode \|\| statusMessage == 'OK'` | `dio_service.dart:189-190` | A successful `204 No Content` DELETE or `201` PUT is reported as a failure; HTTP/2 often has empty status message |
| B6 | `onError` result is computed then discarded in the `DioException` branch | `dio_service.dart:231-232` | Custom server-error parsing never reaches the caller |
| B7 | `async void` bloc handlers; `_updateSetting` sets `isLoading: true` and **never emits completion**, returns an `Either` nobody reads | `app_setting_bloc.dart:54-69,71-86` | UI stuck loading; `emit` after handler completes → bloc assertion |
| B8 | `ThemeCubit.getSavedTheme`, `_updateState`, `LocaleCubit._updateState`, `getSavedLocale` are `void … async` | `theme_cubit.dart`, `locale_cubit.dart` | Errors are unobservable; restoring a locale re-persists it (write on read) |
| B9 | `isLocalSearchMatch` throws `UnimplementedError` in the reference bloc; `createMultipleEntity`, `readMultipleEntity` (AppSetting) also throw | `example_bloc.dart:101-104,43-48`; `app_setting_bloc.dart:47-50` | Dispatching a standard event crashes |
| B10 | Pagination: page starts at `1` in the mixin but defaults to `0` in the example; `hasReachedEnd` compares to `filters.limit` instead of the requested `limit`; `nextToken` is never passed to `paginatedRead`; `applyPaginatedRead` ignores its `page/limit/nextToken` args | `example_bloc.dart:69,74`; `paginated_crud_mixin.dart:43-47,85-89,125-132` | Off-by-one pages, early/late "end reached", cursor pagination impossible |
| B11 | `RefreshPaginationEvent` handler calls `add()` from inside a handler | `paginated_crud_mixin.dart:21` | Race with other events; non-deterministic in tests |
| B12 | No event transformers: search is not debounced or restartable; pagination events run concurrently | `searchable_mixin.dart`, `paginated_crud_mixin.dart` | Out-of-order search results; duplicate page loads |
| B13 | `SearchEvent` failure wipes `entities: []`; success doesn't update `filteredEntities` | `searchable_mixin.dart:56-60` | Data loss on transient error; UI bound to `filteredEntities` never updates |
| B14 | `getEntityId` = `entity.hashCode` for AppSetting | `app_setting_bloc.dart:30-32` | IDs change whenever content changes |
| B15 | Skipping location permission sets status to **granted** | `permission_bloc.dart` `_onCheckLocationPermission` | Guards believe permission exists; geolocator calls then fail |
| B16 | `NotificationService.initialize()` called twice | `main.dart:18` and `bootstrap.dart:36` | Redundant; masks ordering bugs |
| B17 | `startPeriodicUpload()` invoked inside `App.build` | `app.dart:22` | Re-armed on every rebuild; network calls on startup to a placeholder host |
| B18 | `MaterialApp.router` keyed by locale | `app.dart:49-51` | Locale change destroys the router and loses navigation stack/state |
| B19 | Global zone error handler only prints in debug, swallows in release; `FlutterError.onError` / `PlatformDispatcher.onError` not set | `bootstrap.dart:51-55` | Production crashes are invisible |
| B20 | `FileLogOutput.output` is `async void` writing line-by-line; date fixed at init | `file_log_output_service.dart:32-44` | Interleaved/lost log lines; no daily rotation; unbounded growth |
| B21 | `ISecureStorageDataSource._editList` is read-modify-write with no lock | `secure_storage_data_source.dart:56-126` | Concurrent writes lose data |
| B22 | Model `fromJson` silently invents a UUID when `id` is missing | `example_model.dart:18`; `ModelGeneratorHelper.generateUuidFromJson` | Hides backend contract bugs; produces phantom entities |
| B23 | `SelectInGroup*Event.props` omit `key` | `selectable_mixin.dart:126,134` | Equal events for different groups get deduplicated |
| B24 | `toggleNotifications(false)` calls `cancelNotification(-1)` hack + `cancelAll` | `notification_service.dart:84-87` | Undefined behaviour on some platforms |
| B25 | `ConnectivityInterceptor` rejects when `ConnectivityResult.none`, but reachability ≠ connectivity | `connectivity_interceptor.dart` | False negatives on captive portals/VPN; consider letting Dio fail and map error instead |
| B26 | `LocaleConverter.toJson` drops country code, `fromJson` splits on `_` | `model_annotation_helper.dart:86-103` | `en-GB` vs `en-US` can't round-trip |
| B27 | Leftover debug output/profanity | `permission_repository_impl.dart:458` (`print('assshole: $e')`), `permission_bloc.dart` (`'aaa sss: …'`) | Unprofessional, leaks errors to stdout |
| B28 | `setFcm` always throws `UnimplementedError` (commented-out Supabase code) but is called after every notification grant | `permission_repository_impl.dart:441-460` | Every grant path logs an error; dead vendor code |

---

## 5. SOLID violations

### S — Single Responsibility
- **`AppLogger`** (`logger_service.dart`) logs, writes files, schedules timers, builds multipart forms and uploads via `ApiHandler`. Split into `Logger` (facade) → `LogSink`s (console, file, crash reporter) and a separate opt-in `LogUploader`.
- **`ApiHandler`** builds requests, decides success, parses bodies, logs, and maps errors. Split into `ApiClient` (transport) + `ResponseDecoder` + `ErrorMapper`.
- **`PermissionRepositoryImpl`** checks OS permissions **and** registers FCM tokens with a backend (`setFcm`) **and** talks to `NotificationService.instance`. Move token registration to a `PushTokenRepository`.
- **`AppSetting`** model mixes preferences, onboarding, session tokens and the logged-in user.
- **`ThemeCubit`** resolves brightness, mutates a static global (`AppMaterialColors.load`), persists, and observes the platform.

### O — Open/Closed
- Adding a permission requires editing: `AppPaths`, `PermissionState` (2 fields), `PermissionEvent` (3 classes), `PermissionBloc` (3 handlers + 3 registrations), repository (2 methods), a new 160-line screen, a new guard, the route list, translation keys. Replace with an `AppPermission` enum + `PermissionSpec` table; adding one becomes a one-line config change.
- `ErrorInterceptor` hard-codes status mapping in a `switch`; prefer a `Map<int, String>` / strategy injected per app.

### L — Liskov
- `AppSettingBloc` and `ExampleBloc` extend `BaseCrudBloc` + mixins but throw `UnimplementedError` for contract methods (`readMultipleEntity`, `createMultipleEntity`, `isLocalSearchMatch`). A subtype that throws for inherited behaviour is not substitutable.
- `ISecureStorageDataSource.get()` returns `Left` for "no data yet", which callers treat as an error, while `getAll()` returns `Right([])` — inconsistent semantics within the same type.

### I — Interface Segregation
- `BaseCrudState<T>` has 25 fields (pagination, tokens, grouping, selection, search, filters) that every bloc inherits even if it only reads one object (AppSetting).
- `ReadCrudMixin` forces both `readEntity` and `readMultipleEntity`.
- `ILoggerService` forces upload methods on every logger (see `SafeLogger` no-op stubs).
- `NavigationService` exposes 15 methods incl. `pushWidget(BuildContext…)` that bypasses the router.

### D — Dependency Inversion
- Global `sl<…>()` look-ups inside constructors and methods (153 sites): `DioService()` pulls interceptors from `sl`, `AppSettingLocalDataSource()` pulls `SecureStorageService` from `sl`, repositories call `sl<AppSettingCache>()`, cubits call `sl<IAppSettingRepository>()`, screens call `sl<NavigationService>()`. Dependencies are hidden, untestable, and create hidden cycles (`AppSettingCache → IAppSettingRepository → sl<AppSettingCache>`; `AppLogger → ApiHandler → DioService → AppLogger`).
- `ApiHandler` is **static** — data sources can't receive a fake client.
- `NotificationService.instance` / `NavigationService._instance` are hand-rolled singletons living beside DI.
- **Layer leaks** (Clean Architecture dependency rule):
  - Domain `Failure` imports `auto_route` (`PageRouteInfo navigateRoute`) and `dio` (`failure.dart:1-2,16,19`).
  - Domain `ExampleRequestParams` imports data models (`example_request_params.dart:5-8`).
  - Domain `IAppSettingRepository` returns the data-layer `AppSetting` model.
  - Network service lives under `domain/services/network` but is infrastructure.
  - BLoCs translate strings (`.tr()` in `create_mixin.dart:32` etc.) — presentation concerns in state management.
  - Create/Update events carry raw `Map<String, dynamic>` from UI straight to repositories (no typed params, no validation, mass-assignment risk).

---

## 6. DRY violations (largest first)

| Duplication | Size | Consolidation |
|---|---|---|
| `bricks/project_brick/__brick__` is a manual copy of the repo | 327 files, 11 already drifted (`bootstrap.dart`, `main.dart`, `pubspec.yaml`, `secure_storage_data_source.dart`, routers, generated files…) | Generate the brick from the repo with a script (`tool/sync_brick.dart`) that injects mustache conditionals; CI fails on drift |
| 10 permission screens | ~1,650 lines (diffs differ only in names/keys/events) | One `PermissionScreen(spec: PermissionSpec)` |
| 10 permission guards | 563 lines | One `PermissionGuard(AppPermission)` |
| 30 permission events + 30 handlers + 20 state fields | ~700 lines | `Check/Request/Skip(AppPermission)` + `Map<AppPermission, PermissionStatus>` |
| `ApiHandler.get/post/put/delete` | 4×30 lines | Single `request<T>(method, …)`; verbs are thin wrappers |
| `getAll`/`getAllWhere`/`get`/`getWhere` read+decode blocks | 4× | Private `_readList()` |
| Example model ↔ entity ↔ params mappers (3 near-identical field lists × 6 directions) | ~400 lines | Remove `RequestParams` duplication of the model; use entity → model mapper once; consider `mappable`/codegen |
| `AppButton.primary/secondary/tertiary/stroke…` factories with identical param lists | ~200 lines | `AppButton(variant: ButtonVariant.primary, …)` + one factory |
| Two theming systems (`custom_*` vs `material_*` colours, text styles, abstracts, `custom_app_theme.dart` unused) | ~700 lines | Keep one: Material 3 `ColorScheme` + a `ThemeExtension<AppTokens>` |
| `AppMaterialColors` static getters mirroring every semantic colour | 93 lines | Read from `Theme.of(context).extension<AppTokens>()` |
| Loading/emit boilerplate in every CRUD mixin (`emit(loading) → await → fold → emit`) | 8 mixins | One `_run<T>(emit, future, onSuccess)` helper |
| Logging try/catch boilerplate in `SecureStorageService` | 4× | Single `_guard(op, fn)` |
| `notification_no_logger.zip` inside `lib/` | 30 KB archive of an old copy | Delete (git history has it) |

---

## 7. Clean-code issues

- **Naming**: `ISecureStorageDataSource` is a concrete base class, not an interface; `app_swtich.dart`, `app_text_filed.dart`, `text_form_filed_enum.dart`, `color_hsl_manuplation_extension.dart`, `base_case_service_test.dart` (typos); `permission.wrapper.dart` (dot naming); `SplashScreen` that is actually a component gallery; `features/another` with `TestCubit`.
- **Dead code / leftovers**: `token_interceptor.dart` fully commented; `features/another` unrouted; `custom_app_theme.dart` unused; `MyHttpOverrides`; Supabase comments in `setFcm`; `LoadMoreEvent`, `isLoadingMore`, `hasReachedStart` unused; `successMessage` param in `ApiHandler` unused; `_OverlayRoutes` commented feature routes; Shorebird patch commands commented.
- **Types**: pervasive `dynamic` (`id`, `loggedUser`, `Failure.fromException(dynamic)`), `Function(AppSetting)` without return type, `Future<Null>` in `bootstrap.dart:16`, `Map<String, dynamic>` fields in domain entities, private import `package:fpdart/src/either.dart`.
- **Side effects in build/constructors**: `App.build` starts timers; `ThemeCubit` constructor registers a `WidgetsBinding` observer and mutates globals; `DioService` constructor resolves from `sl`.
- **Hard-coded values**: `'https://your-server.com/api/logs/upload'`, `'unique_device_id_here'`, design size `428×926`, 30 s timeouts, `'th_'` prefix logic, portrait-only lock in bootstrap.
- **Error handling style**: data sources return `Either` *and* log *and* catch everything; repositories then re-wrap. Pick one: data sources **throw typed exceptions**, repositories **convert once** to `Failure`.
- **Comments as code**: 100-line doc examples inside production files (`dio_service.dart:64-162`), `<-- Added client parameter` change-log comments, emoji log noise.
- **File-path handling**: `file.path.split('/')` (`logger_service.dart:99`) breaks on Windows; `listSync` on the UI isolate.
- **Generated code policy is inconsistent**: 52 generated files committed, but `analysis_options` excludes only `*.g.dart`; `lib/localization/**` exclusions point to a non-existent folder.

---

## 8. Tooling, build & platform issues

- **No CI** (`.github/` absent): nothing runs analyze/test/format; failing tests went unnoticed.
- `pubspec.yaml` `scripts:`
  - `exports` calls `scripts/generate_exports.dart` and `scripts/fix_import.dart` — **folder does not exist**; uses Windows `\` paths.
  - `imports` uses `import_sorter`, `icons` uses `splash_master`/`icons_launcher` — **not declared** as dev dependencies.
  - Shorebird release pins `--flutter-version 3.35.4` while `.fvmrc` is `3.38.5`; iOS release uses `--artifact apk`.
  - Every build script runs `flutter clean` (slow, defeats caching).
- `analyzer.plugins: custom_lint` + `custom_lint_builder` but no `custom_lint` package in dev deps; custom lints pulled from git `main`.
- `analysis_options`: missing `strict-casts`, `strict-inference`, `strict-raw-types`; `invalid_annotation_target: ignore` hides real mistakes; no `unawaited_futures`/`discarded_futures`/`avoid_dynamic_calls`/`avoid_void_async` (which would catch B7/B8/B20).
- `.vscode/launch.json` forces `--no-enable-impeller` for the default config.
- `.claude/settings.local.json` committed (local tool config).
- `android/gradle.properties` requests `-Xmx8G` heap (fails on smaller CI runners).
- No flavors (dev/staging/prod), no per-flavor Firebase, bundle ID still `com.alexxy.flutter_all_template` with TODO.
- iOS `UIBackgroundModes` declared without need; `NSLocalNetworkUsageDescription` text is wrong ("Used for local notifications").
- Web/desktop platforms aren't tracked but `rps build:web/windows/...` scripts exist; `firebase_options` throws on those platforms.

---

## 9. Testing gaps

- 7 failing tests, 1 empty test file.
- No tests for: `ApiHandler`/interceptors, any repository, `AppSettingBloc`, `PermissionBloc`, `NotificationService` logic, theme/locale cubits, router guards, any screen.
- Tests use `easy_localization` without loading translations → warnings and brittle string expectations.
- No golden tests, no integration tests, no coverage reporting.
- Mock generation (`*.mocks.dart`) committed; consider `mocktail` (no codegen) for a template.

---

## 10. Target architecture

```
lib/
├── app/                         # composition root: bootstrap, App widget, router, DI modules, flavors
│   ├── bootstrap.dart           # error zones, FlutterError/PlatformDispatcher handlers, Bloc observer
│   ├── di/                      # injectable modules (Dio, storage, Firebase) — the ONLY place sl is used
│   └── router/                  # AppRouter, typed guards, deep-link allowlist
├── core/
│   ├── error/                   # sealed AppException (data) + sealed Failure (domain, pure Dart)
│   ├── network/                 # ApiClient (interface) + DioApiClient, interceptors (auth w/ host allowlist,
│   │                            #   refresh via QueuedInterceptor + separate Dio, logging w/ redaction)
│   ├── storage/                 # SecureKeyValueStore (tokens), PreferencesStore (shared_prefs), LocalDb (drift)
│   ├── session/                 # SessionManager: login/logout orchestration, token lifecycle
│   ├── logging/                 # Logger facade + sinks; redaction; release filter; crash reporter sink
│   ├── notifications/           # PushService + payload→route mapper (allowlist)
│   ├── permissions/             # AppPermission enum, PermissionSpec table, one bloc/screen/guard
│   └── utils/                   # Result helpers, debouncer, etc.
├── design_system/               # tokens (ThemeExtension), widgets (AppButton(variant:), AppText, …)
└── features/<name>/
    ├── domain/                  # entities, repository interfaces, (optional) use cases — pure Dart
    ├── data/                    # DTO models, data sources (throw AppException), repository impl (→ Failure)
    └── presentation/            # bloc/cubit with sealed state, screens, widgets, routes
```

Rules (enforce with lints / `import_lint` / custom_lint):
1. `domain/` imports only Dart + `core/error` + other domain code. No Flutter, Dio, auto_route, Freezed JSON.
2. Data sources throw; repositories catch once and return `Result<T>`.
3. Constructor injection only; `GetIt` is referenced only in `app/di` and widget-tree roots (`BlocProvider(create: …)`).
4. Blocs never call `.tr()`; they emit keys/enums; widgets translate.
5. Events carry typed params (Freezed), never `Map<String, dynamic>`.
6. Every async bloc handler returns `Future<void>`; concurrency is declared via `bloc_concurrency` transformers.

### Generic CRUD redesign
Replace the 25-field `BaseCrudState` + 8 mixins with small composable pieces:
- `sealed class LoadState<T> { Initial, Loading, Success(T), Failure(Failure) }`
- `PagedState<T>` (items, cursor/page, hasMore, isLoadingMore, error) used by a `PagedListBloc<T, Q>` with `droppable()` for load-more and `restartable()` + debounce for query changes.
- Single-object features (settings, profile) use a plain `Cubit<LoadState<T>>`.
- Keep a Mason brick that scaffolds either shape.

---

## 11. Phased plan

Effort: **S** ≤ ½ day · **M** 1–2 days · **L** 3–5 days. Each phase ends green (analyze 0 warnings, tests pass).

### Phase 0 — Security emergency (do first, same day)
| Task | Effort | Done when |
|---|---|---|
| 0.1 Revoke/rotate the key in `TODO.md:29`; restrict new keys by package/bundle ID; enable App Check | S | Old key returns 403 |
| 0.2 Remove the key from `TODO.md`; `git filter-repo --replace-text` over history; force-push; tell collaborators to re-clone | S | `git log -p --all -S AIza` returns nothing |
| 0.3 Add secret scanning: `gitleaks` pre-commit + CI job; enable GitHub secret scanning/push protection | S | CI fails on a planted test key |
| 0.4 Delete `MyHttpOverrides`; gate `ALLOW_HTTP`/`PROXY` behind `kDebugMode` | S | No `badCertificateCallback => true` reachable in release |
| 0.5 Auth interceptor host allowlist; logger upload uses its own Dio (or is removed) | S | Unit test: token not sent to foreign host |
| 0.6 Stop logging secret values (storage values, FCM token, route args) | S | grep for `\$value`, `Token:` in logs is clean |
| 0.7 Disable periodic log upload by default; remove placeholder URL/device ID | S | No network on cold start without config |
| 0.8 Replace `firebase.json` IDs with placeholders; git-ignore `.mason/`, `hooks/build/`, `.claude/settings.local.json` | S | `git ls-files` shows none of them |

### Phase 1 — Make it correct (red → green)
| Task | Effort |
|---|---|
| 1.1 Fix B1/B2 predicates and B4 verb in example + **feature brick** templates | S |
| 1.2 Register `ExampleRepositoryImpl` (B3); add a test that resolves every `@injectable` from a fresh container | S |
| 1.3 Fix `ApiHandler` success logic (B5: rely on Dio `validateStatus`, accept any 2xx, handle 204) and `onError` propagation (B6) | S |
| 1.4 Convert all `void … async` handlers/cubit methods to `Future<void>`; fix `_updateSetting` emissions (B7, B8); enable `avoid_void_async`, `unawaited_futures`, `discarded_futures` | M |
| 1.5 Fix pagination bugs (B10, B11) and search (B12, B13) with `bloc_concurrency` | M |
| 1.6 Remove `UnimplementedError` stubs (B9, B28) by splitting mixin contracts (see Phase 3) or providing safe defaults | S |
| 1.7 Location "skip ≠ granted" (B15); remove double notification init (B16); move `startPeriodicUpload` out of `build` (B17); drop locale key on `MaterialApp` (B18) | S |
| 1.8 Bootstrap: set `FlutterError.onError`, `PlatformDispatcher.instance.onError`, `Bloc.observer`; report to crash sink (B19) | S |
| 1.9 Fix the 7 failing tests; delete/replace the empty notification test | M |
| 1.10 Clear all 24 analyzer warnings + `avoid_print`; remove profanity/debug prints (B27) | S |
| 1.11 Declare the 7 undeclared packages explicitly (or remove usages) | S |

### Phase 2 — Tooling, dependencies, CI
| Task | Effort |
|---|---|
| 2.1 Align Flutter: `.fvmrc`, `pubspec` `environment`, Shorebird `--flutter-version`, README → one version (current stable) | S |
| 2.2 Upgrade direct deps in batches with changelogs reviewed: patch/minor first, then majors (`firebase_* `, `flutter_secure_storage 11`, `permission_handler 13`, `injectable 3`, `equatable 3`, `file_picker 13`, `upgrader 14`) | L |
| 2.3 Pin `app_custom_lints` to a tag/SHA; add `custom_lint` dev dep; drop `nested: any` | S |
| 2.4 Fix `scripts:` (remove `flutter clean` from every build, add missing tools as dev deps or delete the scripts, add the missing `scripts/` folder or remove `exports`) | S |
| 2.5 Strengthen `analysis_options` (`strict-casts/inference/raw-types`, remove `invalid_annotation_target: ignore`, add async lints, `avoid_dynamic_calls`, `depend_on_referenced_packages`, fix stale excludes) | S |
| 2.6 GitHub Actions: `format --set-exit-if-changed`, `analyze`, `custom_lint`, `test --coverage`, `build_runner` drift check, `gitleaks`, `osv-scanner`; Dependabot/Renovate for pub + gradle + actions | M |
| 2.7 Decide generated-code policy (recommended: **don't** commit `*.g.dart/*.freezed.dart/*.gr.dart/*.config.dart`; generate in CI and in Mason post-gen hook) | S |
| 2.8 Flavors `dev/staging/prod` with `--dart-define-from-file`, per-flavor app ID suffix and Firebase project | M |

### Phase 3 — Core architecture refactor
| Task | Effort |
|---|---|
| 3.1 `core/error`: sealed `AppException` (network, timeout, unauthorized, server(status, body), parse, storage, cache) and sealed pure-Dart `Failure` (no `auto_route`, no `dio`); single `ErrorMapper` | M |
| 3.2 `ApiClient` interface + `DioApiClient` injected instance (no statics, no `sl`); one `request<T>()`; decoding via injected `fromJson` | M |
| 3.3 Interceptors: auth (allowlist) + **refresh** (`QueuedInterceptor`, separate Dio, single-flight, logout on refresh failure); logging interceptor with header/body redaction; drop or rethink `ConnectivityInterceptor` | M |
| 3.4 Storage split: `TokenStore` (secure storage, discrete keys), `PreferencesStore` (shared_preferences for theme/locale/onboarding), optional `LocalDb` (drift) for lists — retire `ISecureStorageDataSource` as a list DB | L |
| 3.5 `SessionManager` (login/logout/refresh, clears tokens, FCM token, caches, in-memory blocs) | M |
| 3.6 DI clean-up: constructor injection everywhere; `@module` for Dio/FlutterSecureStorage/SharedPreferences/Firebase; remove hand-rolled singletons (`NotificationService.instance`, `NavigationService._instance`); add DI smoke test | L |
| 3.7 Logging: facade + sinks (console in debug, crash reporter in release), redaction, rotation/size cap if file sink kept; remove upload or make it an opt-in, encrypted module | M |
| 3.8 Notifications: inject `NotificationService`; payload → typed route via allowlist; token registration through `PushTokenRepository`; background handler initialises Firebase | M |

### Phase 4 — DRY the features
| Task | Effort |
|---|---|
| 4.1 Permissions: `AppPermission` enum + `PermissionSpec` (icon, title key, body key, platform permission, required?) → one bloc (`Map<AppPermission, PermissionStatus>` + `Set<AppPermission> skipped`), one screen, one guard, one route with a path param; persist "skipped" in `PreferencesStore` | L |
| 4.2 Replace `BaseCrudBloc` god-state with `LoadState<T>` / `PagedListBloc<T,Q>` (Section 10); typed events; no `.tr()` in blocs | L |
| 4.3 Rewrite `features/example` as a small, realistic reference (e.g. `Todo` with id/title/done/updatedAt) — the current 26-field "every JSON type" model belongs in a model-converter test, not the reference slice | M |
| 4.4 Regenerate `feature_brick` from the new example; add brick tests (`mason make` into a temp dir → `flutter analyze` → `flutter test` in CI) | M |
| 4.5 Replace the hand-copied `project_brick` with a generator script that builds the brick from the repo (or move to `very_good_cli`-style template), with a CI drift check | L |
| 4.6 Delete dead code: `features/another`, `token_interceptor.dart`, `notification_no_logger.zip`, `custom_app_theme.dart` + custom colour/text system (if Material is the choice), commented Supabase/Shorebird blocks | S |

### Phase 5 — Presentation, theming, i18n
| Task | Effort |
|---|---|
| 5.1 One theme system: M3 `ColorScheme` + `ThemeExtension<AppTokens>`; remove static `AppMaterialColors`; `ThemeCubit` only holds `ThemeMode` | M |
| 5.2 `AppButton(variant:)` single constructor; audit other widgets for the same factory duplication | M |
| 5.3 Locale: single source of truth (EasyLocalization `saveLocale` **or** `PreferencesStore`, not both + cubit + AppSetting); detect device locale on first run; fix `LocaleConverter` to keep country code | M |
| 5.4 Splash becomes a real splash (decides route from session/onboarding); move the component gallery to a debug-only `/gallery` route | S |
| 5.5 Accessibility pass (Semantics, text scaling clamp, focus order), `EdgeInsetsDirectional` for RTL | M |
| 5.6 Replace deprecated APIs (`withOpacity` → `withValues`), fix non-const `IconData` (use a const icon map) | S |
| 5.7 Fix Unicode-unsafe validators (S21) and make validators return message keys | S |

### Phase 6 — Platform hardening & release
| Task | Effort |
|---|---|
| 6.1 Android: release signing from `key.properties`/CI secrets, R8 + shrink resources, `allowBackup=false`/extraction rules, network security config (no cleartext), remove unused permissions (add per-module via brick flags) | M |
| 6.2 iOS: remove unused purpose strings & background modes; per-flavor schemes; ATS stays strict | M |
| 6.3 Build scripts with `--obfuscate --split-debug-info`, upload symbols to crash reporter | S |
| 6.4 Optional: certificate pinning (`dio` + `http_certificate_pinning` or SPKI pin in `HttpClient`) behind config | M |
| 6.5 Optional: `FLAG_SECURE`/screen-capture protection mixin for sensitive screens | S |
| 6.6 Fix Shorebird scripts (correct Flutter version, `ipa` artifact for iOS) or remove until used | S |

### Phase 7 — Tests & documentation
| Task | Effort |
|---|---|
| 7.1 Unit tests: ApiClient (success/2xx variants/4xx/5xx/timeout), interceptors (allowlist, refresh single-flight), repositories (happy + each failure), SessionManager, permission bloc, cubits | L |
| 7.2 Widget tests for design-system widgets (light/dark) + goldens; screen smoke tests | M |
| 7.3 Integration test: cold start → splash → permission flow → home against a mock server | M |
| 7.4 Coverage gate in CI (start at current, ratchet to ≥ 80% for `core/`) | S |
| 7.5 Docs: fix README (env file names, scripts, flavors), `SECURITY.md` (secret handling, key rotation, reporting), ADRs for the decisions above, update `FOLDER_STRUCTURE.md`, prune `TODO.md` into GitHub issues | M |

### Suggested order & timeline (single developer)

| Week | Phases |
|---|---|
| 1 | Phase 0 (day 1) → Phase 1 |
| 2 | Phase 2 |
| 3–4 | Phase 3 |
| 5 | Phase 4 |
| 6 | Phase 5 + Phase 6 |
| 7 | Phase 7, release `v2.0.0` of the template |

Feature work from `TODO.md` (auth module, offline sync, deep links, etc.) should start **after**
Phase 3, because it depends on `SessionManager`, the refresh interceptor and the storage split.

---

## 12. Definition of done for the modernised template

- [ ] No secrets in tree or history; gitleaks green in CI.
- [ ] `flutter analyze` → 0 issues with the strict option set; `custom_lint` green.
- [ ] `flutter test --coverage` green; core coverage ≥ 80%.
- [ ] `mason make` both bricks in CI → generated project analyzes and tests green.
- [ ] Release build: signed with real key, minified, obfuscated, no trust-all TLS, no debug-only code paths reachable.
- [ ] Domain layer is pure Dart (enforced by an import lint).
- [ ] Zero `sl<…>()` calls outside `app/di` and widget-tree roots.
- [ ] Adding a permission or a CRUD feature is a config/brick operation, not copy-paste.
- [ ] README quick-start works verbatim on a clean machine.
