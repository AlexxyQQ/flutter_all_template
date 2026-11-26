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
├── config/            static configuration, no business logic
├── core/              shared infrastructure and cross-cutting concerns
└── features/          product features (data / domain / presentation)
```

### `config/`

| Path | Purpose |
|---|---|
| `env/app_env.dart` | `AppEnv`: compile-time config from `--dart-define-from-file=env/<flavor>.json` |
| `constants/api/` | base URL helpers (`api_constants.dart`), endpoint paths (`api_paths.dart`) |
| `constants/locales/` | supported locales |
| `constants/paths/app_path.dart` | route path constants |
| `constants/type_defs/` | `ResultFuture`, `ResultVoid` and friends |
| `constants/gen/` | generated `assets.gen.dart` (flutter_gen) and `locale_keys.g.dart` (git-ignored) |
| `firebase/firebase_options.dart` | FlutterFire config, git-ignored; tracked as `.example` (only with the Firebase module) |
| `observers/` | `AppBlocObserver`, route observer |

### `core/`

| Path | Purpose |
|---|---|
| `bootstrap.dart`, `app.dart` | DI setup, global error handling, `MaterialApp.router` with the global providers |
| `error/` | `AppException` (thrown by data sources) and `guard()` which turns it into a `Failure` |
| `network/` | `ApiClient` interface, Dio implementation, auth / refresh-token / logging interceptors |
| `storage/` | `SecureStore` (secrets) and `PreferencesStore` (non-secret) behind small interfaces |
| `session/` | `TokenStore` on secure storage and `SessionManager` (sign-in / sign-out) |
| `generic/` | `PagedListBloc`, `LoadCubit`, `SelectionCubit`, `PageRequest`/`PageResult`, `JsonCollectionStore`, `AsyncLock`, `SingleFlightCache` (see its README) |
| `common/data/models/helpers/` | JSON and entity conversion helpers |
| `common/domain/entities/failure.dart` | `Failure`; its `message` is a localization key |
| `common/domain/services/logger/` | redacting logger with pluggable sinks |
| `common/domain/services/navigation/` | `NavigationService` over `AppRouter` |
| `common/domain/services/notification/` | FCM + local notifications (optional module) |
| `common/features/app_settings/` | locale preference (non-secret) |
| `common/features/permission/` | one enum, one spec table, one bloc, one screen, one guard (optional module) |
| `common/locator/` | get_it + injectable setup (`sl`) |
| `common/presentation/blocs/` | `LocaleCubit`, global bloc providers |
| `common/presentation/routes/` | `AppRouter` (auto_route) |

### `features/`

Each feature is self-contained:

```
features/<name>/
├── data/            models, data_sources/{remote,local}, repositories (impl)
├── domain/          entities, params, repository interfaces, usecases (pure Dart)
└── presentation/    bloc/, routes/ (@RoutePage wrappers), views/screens/
```

Current features: `splash` and `home` (presentation only) and `example` (a complete Todo slice
with paging, search and an offline cache). Generate new slices with `mason make flutter_feature`.

## Layering rules

- `domain` imports nothing from `data` or `presentation` and no Flutter or Dio types.
- Presentation → use cases → repository interface. A use case is one class per business
  action in `domain/usecases/<action>_use_case.dart` with a named-parameter `call(...)`;
  blocs depend on use cases, never on repositories or data sources.
- Data sources throw `AppException`; repositories wrap calls in `guard()` and return
  `ResultFuture<T>` (`Either<Failure, T>`).
- Blocs never call `.tr()`: they expose `Failure.message` (a key) and widgets translate it.
- Resolve dependencies through constructor injection; `sl` is only used at composition
  points (route wrappers, `bootstrap`).
- No `Map<String, dynamic>` crosses the domain boundary; ids are `String`.
- Secrets never go into `env/`, preferences or logs.
- Conventions: use-case, repository and data-source methods take named parameters only; classes receive their dependencies through named, `required` constructor parameters (private fields set in the initializer list).

## Adding things

| Task | Do |
|---|---|
| New feature | `mason make flutter_feature`, add a route, run `rps gen` |
| New route | `@RoutePage` screen, `*Route` class, register it in `app_router.dart` |
| New translation | add the key to every `assets/translations/*.json`, run `rps gen:keys` |
| New permission | see `lib/core/common/features/permission/README.md` |
| New endpoint | add a constant to `ApiPaths`, call it through `ApiClient` in a remote data source |
| New flavor value | add it to `env/*.example.json` and read it in `AppEnv` |

## Tests

`test/unit/` mirrors `lib/core` and `lib/features`; `test/widget/` holds screen tests
(`helpers/test_app.dart` builds a minimal app). Prefer `mocktail` fakes over generated mocks.
End-to-end flows live in `.maestro/` (see `docs/MAESTRO.md`).
