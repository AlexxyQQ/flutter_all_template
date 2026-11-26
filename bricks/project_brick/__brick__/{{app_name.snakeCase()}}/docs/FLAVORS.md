# Flavors & compile-time configuration

The template has three flavors — `dev`, `staging`, `prod` — implemented as
**compile-time configuration**: each flavor is a JSON file passed to Flutter with
`--dart-define-from-file`. There are no native Android `productFlavors` or iOS schemes
yet (see "Native flavors" below).

## Files

```
env/
├── dev.example.json        # tracked, placeholders only
├── staging.example.json    # tracked, placeholders only
├── prod.example.json       # tracked, placeholders only
├── dev.json                # git-ignored — your real values
├── staging.json            # git-ignored
└── prod.json               # git-ignored
```

```bash
cp env/dev.example.json env/dev.json
```

```json
{
  "FLAVOR": "dev",
  "BASE_URL": "http://10.0.2.2:8080/api/v1/",
  "ENABLE_LOG_UPLOAD": false,
  "LOG_UPLOAD_URL": "",
  "ANALYTICS_ENABLED": false,
  "ANALYTICS_API_URL": "",
  "ANALYTICS_FIREBASE_ENABLED": false,
  "DEV_PROXY": "",
  "DEV_TRUST_SELF_SIGNED_CERTS": false
}
```

The values are read in Dart through `lib/config/env/app_env.dart` (`AppEnv.flavor`,
`AppEnv.baseUrl`, …), which uses `String.fromEnvironment` / `bool.fromEnvironment`.
They are constants, so unused branches (e.g. `if (AppEnv.isDev)`) are tree-shaken.

| Key | Type | Notes |
|---|---|---|
| `FLAVOR` | string | `dev` (default if no file is passed) · `staging` · `prod` |
| `BASE_URL` | string | API root with trailing slash. Must be `https://` outside debug builds — Android blocks cleartext in release (`network_security_config.xml`) and iOS ATS blocks it everywhere |
| `ENABLE_LOG_UPLOAD` | bool | Remote log upload is **off** unless this is `true` |
| `LOG_UPLOAD_URL` | string | Used only when upload is enabled |
| `ANALYTICS_ENABLED` | bool | Analytics is **off** unless this is `true` (and a destination below is set) |
| `ANALYTICS_API_URL` | string | Absolute `https://` URL of your analytics batch endpoint; empty = not used |
| `ANALYTICS_FIREBASE_ENABLED` | bool | Also send to Firebase Analytics; only in projects generated with Firebase |
| `DEV_PROXY` | string | `host:port` for Charles/mitmproxy. Honoured only in debug builds |
| `DEV_TRUST_SELF_SIGNED_CERTS` | bool | Honoured only in debug builds. Never enable for staging/prod |

> `10.0.2.2` is the Android emulator's alias for the host machine. On iOS Simulator use
> `http://localhost:…` (and an ATS exception in a debug-only xcconfig if you need HTTP);
> on a physical device use your machine's LAN IP or an HTTPS tunnel.

## ⚠️ These values are not secret

Everything passed with `--dart-define` / `--dart-define-from-file` is embedded in the
compiled app and can be extracted from the APK/IPA. Put only **public** configuration
here (URLs, feature flags, public client IDs). Secrets belong on your backend.
See [`SECURITY.md`](../SECURITY.md).

## Running and building

| Task | rps | Plain Flutter |
|---|---|---|
| Run dev | `rps run dev` | `flutter run --dart-define-from-file=env/dev.json` |
| Run staging | `rps run staging` | `flutter run --dart-define-from-file=env/staging.json` |
| Run prod (release) | `rps run prod` | `flutter run --release --dart-define-from-file=env/prod.json` |
| APK | `rps build apk <flavor>` | `flutter build apk --release --obfuscate --split-debug-info=build/symbols/<flavor> --dart-define-from-file=env/<flavor>.json` |
| App bundle | `rps build appbundle staging\|prod` | `flutter build appbundle …` (same flags) |
| IPA | `rps build ipa staging\|prod` | `flutter build ipa …` (same flags) |

VS Code: pick **dev**, **staging**, **prod (profile mode)** or **prod (release mode)**
in the Run & Debug panel (`.vscode/launch.json`).

If no file is passed, `AppEnv` falls back to `FLAVOR=dev` with an empty `BASE_URL`.

## CI and releases

GitHub CI does not need env files to analyze or test. Release builds happen outside
GitHub Actions (see `docs/CI_CD.md`):

- Android: `bash scripts/release.sh <flavor>` reads your local `env/<flavor>.json`.
- iOS: Codemagic writes `env/<flavor>.json` from the `ENV_JSON_<FLAVOR>` secret in its
  `ios_release` environment group.

## Adding a key

1. Add it to all three `env/*.example.json` files (placeholder values).
2. Add a `static const` to `AppEnv` with a safe default.
3. Document it in the table above and in `env/README.md`.
4. Tell the team to update their local `env/*.json`.

## Native flavors (not set up yet)

To install dev/staging/prod side by side you need different application IDs:

- **Android:** add `flavorDimensions += "env"` and `productFlavors { create("dev") { applicationIdSuffix = ".dev"; resValue("string", "app_name", "App Dev") } … }` to `android/app/build.gradle.kts`, then build with `--flavor dev`.
- **iOS:** create `Debug-dev`/`Release-dev`… build configurations and a scheme per flavor in Xcode, each with its own `PRODUCT_BUNDLE_IDENTIFIER`.
- **Firebase:** use a separate Firebase project per flavor (`flutterfire configure --out=lib/config/firebase/firebase_options_dev.dart --android-package-name=….dev …`).
- Update the `rps` scripts and launch configs to pass `--flavor <name>`.
