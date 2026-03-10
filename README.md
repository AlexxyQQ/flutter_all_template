# Flutter All Template

A production-ready Flutter starter template built on Clean Architecture, Material 3, and a fully pre-wired BLoC + DI stack. Pick only the modules you need — powered by [Mason](https://pub.dev/packages/mason_cli).

---

## Quick Start (Mason — Recommended)

Generate a new project with only the features you want:

```bash
# 1. Install Mason (once)
dart pub global activate mason_cli

# 2. Clone this repo and enter the brick directory
git clone https://github.com/AlexxyQQ/flutter_all_template
cd flutter_all_template/brick

# 3. Register the brick locally
mason init
mason add --path .

# 4. Generate your project — answer 5 questions
mason make flutter_all_template
# → What is the app name? › my_app
# → Organization (e.g. com.example)? › com.example
# → Include Firebase? (y/N) › n
# → Include push notifications? (y/N) › n
# → Include permission screens? (y/N) › y

# 5. Enter your new project and set up
cd my_app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

See [brick/README.md](brick/README.md) for full details on what each option includes.

---

## Manual Quick Start (clone as-is)

```bash
# 1. Clone / copy the repo
# 2. Install dependencies
flutter pub get

# 3. Copy env file and fill in values
cp env/.env.example env/.env

# 4. Generate code (routes, DI, JSON, Freezed, assets)
dart run build_runner build --delete-conflicting-outputs

# 5. Generate localisation keys
dart run easy_localization:generate \
  -S assets/translations -f keys \
  -O lib/config/constants/gen -o locale_keys.g.dart

# 6. Run
flutter run
```

> **Tip:** Use [rps](https://pub.dev/packages/rps) to run the scripts defined in `pubspec.yaml`:
> `rps build` · `rps clean` · `rps gen` · `rps analyze`

---

## Project Structure

```
lib/
├── config/
│   ├── constants/          # API, colours, text, enums, asset gen, locales
│   ├── firebase/           # Firebase options (generated)
│   ├── observers/          # Route observer
│   └── themes/             # Material 3 theme + component themes
├── core/
│   ├── abstract/           # Abstract colour / text style interfaces
│   ├── common/
│   │   ├── data/           # Shared model helpers (annotation, conversion, generation)
│   │   ├── domain/
│   │   │   ├── controllers/   # TextEditingController factory
│   │   │   ├── entities/      # Failure, FilterParams (Freezed)
│   │   │   └── services/
│   │   │       ├── files/        # File log output
│   │   │       ├── logger/       # AppLogger ← README inside
│   │   │       ├── navigation/   # NavigationService ← README inside
│   │   │       ├── network/      # DioService + ApiHandler ← README inside
│   │   │       ├── notification/ # Push notifications ← README inside
│   │   │       └── storage/      # SecureStorageService ← README inside
│   │   ├── features/
│   │   │   ├── app_settings/  # Settings BLoC + local persistence ← README inside
│   │   │   └── permission/    # Permission handling module ← README inside
│   │   ├── locator/           # GetIt / Injectable setup
│   │   └── presentation/
│   │       ├── blocs/         # Global BLoC providers (Theme, Locale)
│   │       ├── extensions/    # BuildContext extensions ← README inside
│   │       ├── helpers/       # SnackbarHelper, FilePickerHelper
│   │       ├── routes/        # AppRouter (auto_route)
│   │       ├── themes/        # Colour + text resolvers
│   │       └── views/
│   │           ├── pages/     # Shared dialogs & bottom sheets
│   │           ├── routes/    # Dialog / bottom-sheet route wrappers
│   │           └── widgets/
│   │               ├── common/   # Error widget, empty state
│   │               └── system/   # Reusable UI components ← README inside
│   └── generic/
│       ├── data/              # SecureStorage data source, base cache
│       ├── domain/            # BaseCacheService
│       └── presentation/
│           └── bloc/crud/     # Generic CRUD BLoC + mixins ← README inside
├── features/
│   ├── splash/                # Splash screen + design component showcase
│   └── another/               # Example second feature / screen
├── core/app.dart              # MaterialApp.router entry
├── core/bootstrap.dart        # App initialisation (DI, notifications, locale)
└── main.dart                  # Entrypoint
```

---

## Module READMEs

Each reusable module has its own README explaining how to copy and configure it:

| Module | README |
|--------|--------|
| Logger Service | [lib/core/common/domain/services/logger/README.md](lib/core/common/domain/services/logger/README.md) |
| Network (DioService + ApiHandler) | [lib/core/common/domain/services/network/README.md](lib/core/common/domain/services/network/README.md) |
| Secure Storage | [lib/core/common/domain/services/storage/README.md](lib/core/common/domain/services/storage/README.md) |
| Navigation Service | [lib/core/common/domain/services/navigation/README.md](lib/core/common/domain/services/navigation/README.md) |
| Push Notifications | [lib/core/common/domain/services/notification/docs/README.md](lib/core/common/domain/services/notification/docs/README.md) |
| Permission Handling | [lib/core/common/features/permission/README.md](lib/core/common/features/permission/README.md) |
| Translations / Locale Keys | [assets/translations/README.md](assets/translations/README.md) |
| App Settings Feature | [lib/core/common/features/app_settings/README.md](lib/core/common/features/app_settings/README.md) |
| Base CRUD BLoC | [lib/core/generic/presentation/bloc/crud/README.md](lib/core/generic/presentation/bloc/crud/README.md) |
| Theme System | [lib/config/themes/README.md](lib/config/themes/README.md) |
| Context Extensions | [lib/core/common/presentation/extensions/README.md](lib/core/common/presentation/extensions/README.md) |
| System Widgets | [lib/core/common/presentation/views/widgets/system/README.md](lib/core/common/presentation/views/widgets/system/README.md) |

---

## Key Dependencies

| Category | Package | Version |
|----------|---------|---------|
| State Management | `flutter_bloc` | ^9.1.1 |
| DI / Service Locator | `get_it` + `injectable` | ^9.2.0 / ^2.7.1 |
| Navigation | `auto_route` | ^11.1.0 |
| HTTP | `dio` | ^5.9.0 |
| Functional types | `fpdart` | ^1.2.0 |
| Secure Storage | `flutter_secure_storage` | ^10.0.0 |
| Localisation | `easy_localization` | ^3.0.8 |
| Responsive UI | `flutter_screenutil` | ^5.9.3 |
| Push Notifications | `firebase_messaging` + `awesome_notifications` | ^16.1.1 / ^0.10.1 |
| Logging | `logger` | ^2.6.2 |
| Code generation | `freezed`, `json_serializable`, `build_runner` | latest |

---

## Code Generation

Run after any model, route, or DI annotation change:

```bash
dart run build_runner build --delete-conflicting-outputs
# or
rps build
```

Watch mode during development:

```bash
rps watch
```

---

## Environment Variables

Create `env/.env` (never commit this file):

```env
BASE_URL=https://api.your-app.com
ALLOW_HTTP=false
# PROXY=192.168.1.5:8888   # uncomment for Charles/mitmproxy
```

Loaded at startup via `flutter_dotenv`.

---

## Localisation

Translation files live in `assets/translations/`. See [assets/translations/README.md](assets/translations/README.md) for the full key-naming convention.

After adding new keys to the JSON, regenerate `locale_keys.g.dart`:

```bash
rps gen
# expands to:
dart run easy_localization:generate \
  -S assets/translations -f keys \
  -O lib/config/constants/gen -o locale_keys.g.dart
```

Use generated keys in code:

```dart
Text(LocaleKeys.common_errors_somethingWentWrong.tr())
```

> **Note:** If codegen cannot run (SDK version mismatch), add the new `static const` entries manually to `lib/config/constants/gen/locale_keys.g.dart` following the existing pattern — the value is always the dot-joined JSON key path.

---

## Firebase Setup

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com).
2. Run `flutterfire configure` to generate `lib/config/firebase/firebase_options.dart`.
3. For push notifications, follow [lib/core/common/domain/services/notification/docs/NOTIFICATION_SETUP.md](lib/core/common/domain/services/notification/docs/NOTIFICATION_SETUP.md).

---

## Adding a New Feature

1. Create `lib/features/<feature_name>/` with `data/`, `domain/`, `presentation/` layers.
2. Create a `*_bloc.dart` extending `BaseCrudBloc` with the mixins you need.
3. Register the BLoC with `@injectable`.
4. Add routes with `@RoutePage()` and register in `AppRouter`.
5. Run `build_runner`.

---

## Scripts (via `rps`)

```bash
rps get       # flutter clean + pub get
rps build     # build_runner + gen
rps clean     # full clean + lint
rps analyze   # flutter analyze + custom lint
rps gen       # regenerate localisation keys
rps icons     # regenerate splash + app icons
rps build:apk      # release APK
rps build:ipa      # release IPA
```
