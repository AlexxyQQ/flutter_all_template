# flutter_all_template project brick

Generates a barebones Flutter project (Clean Architecture, BLoC, Material 3) with only
the optional modules you pick.

```bash
dart pub global activate mason_cli
git clone https://github.com/AlexxyQQ/flutter_all_template && cd flutter_all_template
dart run tool/sync_brick.dart          # generates __brick__ from the repo (git-ignored)
mason get
mason make flutter_all_template        # renders into ./<app_name>/
```

**Windows:** do not install this brick with `mason add --git-url ...`. Mason's git cache path plus the brick's deep file paths exceed the 260-character limit (`PathNotFoundException: Directory listing failed`). Clone to a short path (e.g. `C:\src\fat`) and use `mason add -g flutter_all_template --path C:\src\fat\bricks\project_brick`. See the root README.

| Variable | Meaning | Default |
|---|---|---|
| `app_name` | App name; snake_cased for the package | `my_flutter_app` |
| `app_org` | Organization id, e.g. `com.example` (reverse-domain, validated) | `com.example` |
| `app_display_name` | Name under the launcher icon (Android label, iOS `CFBundleDisplayName`). Empty derives it from `app_name` (`my_shop` → `My Shop`) | derived |
| `base_url` | Dev API base URL written to `env/dev.example.json`. A trailing `/` is added if missing (`ApiPaths` entries are relative to it). Empty keeps the emulator default `http://10.0.2.2:8080/api/v1/` | emulator default |
| `use_firebase` | `firebase_core`, FlutterFire placeholders (`*.example`, materialised by the post-gen hook, git-ignored), google-services plugin | `false` |
| `use_notifications` | FCM + `awesome_notifications` service (implies Firebase) | `false` |
| `use_permissions` | `PermissionBloc`, screen and route guard (`permission_handler`, `geolocator`) | `false` |
| `use_ci` | `.github/` (PR CI, weekly OSV scan, Dependabot) and `.gitleaks.toml` | `true` |
| `use_codemagic` | `codemagic.yaml` (cloud builds and store delivery) | `true` |
| `use_maestro` | `.maestro/`, `scripts/maestro.sh`, `docs/MAESTRO.md` and the `rps maestro*` scripts | `true` |

Disabled modules are removed (files, dependencies, route and bootstrap references). `docs/CI_CD.md`
is dropped only when both `use_ci` and `use_codemagic` are off.

Mason prompts for every variable missing from a `-c config.json` and fails when there is no
terminal, so for CI or scripts list all of them:

```json
{
  "app_name": "my_shop", "app_org": "com.acme", "app_display_name": "My Shop",
  "base_url": "https://api.acme.dev/v1/", "use_firebase": false,
  "use_notifications": false, "use_permissions": false,
  "use_ci": true, "use_codemagic": false, "use_maestro": false
}
```

## What the hooks do

- `pre_gen.dart`: switches Firebase on when notifications are selected, rejects an invalid
  `app_name` / `app_org` / `base_url`, and derives the display name.
- `post_gen.dart`: renames the package, sets the Android `applicationId` and moves
  `MainActivity.kt`, sets the iOS bundle id, rewrites the template name and bundle ids in
  `codemagic.yaml`, `scripts/`, `.maestro/`, `docs/` and `.github/`, sets the launcher display name
  and the dev `BASE_URL`, deletes disabled modules and delivery tooling, and prints the next steps.

## What generated projects contain

The app, tests, and the delivery tooling: lean PR CI (`.github/workflows/ci.yml`), weekly
OSV scan, Dependabot, `codemagic.yaml`, `scripts/release.sh`, `.maestro/` with
`scripts/maestro.sh`, and `docs/` (CI_CD, MAESTRO, FLAVORS, CODE_SIGNING, PLATFORM_SETUP).
Each of the three delivery pieces can be switched off (see the table). Not shipped: `bricks/`,
`tool/`, mason files, `CHANGELOG.md`, the template README (replaced by a short project README),
the `brick` rps script and the brick-generation CI step.

## Next steps in the generated project

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart run easy_localization:generate -S assets/translations -f keys -O lib/config/constants/gen -o locale_keys.g.dart
dart fix --apply && dart format .
cp env/dev.example.json env/dev.json     # set BASE_URL
flutter run --dart-define-from-file=env/dev.json
```

## Maintaining the brick

`__brick__/` is generated from the repo and git-ignored: never edit or commit it. Generate
it on demand (CI runs the same command as a smoke test):

```bash
dart run tool/sync_brick.dart
```

Optional regions in source files are marked with comments that become Mustache sections:
`// brick:if <var>`, `// brick:unless <var>`, `// brick:end` (`#` in YAML; each marker alone on its
line: `dart format` must not move it next to code), and
`brick:repo-only ... brick:end` drops a region from the brick entirely. A file containing a
literal `{{` must be listed in `_literalBraces` in `tool/sync_brick.dart`. Exclusions live in
`_excluded` in the same file.
