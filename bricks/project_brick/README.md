# flutter_all_template — Mason Brick

A production-ready Flutter starter. Answer 5 questions and get a clean project
with only the modules you actually need.

---

## Prerequisites

```bash
dart pub global activate mason_cli
```

If you plan to use Firebase:
```bash
dart pub global activate flutterfire_cli
```

---

## Usage

### Option A — From this repo (local)

```bash
git clone https://github.com/AlexxyQQ/flutter_all_template
cd flutter_all_template
mason get
mason make flutter_all_template
```

### Option B — From brickhub.dev (once published)

```bash
mason add flutter_all_template
mason make flutter_all_template
```

---

## Questions asked during generation

| Variable | Type | Description |
|----------|------|-------------|
| `app_name` | string | App name — auto-converted to `snake_case` for the package |
| `app_org` | string | Organization (e.g. `com.example`) |
| `use_firebase` | boolean | Include Firebase (`firebase_core` + `firebase_messaging`) |
| `use_notifications` | boolean | Include push notifications (FCM + `awesome_notifications`) — requires Firebase |
| `use_permissions` | boolean | Include the permission flow (`PermissionBloc` + screen + route guard) |

---

## What each option includes / excludes

### Firebase (`use_firebase: true`)
- **Adds deps**: `firebase_core` and the `google-services` Gradle plugin
- **Keeps**: `lib/config/firebase/firebase_options.dart` (placeholders — run `flutterfire configure`), `firebase.json`, `android/app/google-services.json`
- **Without Firebase**: all of the above is removed and `main.dart` no longer initialises Firebase

### Push Notifications (`use_notifications: true`)
- **Implies Firebase** (the `pre_gen` hook switches it on and warns)
- **Adds deps**: `firebase_messaging`, `awesome_notifications`
- **Keeps**: `lib/core/common/domain/services/notification/` (FCM handlers, channels, allow-listed deep links, push-token repository) and its tests
- **Without notifications**: the service directory is removed; `bootstrap.dart` and the permission repository no longer reference it

### Permissions (`use_permissions: true`)
- **Adds deps**: `permission_handler`, `geolocator`
- **Keeps**: `lib/core/common/features/permission/` (one config-driven screen, `PermissionBloc`, `PermissionGuard`) and its tests
- **Without permissions**: the feature directory is removed and its route/gallery link are cleaned up

### Always included (core)
BLoC + GetIt/Injectable, auto_route, Dio-based `ApiClient` with refresh-token
handling, secure token storage, redacting logger, EasyLocalization, Material 3
theming, paged-list/load-state BLoCs, a Todo reference feature, design-system
widgets, splash/home screens, CI workflow and security docs.

---

## Post-generation steps

`mason make flutter_all_template` renders into `./<app_name>/`. The post-gen hook:
- renames the package from `flutter_all_template` to your app name in all `.dart` files
- sets the Android `applicationId`/`namespace`, moves `MainActivity.kt` into the new package
- sets the iOS bundle identifier
- removes the files of disabled modules

The hook prints the exact commands; in short:

```bash
cd <your_app_name>
flutterfire configure      # only if Firebase was selected
flutter pub get
dart run easy_localization:generate -S assets/translations -f keys -O lib/config/constants/gen -o locale_keys.g.dart
dart run build_runner build --delete-conflicting-outputs
dart fix --apply && dart format .         # re-sorts imports after the package rename
cp env/dev.example.json env/dev.json     # set BASE_URL
flutter run --dart-define-from-file=env/dev.json
```

> Generated files (`*.g.dart`, `*.freezed.dart`, `*.gr.dart`, `*.config.dart`,
> `lib/config/constants/gen/`) are git-ignored in the template and therefore not
> part of the brick.

---

## Maintaining the brick (do not edit `__brick__` by hand)

`__brick__/` is **generated** from this repository:

```bash
dart run tool/sync_brick.dart           # rewrite the brick from the repo
dart run tool/sync_brick.dart --check   # exit 1 if it is stale (runs in CI)
```

Optional modules are marked in the real source files with comments, which the
script turns into Mustache sections:

```dart
// brick:if use_permissions
PermissionRoute.routes,
// brick:end
```

`brick:unless <var>` is the inverse. `#` comments work in YAML. A source file
that contains a literal `{{` fails the sync unless it is listed in
`_literalBraces` (GitHub Actions expressions in `.github/` and `docs/` are).
