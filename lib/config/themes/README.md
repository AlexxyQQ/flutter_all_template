# Theming

One theme system: **Material 3 `ColorScheme` + a `ThemeExtension<AppTokens>`**.
No colours or text styles live in blocs or static globals; everything is read
from the nearest `Theme`, so light/dark switches and local `Theme(...)`
overrides just work.

```
material_primitive_colors.dart   raw tonal palettes (AppMaterialPrimitives)
        ↓
material_semantics.dart          AppColorSchemes.light / .dark  (const ColorScheme)
app_tokens.dart                  AppTokens.light / .dark        (success, warning, info, …)
app_material_text_style.dart     AppMaterialTextStyles.textTheme()
        ↓
app_theme.dart                   AppTheme.light() / AppTheme.dark()  → ThemeData
material_app_theme.dart          MaterialAppTheme.getTheme(theme:, context:)  (compat shim)
```

## Using it in widgets

```dart
import '…/presentation/extensions/theme/theme_extension.dart';

Container(color: context.colors.primaryContainer);          // ColorScheme
Text('x', style: context.textStyles.bodyLarge);             // non-null TextTheme view
Icon(Icons.check, color: context.tokens.success.color);     // AppTokens
if (context.isDarkMode) { … }
```

## Adding a token

1. Add a field to `AppTokens` (and to `copyWith`/`lerp`).
2. Give it a value in both `AppTokens.light` and `AppTokens.dark`.

## Changing the brand palette

Edit `AppMaterialPrimitives` (or point `AppColorSchemes` at different tones).
Fonts are declared in `AppMaterialTextPrimitives`; pass `useBrandFonts: false`
to `AppTheme.light()/dark()` to fall back to the platform font (handy in tests).

## Text scaling

Font sizes are logical pixels. Clamp extreme accessibility scales at the app
root with `AppTextScaler.builder()`
(`lib/core/common/presentation/helpers/app_text_scaler.dart`).
