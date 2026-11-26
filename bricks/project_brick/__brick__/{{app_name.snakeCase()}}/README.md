# {{app_name.titleCase()}}

Flutter app generated from the Flutter All Template: Clean Architecture, BLoC,
get_it + injectable, auto_route, Freezed, Material 3.

## First run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart run easy_localization:generate -S assets/translations -f keys -O lib/config/constants/gen -o locale_keys.g.dart
dart fix --apply && dart format .
cp env/dev.example.json env/dev.json   # then edit BASE_URL
flutter run --dart-define-from-file=env/dev.json
```

Generated code (`*.g.dart`, `*.freezed.dart`, `*.gr.dart`, `*.config.dart`, locale
keys) is git-ignored. Re-run the two generators after changing models, routes,
injectable classes or translations.

## Docs

- `FOLDER_STRUCTURE.md` - where things live and the layering rules
- `RULES.md` - coding rules with do/don't examples (read before your first PR)
- `docs/CI_CD.md` - PR CI, local Android releases, Codemagic for iOS
- `docs/MAESTRO.md` - end-to-end tests
- `docs/FLAVORS.md`, `docs/CODE_SIGNING.md`, `docs/PLATFORM_SETUP.md`
- `SECURITY.md` - secret handling and release hardening
