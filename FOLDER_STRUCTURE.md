# Folder Structure

Where things live and the rules for adding code. This matches the current `lib/` tree.
Coding conventions with do/don't examples live in [RULES.md](RULES.md).

## Repository layout

```
.
├── lib/            Dart source (below)
├── test/           unit/ and widget/ tests, mirroring lib/
├── assets/         app-icons/ (source for `rps icons`), images/, translations/ (*.json)
├── android/ ios/   native projects; edit only when needed
├── env/            per-flavor compile-time config (*.example.json tracked, real *.json ignored)
├── docs/           CI_CD, MAESTRO, FLAVORS, CODE_SIGNING, PLATFORM_SETUP
├── scripts/        release.sh (local Android release), maestro.sh (E2E runner)
├── .maestro/       Maestro flows and the stub API server
├── .github/        PR CI, weekly OSV scan, Dependabot
├── codemagic.yaml  manual iOS builds
├── bricks/         Mason bricks: project_brick (generated), feature_brick
├── tool/           sync_brick.dart (regenerates the project brick)
└── pubspec.yaml    dependencies, `rps` scripts, icon/splash config
```

`build/`, `.dart_tool/` and `.fvm/` are tooling-managed. Generated Dart files
(`*.g.dart`, `*.freezed.dart`, `*.gr.dart`, `*.config.dart`, `lib/config/constants/gen/`)
are git-ignored; create them with `rps gen`.

## `lib/`

```
lib/
├── main.dart          entry point: optional Firebase init, then bootstrap
├── app/               composition root: knows every feature (bootstrap, DI, router, observers)
├── config/            static configuration, no business logic and no imports from core/
├── core/              shared, feature-agnostic code; never imports features/ or app/
└── features/          product features (data / domain / presentation)
```

Dependencies point one way: `app` -> `features` -> `core` -> `config`.
The only upward reference is generated: feature route files import the route classes from
`app/router/app_router.gr.dart`.

### `app/`

| Path | Purpose |
|---|---|
| `bootstrap.dart`, `app.dart` | error handling, DI setup, session restore, `MaterialApp.router` with the global providers |
| `di/service_locator.dart` | get_it + injectable setup (`sl`) |
| `router/app_router.dart` | `AppRouter` (auto_route): composes the routes of every feature; registered as `RootStackRouter` |
| `providers/global_bloc_providers.dart` | app-wide bloc providers |
| `observers/` | `AppBlocObserver`, `AppRouteObserver` |

### `config/`

| Path | Purpose |
|---|---|
| `env/app_env.dart` | `AppEnv`: compile-time config from `--dart-define-from-file=env/<flavor>.json` |
| `constants/api/` | base URL helpers (`api_constants.dart`), endpoint paths (`api_paths.dart`) |
| `constants/locales/` | supported locales |
| `constants/paths/app_path.dart` | route path constants |
| `constants/gen/` | generated `assets.gen.dart` (flutter_gen) and `locale_keys.g.dart` (git-ignored) |
| `firebase/firebase_options.dart` | FlutterFire config, git-ignored; tracked as `.example` (only with the Firebase module) |

### `core/`

| Path | Purpose |
|---|---|
| `error/` | `AppException` (thrown by data sources), `guard()` which turns it into a `Failure`, `Failure` (pure Dart) and the `ResultFuture<T>` typedef |
| `network/` | `IApiClient` interface, Dio implementation, auth / refresh-token / logging interceptors |
| `storage/` | `ISecureStore` for secrets, `IPreferencesStore` for settings, and `EncryptedHiveStore` for private local records |
| `session/` | `ITokenStore` on secure storage, `ISessionManager` (sign-in / sign-out / status), the interceptor-only `ISessionAuthority` (token refresh, session generation) and `SessionScope` (preference keys removed on sign-out) |
| `generic/` | `PagedListBloc`, `PageRequest`/`PageResult`, `JsonCollectionStore`, `AsyncLock` (see its README) |
| `presentation/modals/` | `ModalService`, shared bottom sheets and popup dialogs |
| `services/` | cross-cutting services, one folder each (below) |

Every service uses the same layout:

```
core/services/<name>/
├── domain/          interfaces and entities, pure Dart (no Flutter, Dio, Hive, Firebase, plugins)
├── data/            implementations, DI modules, destinations, helpers (all infrastructure)
├── presentation/    only if the service touches Flutter UI (lifecycle observers, NavigationService)
└── README.md
```

| Service | Purpose |
|---|---|
| `services/analytics/` | per-user action, navigation and error analytics with local and remote destinations |
| `services/logger/` | redacting logger (`ILoggerService`, static `AppLogger`) with pluggable sinks |
| `services/navigation/` | `NavigationService` over a `RootStackRouter` (the app supplies `AppRouter`) |
| `services/notification/` | FCM + local notifications (optional module) |

### `features/`

Each feature is self-contained:

```
features/<name>/
├── data/            models, data_sources/{remote,local}, repositories (impl)
├── domain/          entities, params, repository interfaces, usecases (pure Dart)
└── presentation/    bloc/, routes/ (route table), views/{wrappers (route shell, provides the bloc), screens, widgets}
```

Current features: `splash` and `home` (presentation only), `app_settings` (locale preference,
non-secret), `permission` (one enum, one spec table, one bloc, one screen, one guard; optional
module) and `example` (a complete Todo slice with paging, search and an offline cache). Generate new slices (with page, wrapper, route and widget test) with `mason make flutter_feature`.

## Layering rules

- `domain` imports nothing from `data` or `presentation` and no Flutter or Dio types.
- Presentation → use cases → repository interface. A use case is one class per business
  action in `domain/usecases/<action>_use_case.dart` with a named-parameter `call(...)`;
  blocs depend on use cases, never on repositories or data sources.
- Data sources throw `AppException`; repositories wrap calls in `guard()` and return
  `ResultFuture<T>` (`Either<Failure, T>`).
- Blocs never call `.tr()`: they expose `Failure.message` (a key) and widgets translate it.
- `core/` never imports `features/` or `app/`; `config/` never imports `core/`; `domain` folders hold pure Dart only.
- Resolve dependencies through constructor injection; `sl` is only used at composition
  points (route wrappers, `bootstrap`).
- No `Map<String, dynamic>` crosses the domain boundary; ids are `String`.
- Secrets never go into `env/`, preferences or logs.
- Conventions: use-case, repository and data-source methods take named parameters only; classes receive their dependencies through named, `required` constructor parameters (private fields set in the initializer list).

## Adding things

| Task | Do |
|---|---|
| New feature | `mason make flutter_feature` (route is registered for you), run `rps gen` |
| New route | `@RoutePage` screen, a `<Feature>Routes` holder (`static final route`), register it in `app/router/app_router.dart` |
| New translation | add a semantic key (`features.<name>.<key>`) to every `assets/translations/*.json`, run `rps gen:keys` |
| New permission | see `lib/features/permission/README.md` |
| New endpoint | add a constant to `ApiPaths`, call it through `IApiClient` in a remote data source |
| New flavor value | add it to `env/*.example.json` and read it in `AppEnv` |

## Tests

`test/unit/` mirrors `lib/app`, `lib/core` and `lib/features`; `test/widget/` holds screen tests
(`helpers/test_app.dart` builds a minimal app). Prefer `mocktail` fakes over generated mocks.
End-to-end flows live in `.maestro/` (see `docs/MAESTRO.md`).
