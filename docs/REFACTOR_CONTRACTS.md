# Refactor contracts & ownership (wave 1)

Read together with `docs/TEMPLATE_AUDIT_AND_PLAN.md` (finding IDs S*, B* refer to it).

## Frozen contracts (do not change signatures; extend only by adding)

| File | What |
|---|---|
| `lib/core/common/domain/entities/failure.dart` | Pure-Dart `Failure(message, type, statusCode, fieldErrors)` + `FailureType`. `message` = localization key. `Failure.fromException` is deprecated — remove its uses in your area. |
| `lib/core/error/app_exception.dart` | Sealed `AppException` hierarchy thrown by the data layer. |
| `lib/core/error/guard.dart` | `guard()` — the only place exceptions become `Failure`s. Repositories wrap data-source calls with it. `guardErrorReporter` hook. |
| `lib/core/network/api_client.dart` | `ApiClient` interface + `Decoders`. Remote data sources depend on this (constructor-injected), never on Dio or the static `ApiHandler`. |
| `lib/core/storage/key_value_stores.dart` | `SecureStore` (secrets only) and `PreferencesStore` (non-secret, sync reads). |
| `lib/core/session/session.dart` | `AuthTokens`, `TokenStore`, `SessionStatus`, `SessionManager` (+ `registerLogoutHook`). |
| `lib/config/env/app_env.dart` | Compile-time config from `--dart-define-from-file=env/<flavor>.json`. Replaces `flutter_dotenv`. |
| `lib/config/constants/type_defs/typedef.dart` | `ResultFuture<T>` stays. |

## Rules for every agent

1. Constructor injection only. Do not add new `sl<…>()`/`GetIt` calls outside `lib/core/common/locator/` and widget-tree roots (`BlocProvider(create: …)`, route/page roots). Remove existing ones in files you own.
2. Domain code (`*/domain/**`) imports only Dart, `equatable`, `fpdart`, `freezed_annotation` (no JSON), other domain code, and `config/constants/gen/locale_keys.g.dart`.
3. Data sources throw `AppException`; repositories return `guard(() => …)`.
4. Blocs/cubits: every handler returns `Future<void>`; declare concurrency with `bloc_concurrency`; never call `.tr()` in a bloc (emit keys, widgets translate).
5. Never log secrets (tokens, passwords, storage values, route arguments, push tokens).
6. No new `print`/`debugPrint` (use `AppLogger`).
7. Generated files are git-ignored. After `git pull`/worktree creation run:
   `flutter pub get && dart run build_runner build --delete-conflicting-outputs && dart run easy_localization:generate -S assets/translations -f keys -O lib/config/constants/gen -o locale_keys.g.dart`
8. Translations: only **add** keys to `assets/translations/*.json` (both `en-GB` and `ne-NP`); don't reorder/reformat existing content.
9. Do not edit files owned by another agent. If you must touch one (e.g. an import path), keep the change minimal and list it in your final report.
10. Don't edit `README.md`, `CHANGELOG.md`, `FOLDER_STRUCTURE.md`, `TODO.md`, `bricks/project_brick/**` (other owners / wave 2).
11. `pubspec.yaml`: dependencies needed by wave 1 are already declared. Only add a dependency if unavoidable, appended at the end of the relevant section, and report it.

## Ownership

| Agent | Owns |
|---|---|
| **A – core-infra** | `lib/core/error/**` (impl additions), `lib/core/network/**`, `lib/core/storage/**`, `lib/core/session/**`, `lib/core/common/domain/services/{network,storage,logger,files}/**`, `lib/core/common/features/app_settings/**`, `lib/core/common/presentation/blocs/**` (theme/locale cubits, global providers), `lib/core/common/locator/**`, `lib/core/bootstrap.dart`, `lib/core/app.dart`, `lib/main.dart`, `lib/config/constants/api/**`, `lib/config/observers/**`, `lib/core/common/domain/entities/failure.dart` (may remove the deprecated factory at the end), tests under `test/unit/core/{network,storage,session,error,logging,app_settings}/` |
| **B – permissions & notifications** | `lib/core/common/features/permission/**`, `lib/core/common/domain/services/notification/**`, `lib/core/common/domain/services/navigation/**`, `lib/config/constants/paths/app_path.dart`, tests under `test/unit/core/{permission,notification,navigation}/` |
| **C – generic CRUD, example & feature brick** | `lib/core/generic/**`, `lib/features/example/**`, `lib/core/common/data/models/helpers/**`, `lib/core/common/domain/entities/params/**`, `lib/config/constants/api/api_paths.dart`, `bricks/feature_brick/**`, `test/unit/core/generic/**`, `test/unit/features/example/**` |
| **D – presentation & design system** | `lib/config/themes/**`, `lib/config/constants/{colors,text,enums,images,date_time,locales,type_defs/file_types.dart}/**`, `lib/core/abstract/**`, `lib/core/common/presentation/**` **except** `blocs/`, `lib/core/common/domain/controllers/**`, `lib/features/splash/**`, `lib/features/another/**` (delete), `lib/core/common/domain/services/notification_no_logger.zip` (delete), widget tests under `test/widget/**` |
| **E – tooling, platform, CI & docs** | `pubspec.yaml` (scripts/tooling sections, flutter assets section), `analysis_options.yaml` (only if needed), `.github/**`, `android/**`, `ios/**`, `env/**`, `firebase.json`, `.gitignore`, `.vscode/**`, `mason.yaml`, `mason-lock.json`, `scripts/**` / `tool/**`, `README.md`, `FOLDER_STRUCTURE.md`, `TODO.md`, `docs/**` (except this file and the audit), `SECURITY.md` |
