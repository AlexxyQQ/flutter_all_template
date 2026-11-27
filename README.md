# Flutter All Template

A barebones Flutter starter: Clean Architecture, plain Material 3, BLoC, get_it +
injectable, auto_route, Freezed. No custom UI kit or theme to unlearn: you get the
plumbing (networking, storage, sessions, logging, localization, permissions, CI/CD) and
a small Todo example to copy from. Mason bricks generate a new project or a new feature.

**Contents:** [Start a new app](#start-a-new-app) · [First run](#first-run) ·
[Make it yours](#make-it-yours) · [Add features](#add-features) · [Ship it](#ship-it) ·
[Working on the template itself](#working-on-the-template-itself) · [Docs](#docs)

---

## Start a new app

Use the Mason project brick. It renames the package, sets the Android `applicationId` and
the iOS bundle id, wires CI/Codemagic/Maestro to your names, and removes the optional
modules you do not pick.

**1. Install the tools** (once)

| Tool | Version |
|---|---|
| Flutter | 3.44.1 (see [`.fvmrc`](.fvmrc); [FVM](https://fvm.app) recommended) |
| [Mason CLI](https://pub.dev/packages/mason_cli) | `dart pub global activate mason_cli` |
| [rps](https://pub.dev/packages/rps) | `dart pub global activate rps` (runs the scripts in `pubspec.yaml`) |
| JDK 17, Android SDK | for Android builds |
| Xcode | only if you build iOS yourself; otherwise use Codemagic ([docs/CI_CD.md](docs/CI_CD.md)) |

**2. Register the bricks** (once per machine)

Clone the repo to a **short path** and register both bricks from it. The folder is only a
brick source; your app is generated somewhere else.

```bash
# macOS / Linux
git clone --depth 1 https://github.com/AlexxyQQ/flutter_all_template ~/fat
mason add -g flutter_all_template --path ~/fat/bricks/project_brick
mason add -g flutter_feature      --path ~/fat/bricks/feature_brick

# Windows (PowerShell): keep the clone path short, e.g. C:\src\fat
git clone --depth 1 https://github.com/AlexxyQQ/flutter_all_template C:\src\fat
mason add -g flutter_all_template --path C:\src\fat\bricks\project_brick
mason add -g flutter_feature      --path C:\src\fat\bricks\feature_brick
```

`bricks/project_brick/__brick__` is generated and not committed, so build it once after
cloning (and again after every `git pull`): `dart pub get && dart run tool/sync_brick.dart`
(or `rps brick`).

Update later with `git pull` in that folder, then regenerate the brick.

> **Windows: do not use `mason add --git-url`.** Mason copies git bricks into a cache
> folder with a ~170-character name, and the brick's deeper files then exceed Windows'
> 260-character path limit (`PathNotFoundException: Directory listing failed ... \kotlin\com\*`).
> Enabling "long paths" does not help because Mason does not use them. A short local clone
> avoids the problem. On macOS and Linux (no 260-character limit) `--git-url` with
`--git-path bricks/project_brick` should also work, but the clone route is the tested one.

**3. Generate your project**

```bash
mason make flutter_all_template
```

You are asked for:

| Prompt | Meaning | Default |
|---|---|---|
| `app_name` | App name; snake_cased for the package | `my_flutter_app` |
| `app_org` | Organization id, e.g. `com.acme` | `com.example` |
| `app_display_name` | Name under the launcher icon (empty: derived from `app_name`) | derived |
| `base_url` | Dev API base URL for `env/dev.example.json` (empty: emulator default) | emulator default |
| `use_firebase` | Firebase Core, Firebase Analytics and FlutterFire config | `false` |
| `use_notifications` | Push notifications (FCM + local; implies Firebase) | `false` |
| `use_permissions` | Permission bloc, screen and route guard | `false` |
| `use_ci` | GitHub Actions CI, OSV scan, Dependabot, gitleaks config | `true` |
| `use_codemagic` | `codemagic.yaml` cloud builds | `true` |
| `use_maestro` | Maestro end-to-end flows and scripts | `true` |

Everything lands in `./<app_name>/`. Disabled modules are removed completely (files,
dependencies, routes, tests), so you start with nothing you do not use.

> Do not rename a clone of this repo by hand to start an app: the brick does it correctly
> in one step. To explore or contribute, see
> [Working on the template itself](#working-on-the-template-itself).

## First run

Inside the generated project:

```bash
git init
flutter pub get
cp env/dev.example.json env/dev.json     # set BASE_URL (more in docs/FLAVORS.md)
rps gen                                  # code generation; generated files are git-ignored
dart fix --apply && dart format .        # first run only: tidies imports after optional modules were stripped
rps run dev                              # flutter run --dart-define-from-file=env/dev.json
```

If you enabled Firebase, run `rps firebase:init` then `flutterfire configure`, and keep the
generated files out of git (they already are ignored; see [SECURITY.md](SECURITY.md)).

The to-do screen calls a real `/todos` API. Without a backend it shows an error with a
retry button. To try it offline, start the stub in [docs/MAESTRO.md](docs/MAESTRO.md).

Verify everything works before changing anything: `rps check` (format, analyze, test).

## Make it yours

Do these in the first hour:

1. **Identity.** Replace the images in `assets/app-icons/`, then `rps icons` to regenerate
   launcher icons and the native splash. Edit the display name in
   `android/app/src/main/AndroidManifest.xml` and `ios/Runner/Info.plist`.
2. **Config.** Set `BASE_URL` (and the rest) in `env/dev.json`, `env/staging.json`,
   `env/prod.json`. Real env files are git-ignored; only the `*.example.json` are tracked.
3. **Delete the Todo example** once you have read it (it is the reference for your own
   features). Remove:
   - `lib/features/example/` and `test/unit/features/example/`, `test/widget/features/example/`
   - the `TodoRoutes.route` entry in `lib/app/router/app_router.dart`
   - the "open to-dos" button in `lib/features/home/presentation/views/screens/home_screen.dart`
   - `ApiPaths.todos` in `lib/config/constants/api/api_paths.dart`
   - the todo checks in `test/unit/app/di/di_smoke_test.dart`
   - the todo translation keys in `assets/translations/*.json`, and `.maestro/flows/02_navigation.yaml`,
     `03_todos.yaml`, `.maestro/stub_server.mjs`

   Then `rps gen && rps check`. Both should pass before you commit.
4. **Design.** The app uses Flutter's default Material 3 theme. Add your own `ThemeData`
   in `lib/app/app.dart` when you are ready; there is intentionally no theme system to unwind.
5. **Read the rules.** [RULES.md](RULES.md) is short and has Do/Don't examples. CI and
   reviewers expect it: layers, use cases, named parameters and constructors, errors via
   `guard()`, localized strings.

## Add features

Generate a feature slice (paged list with optional search, create, update and delete),
run from the project root. Every prompt has a default; you can rename the plural and the API /
route paths, switch operations and the offline cache on or off, and choose which project files
the hook edits for you (see the brick README):

```bash
mason make flutter_feature
rps gen
```

You get `domain/` (entity, params, use cases, repository interface), `data/` (model, remote
and optional local data source, repository) and `presentation/` (bloc, route, wrapper that
provides the bloc, list screen with its widgets), plus an `ApiPaths` entry, the route
registered in `AppRouter`, the translation keys in both locale files and a widget test.
Left for you: the entity fields, the API contract in the remote data source and a way to
open the page (`context.router.push(const NoteRoute())`). `rps gen` also generates the
`LocaleKeys`. Details: [bricks/feature_brick](bricks/feature_brick/README.md).

## Analytics

Set `ANALYTICS_ENABLED=true` in a flavor file to keep encrypted local action,
screen and error history. Enable Firebase Analytics or set an HTTPS batch
endpoint to forward the same events remotely. Identify the user after sign-in
with an opaque account ID. [Analytics setup](lib/core/services/analytics/README.md)

## Ship it

CI and releases are designed to stay inside GitHub's free tier:

- **Pull requests** run a lean Linux check (format, analyze, custom_lint, tests). Nothing
  uses macOS runners, builds releases or runs emulators in GitHub Actions.
- **Android** is built **locally** and uploaded to a GitHub Release:
  `bash scripts/release.sh prod` (needs `gh auth login` and your signing setup,
  [docs/CODE_SIGNING.md](docs/CODE_SIGNING.md)).
- **iOS** is built on Codemagic, started manually (`codemagic.yaml`), so free macOS minutes
  are only spent when you choose.
- **End-to-end tests** run locally with Maestro: `rps maestro`.
- **Secrets** stay off GitHub: run `gitleaks detect --config .gitleaks.toml` locally or as
  a pre-commit hook.

One-time setup (App Store Connect key, env groups, signing) is in
[docs/CI_CD.md](docs/CI_CD.md).

## Commands

| Command | Does |
|---|---|
| `rps gen` / `rps watch` | code generation once / in watch mode (run after pulling or changing models, routes, injectable classes, assets or translations) |
| `rps check` | what CI checks: gen, format check, analyze, test |
| `rps analyze` | `flutter analyze` + `custom_lint` |
| `rps test` | `flutter test --coverage` |
| `rps run dev\|staging\|prod` | run a flavor |
| `rps build apk <dev\|staging\|prod>` | obfuscated release APK (`appbundle` and `ipa`: `staging` or `prod`) |
| `rps firebase:init` | create real Firebase config files from the `*.example` placeholders |
| `rps maestro` | build, install and run the end-to-end flows (Android) |
| `rps icons` | regenerate launcher icons and native splash |

## Project layout

```
lib/
├── config/      env (AppEnv), constants, firebase options, observers
├── core/
│   ├── error/ network/ storage/ session/    infrastructure
│   ├── common/  logger, navigation, notifications, app settings, permissions, DI, router
│   └── generic/ paged-list / load-state blocs, offline cache helpers
└── features/    splash -> home -> example (todos), each data / domain / presentation
```

More in [FOLDER_STRUCTURE.md](FOLDER_STRUCTURE.md).

---

## Working on the template itself

For maintainers and contributors of this repository (not for app developers):

```bash
git clone https://github.com/AlexxyQQ/flutter_all_template
cd flutter_all_template
fvm install && fvm use          # Flutter version from .fvmrc
flutter pub get
cp env/dev.example.json env/dev.json
rps firebase:init               # placeholder Firebase files so the app compiles
rps gen
rps run dev
```

The generated project brick is built **from this repo** and is git-ignored, so there is
nothing to edit or commit in `bricks/project_brick/__brick__`:

```bash
rps brick                               # dart run tool/sync_brick.dart: generate the brick
mason get && mason make flutter_all_template   # try it locally (bricks come from mason.yaml)
```

Run `rps brick` before `mason make`; CI runs it as a smoke test. Details:
[bricks/project_brick](bricks/project_brick/README.md). Read [RULES.md](RULES.md) before
opening a PR.

## Docs

| Topic | File |
|---|---|
| Coding rules with Do/Don't examples | [RULES.md](RULES.md) |
| Where things live, layering | [FOLDER_STRUCTURE.md](FOLDER_STRUCTURE.md) |
| Release flow, CI cost model, Codemagic | [docs/CI_CD.md](docs/CI_CD.md) |
| End-to-end tests (Maestro) | [docs/MAESTRO.md](docs/MAESTRO.md) |
| Flavors and compile-time config | [docs/FLAVORS.md](docs/FLAVORS.md), [env/README.md](env/README.md) |
| Android / iOS signing | [docs/CODE_SIGNING.md](docs/CODE_SIGNING.md) |
| Permissions, backups, network security | [docs/PLATFORM_SETUP.md](docs/PLATFORM_SETUP.md) |
| Secrets and security policy | [SECURITY.md](SECURITY.md) |
| Translations | [assets/translations/README.md](assets/translations/README.md) |
| Version history | [CHANGELOG.md](CHANGELOG.md) |
