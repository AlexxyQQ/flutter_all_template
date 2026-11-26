# End-to-end tests with Maestro

[Maestro](https://maestro.dev) drives the real app on a device or emulator with
small YAML flows. Flows live in `.maestro/flows/`.

| Flow | Needs backend? | Checks |
|---|---|---|
| `01_smoke.yaml` | no | splash hands over to Home (`home_title`) |
| `02_navigation.yaml` | no | Home -> To-dos -> back |
| `03_todos.yaml` | stub API | list loads, add a to-do through the dialog |

`_shared/launch.yaml` is a helper subflow (cold start + wait for Home).

## Install

- **macOS:** `brew install openjdk@17` then `curl -fsSL "https://get.maestro.mobile.dev" | bash`
- **Windows:** install JDK 17, download `maestro.zip` from the
  [releases page](https://github.com/mobile-dev-inc/maestro/releases), unzip and
  add its `bin` folder to `PATH`.
- Check with `maestro --version`. You also need `adb` (Android SDK platform-tools) and Node 18+ (stub API only).

## Run locally (Android)

1. Start an emulator or plug in a device (`adb devices` must list it; unlock the screen and keep it awake).
2. `rps maestro` — builds the dev debug APK, installs it, starts the stub API
   (`node .maestro/stub_server.mjs`, port 8080), forwards the port with
   `adb reverse` and runs all flows.
3. `rps maestro:fast` skips the build (`--no-build`). `rps maestro:studio` opens Maestro Studio to explore the UI.
4. One flow: `bash scripts/maestro.sh --no-build .maestro/flows/01_smoke.yaml`.

The build points `BASE_URL` at `http://localhost:8080/api/v1/`; `adb reverse`
makes that reach your machine on emulators and USB devices alike, and debug
builds allow cleartext HTTP to `localhost`. The stub keeps data in memory and
mimics the `/todos` contract documented in
`lib/features/example/data/data_sources/remote/todo_remote_data_source.dart`.
Android builds need a Firebase `google-services.json` whose package name matches
the `applicationId` (`com.alexxy.flutter_all_template`). It is git-ignored; `scripts/maestro.sh`
creates a placeholder from `google-services.json.example` (`rps firebase:init`) when it is missing.

### iOS (macOS only)

Boot a simulator, build with `flutter build ios --simulator --debug --dart-define-from-file=env/dev.json --dart-define=BASE_URL=http://localhost:8080/api/v1/`,
install it with `xcrun simctl install booted build/ios/iphonesimulator/Runner.app`,
start `node .maestro/stub_server.mjs` (the simulator shares the host's `localhost`),
then `maestro test .maestro/flows`. The app id is `com.alexxy.flutterAllTemplate`; the flows
hard-code the Android id, so pass `-e` or duplicate the `appId` line for iOS.

## Writing flows

- One small flow per user journey, numbered (`04_settings.yaml`), each with `appId`, `launchApp` (`clearState: true`) and a comment.
- Reuse steps via `- runFlow: _shared/<name>.yaml`; helpers start with the same `appId` + `---` header.
- Select widgets by **id**, not by text, so translations don't break flows:
  `tapOn: { id: todo_add_button }`.
- **Id convention: `<screen>_<thing>`** (`home_title`, `todo_save_button`). In Flutter set it
  with `Semantics(identifier: '<id>', child: ...)` — Maestro reads that as the Android
  resource-id / iOS accessibilityIdentifier. A `Key` alone is not visible to Maestro; keep
  the matching `Key` for widget tests.
- Prefer `extendedWaitUntil` over fixed sleeps.

## Why Maestro does not run in GitHub Actions

Emulators on hosted runners are slow and flaky, and they eat free-tier minutes
(Android emulators need Linux with KVM; iOS simulators need pricey macOS minutes).
CI runs format, analyze and unit/widget tests instead. Run Maestro locally before a release:

```
rps maestro        # all flows, on an emulator/device
```
