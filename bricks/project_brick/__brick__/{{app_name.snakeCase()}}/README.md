# {{app_name.titleCase()}}

Generated from the Flutter All Template (Clean Architecture, BLoC, get_it +
injectable, auto_route, Freezed, Material 3).

## First run

```bash
flutter pub get
dart run easy_localization:generate -S assets/translations -f keys -O lib/config/constants/gen -o locale_keys.g.dart
dart run build_runner build --delete-conflicting-outputs
dart fix --apply && dart format .
cp env/dev.example.json env/dev.json   # then edit BASE_URL
flutter run --dart-define-from-file=env/dev.json
```

Generated code (`*.g.dart`, `*.freezed.dart`, `*.gr.dart`, `*.config.dart`,
locale keys) is git-ignored; re-run the two generators above after changing
models, routes, injectable classes or translations.

## Read next

- `FOLDER_STRUCTURE.md` - where things live and the layering rules
- `SECURITY.md` - secret handling and release hardening checklist
- `docs/FLAVORS.md`, `docs/CODE_SIGNING.md`, `docs/PLATFORM_SETUP.md`
