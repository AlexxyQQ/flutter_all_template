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
| `app_org` | Organization id, e.g. `com.example` | `com.example` |
| `use_firebase` | `firebase_core`, FlutterFire placeholders (`*.example`, materialised by the post-gen hook, git-ignored), google-services plugin | `false` |
| `use_notifications` | FCM + `awesome_notifications` service (implies Firebase) | `false` |
| `use_permissions` | `PermissionBloc`, screen and route guard (`permission_handler`, `geolocator`) | `false` |

Disabled modules are removed (files, dependencies, route and bootstrap references).

## What the hooks do

- `pre_gen.dart`: switches Firebase on when notifications are selected.
- `post_gen.dart`: renames the package, sets the Android `applicationId` and moves
  `MainActivity.kt`, sets the iOS bundle id, rewrites the template name and bundle ids in
  `codemagic.yaml`, `scripts/`, `.maestro/`, `docs/` and `.github/`, deletes disabled modules,
  and prints the next steps.

## What generated projects contain

The app, tests, and the delivery tooling: lean PR CI (`.github/workflows/ci.yml`), weekly
OSV scan, Dependabot, `codemagic.yaml`, `scripts/release.sh`, `.maestro/` with
`scripts/maestro.sh`, and `docs/` (CI_CD, MAESTRO, FLAVORS, CODE_SIGNING, PLATFORM_SETUP).
Not shipped: `bricks/`, `tool/`, mason files, `CHANGELOG.md`, the template README (replaced
by a short project README), the `brick` rps script and the brick-generation CI step.

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
`// brick:if <var>`, `// brick:unless <var>`, `// brick:end` (`#` in YAML), and
`brick:repo-only ... brick:end` drops a region from the brick entirely. A file containing a
literal `{{` must be listed in `_literalBraces` in `tool/sync_brick.dart`. Exclusions live in
`_excluded` in the same file.
