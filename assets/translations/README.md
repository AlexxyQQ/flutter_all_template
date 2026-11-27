# Translations / Locale Keys

This directory contains all localisation files for the app. Each file targets a specific locale (e.g. `en-GB.json`, `ne-NP.json`). Keys must be kept **identical across all locale files** — only the values differ.

---

## File Naming

| File | Locale |
|------|--------|
| `en-GB.json` | English (United Kingdom) — default |
| `ne-NP.json` | Nepali (Nepal) |

To add a new language, duplicate `en-GB.json`, rename it to the BCP 47 tag (e.g. `fr-FR.json`), and translate the values. Register the new locale in `AppConfig` / `EasyLocalization` setup.

---

## Key Structure Rules

Keys are **semantic**: they name *what the text is*, never *where the file lives*. Moving or
renaming a Dart file must never force a key rename. Segments are dot-separated.

```
<namespace>.<area>.<key>
```

### Top-level namespaces

| Namespace | Purpose |
|-----------|---------|
| `common` | Shared words, sentences, errors, form fields, languages |
| `features` | Everything owned by one feature: `features.<feature>.<key>` (`features.home.title`, `features.permission.camera.title`) |

Group by the thing the text describes (a screen, a permission, a dialog), not by folder:

```json
"features": {
  "home": { "title": "Home", "welcome": "Welcome" },
  "permission": {
    "camera": {
      "title": "Camera Permission",
      "message": "This app requires access to the camera.",
      "reAskTitle": "Allow Camera Access",
      "reAskMessage": "Please enable camera access in Settings to continue."
    }
  }
}
```

Generated constants join the path with `_`:

```dart
LocaleKeys.features_home_title                 // 'features.home.title'
LocaleKeys.features_permission_camera_title    // 'features.permission.camera.title'
```

### Naming rules

| Segment type | Convention | Example |
|---|---|---|
| Namespace / feature / group | `snake_case` or a single lowercase word | `features`, `permission`, `user_profile` |
| Leaf key | `camelCase` | `title`, `reAskMessage`, `noInternet` |

Common leaf keys: `title`, `message`, `subtitle`, `hint` / `*Hint`, `label`, `reAskTitle`,
`reAskMessage`. Keep the same leaf names across features so screens read alike.

---

## Shared / Common Keys

Avoid duplicating strings. Use the `common` namespace for anything reused across multiple screens:

```json
"common": {
  "words": {
    "continue": "Continue",
    "cancel": "Cancel"
  },
  "sentences": {
    "mayBeLater": "May Be Later"
  },
  "errors": {
    "network": { ... },
    "validation": { ... }
  }
}
```

In Dart:
```dart
LocaleKeys.common_words_continue   // 'common.words.continue'
LocaleKeys.common_sentences_mayBeLater
```

---

## Generating `locale_keys.g.dart`

The file `lib/config/constants/gen/locale_keys.g.dart` is auto-generated from the JSON by `easy_localization`:

```bash
dart run easy_localization:generate \
  -S assets/translations \
  -O lib/config/constants/gen \
  -o locale_keys.g.dart \
  -f keys
```

> If the Dart SDK version prevents running codegen, add the new constants **manually** to `locale_keys.g.dart` following the existing pattern:
> ```dart
> static const your_namespace_screen_title = 'your.namespace.screen.title';
> ```
> The value is always the dot-joined key path from the JSON.

---

## Adding a New Key — Checklist

1. **Add to `en-GB.json`** under the correct nested path.
2. **Add to all other locale files** (`ne-NP.json`, etc.) with a translated value.
3. **Regenerate `locale_keys.g.dart`** via codegen, or manually add the constant.
4. **Reference in Dart** using `LocaleKeys.<generated_constant>`.

---

## Parameter Interpolation

Use `{paramName}` for dynamic values:

```json
"greeting": "Hello, {name}!"
```

```dart
LocaleKeys.greeting.tr(namedArgs: {'name': 'Alex'})
```

Multiple parameters:
```json
"validation": {
  "minLength": "{field} must be at least {minLength} characters"
}
```

```dart
LocaleKeys.common_errors_validation_minLength.tr(
  namedArgs: {'field': 'Password', 'minLength': '8'},
)
```

---

## Complete Permission Example

JSON (`en-GB.json`):
```json
"features": {
  "permission": {
    "camera": {
      "title": "Camera Permission",
      "message": "This app requires access to the camera.",
      "reAskTitle": "Allow Camera Access",
      "reAskMessage": "Please enable camera access in Settings to continue."
    }
  }
}
```

Dart usage:
```dart
Text(LocaleKeys.features_permission_camera_title.tr())
```
