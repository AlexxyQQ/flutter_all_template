# Theme System

A two-layer theming architecture that separates **primitive colours / typography** from **semantic tokens** and wires both into Material 3's `ThemeData`.

## Directory Structure

```
config/
├── constants/
│   ├── colors/
│   │   ├── custom/
│   │   │   ├── custom_primitive_colors.dart      # Raw hex values
│   │   │   └── custom_semantics.dart             # Semantic aliases (light + dark)
│   │   └── material/
│   │       ├── material_primitive_colors.dart    # Raw hex values
│   │       └── material_semantics.dart           # Material 3 colour roles
│   └── text/
│       ├── custom/
│       │   ├── app_custom_text_primitives.dart   # Font size / weight constants
│       │   └── app_custom_text_style.dart        # Named text styles
│       └── material/
│           ├── app_material_text_primitives.dart
│           └── app_material_text_style.dart
└── themes/
    ├── components_theme/                          # Per-component Freezed theme objects
    │   ├── app_button_theme.dart
    │   ├── app_chip_theme.dart
    │   ├── app_icon_theme.dart
    │   ├── app_picture_theme.dart
    │   ├── app_radio_button_theme.dart
    │   ├── app_text_form_field_theme.dart
    │   └── components_theme_exports.dart
    ├── custom_app_theme.dart                      # Custom ThemeExtension (non-Material)
    └── material_app_theme.dart                    # MaterialApp ThemeData factory

core/common/presentation/themes/
├── colors/
│   └── app_material_colors.dart                  # InheritedWidget colour resolver
├── text/
│   └── (text style resolver)
└── styles/
    └── (style helpers)
```

## How the Colour System Works

### Layer 1 — Primitives

Raw colour values with no semantic meaning:

```dart
// config/constants/colors/material/material_primitive_colors.dart
class MaterialPrimitiveColors {
  static const Color blue500 = Color(0xFF2196F3);
  static const Color grey100 = Color(0xFFF5F5F5);
  // ...
}
```

### Layer 2 — Semantics

Maps primitives to semantic roles for light and dark:

```dart
// config/constants/colors/material/material_semantics.dart
class MaterialSemantics {
  static Color primary(Brightness brightness) =>
      brightness == Brightness.light
          ? MaterialPrimitiveColors.blue500
          : MaterialPrimitiveColors.blue200;

  static Color surface(Brightness brightness) => ...;
}
```

### Layer 3 — `AppMaterialColors` (InheritedWidget)

Provides semantic colours through `context.colors`:

```dart
// Access anywhere in the widget tree
final primary = context.colors.primary;
final surface = context.colors.surface;
```

### Layer 4 — `MaterialAppTheme`

Builds `ThemeData` from the semantic layer:

```dart
ThemeData getTheme({required ThemeMode theme, required BuildContext context}) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      primary: context.colors.primary,
      surface: context.colors.surface,
      // ... all M3 roles
    ),
    textTheme: TextTheme(
      displayLarge: context.textStyles.displayLarge,
      // ...
    ),
  );
}
```

## Adding a New Colour

1. Add the hex value to the appropriate `*_primitive_colors.dart`.
2. Create a semantic alias in `*_semantics.dart` for both light and dark.
3. Expose via `AppMaterialColors` or the custom theme extension.
4. Access with `context.colors.yourNewColor`.

## Component Themes

Each widget family has a dedicated Freezed theme object in `components_theme/`. They are resolved through the custom `ThemeExtension` registered in `MaterialAppTheme`:

```dart
// Usage
final buttonTheme = context.appTheme.button;
final chipTheme   = context.appTheme.chip;
```

To add a new component theme:
1. Create `app_your_widget_theme.dart` with `@freezed`.
2. Add it to the `CustomAppTheme` extension class.
3. Export from `components_theme_exports.dart`.

## Light / Dark Mode

Theme mode is driven by `ThemeCubit` (stored in `AppSetting`). `MaterialApp.router` listens:

```dart
MaterialApp.router(
  themeMode: themeState.themeMode,
  theme:     MaterialAppTheme.getTheme(theme: ThemeMode.light, context: context),
  darkTheme: MaterialAppTheme.getTheme(theme: ThemeMode.dark,  context: context),
)
```

Toggle from UI:

```dart
context.read<AppSettingBloc>().add(
  UpdateSettingEvent(data: (s) => s.copyWith(isDarkMode: !s.isDarkMode)),
);
```

## Copying to a New Project

1. Copy `config/constants/colors/`, `config/constants/text/`, and `config/themes/`.
2. Copy `core/common/presentation/themes/`.
3. Update primitive colour values to match your design system.
4. Register `MaterialAppTheme.getTheme(...)` in your `MaterialApp`.
5. Run `build_runner` to regenerate Freezed component theme files.
