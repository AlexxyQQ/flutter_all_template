# Flutter All Template

A Flutter starter template built on Clean Architecture, Material 3, BLoC and
injectable DI, with Mason bricks to generate new projects and feature slices.

> **Status:** the template is being modernised (see
> [`docs/TEMPLATE_AUDIT_AND_PLAN.md`](docs/TEMPLATE_AUDIT_AND_PLAN.md)). Folder names
> under `lib/core/` may still move between refactor waves.

---

## Requirements

| Tool | Version | Notes |
|---|---|---|
| Flutter | **3.38.5** (pinned in [`.fvmrc`](.fvmrc)) | Use [FVM](https://fvm.app): `fvm install && fvm use` — then prefix commands with `fvm` (e.g. `fvm flutter run`) |
| Dart | bundled with Flutter (`sdk: ^3.10.4`) | |
| [rps](https://pub.dev/packages/rps) | latest | `dart pub global activate rps` — runs the `scripts:` in `pubspec.yaml` |
| [Mason CLI](https://pub.dev/packages/mason_cli) | `>=0.1.0-dev.52 <0.2.0` | Only for generating projects/features |
| JDK 17 + Android SDK / Xcode | | For device builds |

CI uses the exact version in `.fvmrc`, so keep it the single source of truth.

---

## Quick start (clone as-is)

```bash
git clone https://github.com/AlexxyQQ/flutter_all_template
cd flutter_all_template

# 1. Flutter version from .fvmrc (skip if your global Flutter already matches)
fvm install && fvm use

# 2. Dependencies
flutter pub get

# 3. Compile-time config for each flavor you use (placeholders → your values)
cp env/dev.example.json env/dev.json
# cp env/staging.example.json env/staging.json
# cp env/prod.example.json    env/prod.json

# 4. Generate code — generated files are NOT committed
#    (build_runner: Freezed, JSON, injectable, auto_route, flutter_gen + locale keys)
rps gen

# 5. Run the dev flavor
rps run dev
# = flutter run --dart-define-from-file=env/dev.json
```

Without `rps`, step 4 is:

```bash
dart run build_runner build --delete-conflicting-outputs
dart run easy_localization:generate -S assets/translations -f keys \
  -O lib/config/constants/gen -o locale_keys.g.dart
```

Re-run `rps gen` after every `git pull`, branch switch, or change to an annotated
class, route, asset, or translation file.

**Firebase:** the tracked `google-services.json`, `GoogleService-Info.plist` and
`firebase.json` contain placeholders only. Run `flutterfire configure` against your
own Firebase project and **do not commit** the generated values
(see [`SECURITY.md`](SECURITY.md)).

---

## Environment & flavors

Configuration is compiled in with `--dart-define-from-file=env/<flavor>.json` and read
through [`lib/config/env/app_env.dart`](lib/config/env/app_env.dart). `flutter_dotenv`
and `.env` assets are gone.

| Key | Purpose |
|---|---|
| `FLAVOR` | `dev` · `staging` · `prod` |
| `BASE_URL` | API base URL |
| `ENABLE_LOG_UPLOAD` / `LOG_UPLOAD_URL` | Opt-in remote log upload (off by default) |
| `DEV_PROXY` / `DEV_TRUST_SELF_SIGNED_CERTS` | Debug-only escape hatches, ignored in release |

Everything in these files ships inside the binary — **never put secrets there**.
Details: [`docs/FLAVORS.md`](docs/FLAVORS.md) and [`env/README.md`](env/README.md).

VS Code has launch configurations for `dev`, `staging` and `prod` (profile/release).

---

## Scripts (`rps`)

| Command | What it does |
|---|---|
| `rps gen` | build_runner + locale keys (all code generation) |
| `rps gen:keys` | locale keys only |
| `rps watch` | build_runner in watch mode |
| `rps check` | everything CI checks: gen → format check → analyze → test |
| `rps analyze` | `flutter analyze` + `custom_lint` |
| `rps test` | `flutter test --coverage` |
| `rps format` / `rps fix` | `dart format lib test` / `dart fix --apply` |
| `rps reset` | `flutter clean` + pub get + gen (only when the build cache is broken) |
| `rps icons` | regenerate splash screens and launcher icons |
| `rps run dev\|staging\|prod` | run a flavor |
| `rps build apk dev\|staging\|prod` | release APK |
| `rps build appbundle staging\|prod` | release AAB (Play Store) |
| `rps build ipa staging\|prod` | release IPA |
| `rps shorebird release android\|ios` | optional Shorebird OTA release (prod config) |

All release builds use `--obfuscate --split-debug-info=build/symbols/<flavor>`.
Keep those symbol files (per release) to de-obfuscate crash stack traces.

Android release signing reads `android/key.properties`; without it the build is
debug-signed and Gradle prints a warning — see [`docs/CODE_SIGNING.md`](docs/CODE_SIGNING.md).

---

## Continuous integration

[`.github/workflows/ci.yml`](.github/workflows/ci.yml) runs on every pull request and
on pushes to `main`:

1. Flutter from `.fvmrc` → `flutter pub get` → code generation
2. `dart format --output=none --set-exit-if-changed lib test`
3. `flutter analyze`
4. `flutter test --coverage` (lcov uploaded as an artifact)
5. **security job:** gitleaks (full history) and OSV-Scanner on `pubspec.lock`

Dependabot ([`.github/dependabot.yml`](.github/dependabot.yml)) opens update PRs for
pub, Gradle and GitHub Actions. Actions are pinned to commit SHAs.

Run the same checks locally before pushing with `rps check`. Optional pre-commit hook
(not enforced) — save as `.git/hooks/pre-commit` and `chmod +x` it:

```sh
#!/bin/sh
set -e
dart format --output=none --set-exit-if-changed lib test
flutter analyze
command -v gitleaks >/dev/null && gitleaks protect --staged --config .gitleaks.toml
```

---

## Mason bricks

```bash
dart pub global activate mason_cli
mason get                       # resolves bricks from mason.yaml (mason-lock.json is git-ignored)
```

**New project** (`bricks/project_brick`):

```bash
mason make flutter_all_template
# → What is the app name?                       my_app
# → What is the organization? (e.g. com.example) com.example
# → Include Firebase?                            n
# → Include push notifications?                  n
# → Include permission screens?                  y
cd my_app && flutter pub get && rps gen
```

> The project brick is regenerated from this repo in a later refactor wave; until then
> it may lag behind the template. See [bricks/project_brick/README.md](bricks/project_brick/README.md).

**New feature slice** (`bricks/feature_brick`), from the project root:

```bash
mason make flutter_feature
# → What is the feature name? (snake_case, e.g. user_profile)  user_profile
# → Include a local data source (SecureStorage)?                n
# → Generate a typed RequestParams class?                       y
rps gen
```

Then add an API path in `lib/config/constants/api/api_paths.dart`, register routes in
the `AppRouter`, and write tests. See [bricks/feature_brick/README.md](bricks/feature_brick/README.md).

---

## Project structure

High-level only — see [`FOLDER_STRUCTURE.md`](FOLDER_STRUCTURE.md) for details.

```
lib/
├── config/       # env (AppEnv), constants, themes, firebase options, observers
├── core/
│   ├── error/    # AppException (data layer) + guard() → Failure
│   ├── network/  # ApiClient interface
│   ├── storage/  # SecureStore (secrets) / PreferencesStore (non-secret)
│   ├── session/  # tokens + SessionManager (login/logout orchestration)
│   ├── common/   # shared services, app settings, permissions, DI, presentation
│   └── generic/  # generic CRUD bloc + base data sources
└── features/     # feature slices (data / domain / presentation)
```

---

## Documentation

| Topic | Where |
|---|---|
| Security policy, secrets, key rotation | [`SECURITY.md`](SECURITY.md) |
| Flavors & compile-time config | [`docs/FLAVORS.md`](docs/FLAVORS.md) |
| Android/iOS release signing | [`docs/CODE_SIGNING.md`](docs/CODE_SIGNING.md) |
| Platform permissions, backup, network security | [`docs/PLATFORM_SETUP.md`](docs/PLATFORM_SETUP.md) |
| Folder conventions | [`FOLDER_STRUCTURE.md`](FOLDER_STRUCTURE.md) |
| Audit & modernisation plan | [`docs/TEMPLATE_AUDIT_AND_PLAN.md`](docs/TEMPLATE_AUDIT_AND_PLAN.md) |
| Translations | [`assets/translations/README.md`](assets/translations/README.md) |
| Push notifications | `lib/core/common/domain/services/notification/docs/` |
| Backlog | [`TODO.md`](TODO.md) |

Module READMEs live next to their code (`lib/**/README.md`).
