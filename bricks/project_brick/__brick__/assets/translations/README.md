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

Keys mirror the **file-system path** of the screen or feature that uses them, using dot-separated segments. Every segment uses `snake_case`.

```
<top_level>.<feature_path>.<screen_or_component>.<key>
```

### Top-level namespaces

| Namespace | Purpose |
|-----------|---------|
| `common` | Shared words, sentences, errors, form fields, currencies, calendar labels |
| `core` | Core infrastructure features (e.g. permission screens) |
| `features` | App-specific feature screens and widgets |

---

## Nesting Convention

The JSON structure must reflect the **Dart import path** of the widget/screen that consumes the key:

```
lib/core/common/features/permission/presentation/view/screens/camera_permission_screen.dart
                 ↓
core.common.features.permission.presentation.screens.camera_permission_screen.title
```

> The `view/` segment is omitted by convention — jump directly from `presentation` to `screens`.

### Example — Adding a new screen

Dart file path:
```
lib/features/auth/presentation/view/screens/login_screen.dart
```

JSON entry:
```json
"features": {
  "auth": {
    "presentation": {
      "screens": {
        "login_screen": {
          "title": "Sign In",
          "subtitle": "Welcome back!",
          "emailHint": "Enter your email",
          "passwordHint": "Enter your password"
        }
      }
    }
  }
}
```

Generated `LocaleKeys` constant:
```dart
LocaleKeys.features_auth_presentation_screens_login_screen_title
// resolves to → 'features.auth.presentation.screens.login_screen.title'
```

---

## Segment Naming Rules

| Segment type | Convention | Example |
|---|---|---|
| Feature / module | `snake_case` | `auth`, `permission`, `user_profile` |
| Screen | `snake_case` + `_screen` suffix | `login_screen`, `camera_permission_screen` |
| Widget / component | `snake_case` + `_widget` or descriptive name | `delete_item_bottom_sheet` |
| Leaf key | `camelCase` | `title`, `reAskMessage`, `noInternet` |

> Leaf keys (the innermost keys that hold string values) use **camelCase**.
> All structural/namespace keys use **snake_case**.

---

## Standard Leaf Keys Per Screen

Every permission screen (and most feature screens) should follow this structure:

```json
"<name>_permission_screen": {
  "title": "Human-readable permission title",
  "message": "Explanation shown to the user",
  "dialog": {
    "reAskTitle": "Dialog title when permanently denied",
    "reAskMessage": "Dialog message directing user to Settings"
  }
}
```

Common leaf keys used across the app:

| Key | Usage |
|-----|-------|
| `title` | Screen or section heading |
| `message` | Descriptive body text |
| `subtitle` | Secondary heading |
| `hint` / `*Hint` | Text field placeholder |
| `label` | Button or form field label |
| `dialog.reAskTitle` | Confirmation dialog title |
| `dialog.reAskMessage` | Confirmation dialog body |
| `error.*` | Validation or network error messages |

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

## Complete Permission Screen Example

JSON (`en-GB.json`):
```json
"core": {
  "common": {
    "features": {
      "permission": {
        "presentation": {
          "screens": {
            "camera_permission_screen": {
              "title": "Camera Permission",
              "message": "This app requires access to the camera.",
              "dialog": {
                "reAskTitle": "Allow Camera Access",
                "reAskMessage": "Please enable camera access in Settings to continue."
              }
            }
          }
        }
      }
    }
  }
}
```

Dart usage:
```dart
AppText(LocaleKeys
    .core_common_features_permission_presentation_screens_camera_permission_screen_title
    .tr())
```
