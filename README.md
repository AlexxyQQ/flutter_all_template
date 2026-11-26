# Flutter All Template

A barebones Flutter starter: Clean Architecture, plain Material 3, BLoC, get_it +
injectable, auto_route, Freezed. No custom UI kit or theme to unlearn: you get the
plumbing (networking, storage, sessions, logging, localization, permissions, CI/CD) and
a small Todo example to copy from. Mason bricks generate a new project or a new feature.

## Requirements

| Tool | Version |
|---|---|
| Flutter | 3.44.1, pinned in [`.fvmrc`](.fvmrc) (`fvm install && fvm use`) |
| [rps](https://pub.dev/packages/rps) | `dart pub global activate rps` runs the scripts in `pubspec.yaml` |
| [Mason CLI](https://pub.dev/packages/mason_cli) | only to generate projects or features |
| JDK 17, Android SDK, Xcode | for device builds |

## Quick start

```bash
flutter pub get
cp env/dev.example.json env/dev.json        # set BASE_URL (see docs/FLAVORS.md)
rps gen                                     # build_runner + locale keys; generated files are git-ignored
rps run dev                                 # flutter run --dart-define-from-file=env/dev.json
```

Without `rps`: `dart run build_runner build --delete-conflicting-outputs` and
`dart run easy_localization:generate -S assets/translations -f keys -O lib/config/constants/gen -o locale_keys.g.dart`.
Re-run `rps gen` after pulling or changing models, routes, injectable classes or translations.

The real Firebase files (`google-services.json`, `GoogleService-Info.plist`, `firebase.json`,
`firebase_options.dart`) are git-ignored; only their `*.example` placeholders are tracked. Run
`rps firebase:init` to create the real files from them (never overwrites), then
`flutterfire configure` ([SECURITY.md](SECURITY.md)).

## What is in `lib/`

```
lib/
├── config/      env (AppEnv), constants, firebase options, observers
├── core/
│   ├── error/ network/ storage/ session/    infrastructure
│   ├── common/  logger, navigation, notifications, app settings, permissions, DI, router
│   └── generic/ paged-list / load-state blocs, offline cache helpers
└── features/    splash -> home -> example (todos), each data / domain / presentation
```

Details and layering rules: [FOLDER_STRUCTURE.md](FOLDER_STRUCTURE.md). **Coding rules with do/don't examples: [RULES.md](RULES.md)** — read before your first PR.

## Commands

| Command | Does |
|---|---|
| `rps gen` / `rps watch` | code generation once / in watch mode |
| `rps check` | what CI checks: gen, format check, analyze, test |
| `rps analyze` | `flutter analyze` + `custom_lint` |
| `rps test` | `flutter test --coverage` |
| `rps run dev\|staging\|prod` | run a flavor |
| `rps build apk\|appbundle\|ipa <flavor>` | obfuscated release builds |
| `rps maestro` | build, install and run the end-to-end flows (Android) |
| `rps icons` | regenerate launcher icons and native splash |
| `rps brick` | re-sync the Mason project brick from this repo |

## CI/CD at a glance

Pull requests run a lean Linux check (format, analyze, custom_lint, tests, brick sync). A
weekly OSV scan watches dependencies. Android releases are built **locally** and uploaded
to a GitHub Release with `scripts/release.sh`; iOS is built manually on Codemagic.
Nothing uses macOS GitHub runners. Secret scanning is local: run
`gitleaks detect --config .gitleaks.toml` or use it as a pre-commit hook.

## Mason bricks

```bash
dart pub global activate mason_cli
mason get
mason make flutter_all_template     # new project: app_name, app_org, optional firebase / notifications / permissions
mason make flutter_feature          # new feature slice, run from a project root
```

The project brick is generated from this repo (`dart run tool/sync_brick.dart`; CI fails
if it is stale). See [bricks/project_brick](bricks/project_brick/README.md) and
[bricks/feature_brick](bricks/feature_brick/README.md).

## Docs

| Topic | File |
|---|---|
| Release flow, CI cost model, Codemagic | [docs/CI_CD.md](docs/CI_CD.md) |
| End-to-end tests (Maestro) | [docs/MAESTRO.md](docs/MAESTRO.md) |
| Flavors and compile-time config | [docs/FLAVORS.md](docs/FLAVORS.md), [env/README.md](env/README.md) |
| Android / iOS signing | [docs/CODE_SIGNING.md](docs/CODE_SIGNING.md) |
| Permissions, backups, network security | [docs/PLATFORM_SETUP.md](docs/PLATFORM_SETUP.md) |
| Secrets and security policy | [SECURITY.md](SECURITY.md) |
| Translations | [assets/translations/README.md](assets/translations/README.md) |
| Version history | [CHANGELOG.md](CHANGELOG.md) |
