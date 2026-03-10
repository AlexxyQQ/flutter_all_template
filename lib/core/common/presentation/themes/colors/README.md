# Color System

This app has **two parallel color systems** that serve different purposes.

| System | Class | Purpose |
|---|---|---|
| **Material** | `AppMaterialColors` | Full M3 color scheme (primary, surface, error, etc.) |
| **Custom** | `AppCustomColors` | App-specific semantics (icons, borders, states, etc.) |

Both systems are theme-aware and automatically switch between light and dark palettes.

---

## Architecture Overview

```
Primitives  →  Semantics  →  Registry  →  Consumer
─────────────────────────────────────────────────────────────────────────
material_primitive_colors.dart   (raw hex values — never use directly)
        ↓
material_semantics.dart          (maps primitives to roles: light + dark)
        ↓
app_material_colors.dart         (AppMaterialColors — static registry + context helper)
        ↓
context.colors / AppMaterialColors.primary   (consumption in widgets / non-widget code)


custom_primitive_colors.dart     (raw hex values — never use directly)
        ↓
custom_semantics.dart            (maps primitives to roles: light + dark)
        ↓
app_custom_colors.dart           (AppCustomColors — static registry + context helper)
        ↓
AppCustomColors.icon / AppCustomColors.border   (consumption in non-widget code)
```

---

## How to Use Colors

### 1. Inside a `build()` method — reactive (recommended)

`context.colors` watches `ThemeCubit` and rebuilds the widget whenever the theme changes.

```dart
import 'package:your_app/core/common/presentation/extensions/theme/theme_extension.dart';

@override
Widget build(BuildContext context) {
  return Container(
    color: context.colors.surface,
    child: Text(
      'Hello',
      style: TextStyle(color: context.colors.onSurface),
    ),
  );
}
```

Extended M3 colors (income, expense, warning, saving, success):
```dart
color: context.colors.income.color,
color: context.colors.income.colorContainer,
color: context.colors.expense.onColor,
color: context.colors.warning.onColorContainer,
```

### 2. Inside a callback or async function — one-time read

Use `context.readColors` when you need the color once without subscribing to changes.
Safe inside `onTap`, `onPressed`, `initState`, etc.

```dart
onTap: () {
  final errorColor = context.readColors.error;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(backgroundColor: errorColor),
  );
},
```

### 3. Outside the widget tree — static API

Both registries expose static getters that are kept in sync by `ThemeCubit`. Use these
in repositories, utilities, or any code without a `BuildContext`.

```dart
// Material colors
import 'package:your_app/core/common/presentation/themes/colors/app_material_colors.dart';

final bg     = AppMaterialColors.surface;
final accent = AppMaterialColors.primary;
final error  = AppMaterialColors.error;
final income = AppMaterialColors.income.color;

// Custom colors
import 'package:your_app/core/common/presentation/themes/colors/app_custom_colors.dart';

final iconColor    = AppCustomColors.icon;
final borderColor  = AppCustomColors.border;
final disabledColor = AppCustomColors.disabled;
```

### Quick reference

| Situation | API | Rebuilds on theme change? |
|---|---|---|
| Widget `build()` | `context.colors.primary` | Yes |
| Callback / async | `context.readColors.primary` | No |
| Non-widget code | `AppMaterialColors.primary` | No (always current) |

---

## How to Add a New Custom Color

Follow these 4 steps. Example: adding a `highlight` color.

### Step 1 — Add the primitive value(s)

`lib/config/constants/colors/material/material_primitive_colors.dart`

```dart
abstract class AppMaterialPrimitives {
  // ... existing colors ...

  // --- Highlight (example custom extended color) ---
  static const KAppColor highlight = KAppColor(0xFFFFD700);
  static const KAppColor highlight100 = KAppColor(0xFFFFFFFF);
  static const KAppColor highlight90  = KAppColor(0xFFFFF9C4);
  static const KAppColor highlight80  = KAppColor(0xFFFFF176);
  static const KAppColor highlight20  = KAppColor(0xFFF57F17);
  static const KAppColor highlight10  = KAppColor(0xFF3E2723);
}
```

> For the **custom** system, add to `lib/config/constants/colors/custom/custom_primitive_colors.dart` instead.

### Step 2 — Add the semantic role to the abstract contract

`lib/core/abstract/presentation/abstract_material_color_semantic.dart`

```dart
abstract class MaterialSemanticColors {
  // ... existing fields ...

  // Extended
  abstract final MaterialExtendedSemanticColors highlight; // add this
}
```

> For the **custom** system, add to `lib/core/abstract/presentation/abstract_custom_color_semantic.dart` instead.

### Step 3 — Implement in light and dark semantics

`lib/config/constants/colors/material/material_semantics.dart`

```dart
class MaterialLightSemantic implements MaterialSemanticColors {
  // ... existing fields ...

  @override
  final highlight = const ExtendedSemanticColorsImpl(
    color:            AppMaterialPrimitives.highlight,
    onColor:          AppMaterialPrimitives.highlight100,
    colorContainer:   AppMaterialPrimitives.highlight90,
    onColorContainer: AppMaterialPrimitives.highlight10,
  );
}

class MaterialDarkSemantic implements MaterialSemanticColors {
  // ... existing fields ...

  @override
  final highlight = const ExtendedSemanticColorsImpl(
    color:            AppMaterialPrimitives.highlight80,
    onColor:          AppMaterialPrimitives.highlight10,
    colorContainer:   AppMaterialPrimitives.highlight20,
    onColorContainer: AppMaterialPrimitives.highlight90,
  );
}
```

### Step 4 — Expose it through the registry

`lib/core/common/presentation/themes/colors/app_material_colors.dart`

```dart
class AppMaterialColors {
  // ... existing getters ...

  static MaterialExtendedSemanticColors get highlight => _current.highlight;
}
```

That's it. After these 4 steps the color is available everywhere:

```dart
// In a widget
context.colors.highlight.color

// In non-widget code
AppMaterialColors.highlight.colorContainer
```

---

## Adding a Simple (Non-Extended) Color to the Custom System

For flat colors (not a 4-role extended group), the process is simpler.
Example: adding a `badge` color.

**Step 1** — Add primitive to `custom_primitive_colors.dart`:
```dart
static const KAppColor badgeRed = KAppColor(0xFFE53935);
```

**Step 2** — Add field to `abstract_custom_color_semantic.dart`:
```dart
abstract final KAppColor badge;
```

**Step 3** — Implement in `AppCustomLightSemantics` and `AppCustomDarkSemantics`:
```dart
@override
KAppColor get badge => AppCustomPrimitives.badgeRed;
```

**Step 4** — Expose in `app_custom_colors.dart`:
```dart
static KAppColor get badge => _current.badge;
```

---

## Files Reference

| File | Role |
|---|---|
| `material_primitive_colors.dart` | Raw M3 palette hex values |
| `material_semantics.dart` | Maps primitives to M3 roles for light/dark |
| `app_material_colors.dart` | Static registry + `of(context)` helper |
| `custom_primitive_colors.dart` | Raw custom palette hex values |
| `custom_semantics.dart` | Maps primitives to custom roles for light/dark |
| `app_custom_colors.dart` | Static registry for custom colors |
| `abstract_material_color_semantic.dart` | Contract for M3 semantic colors |
| `abstract_custom_color_semantic.dart` | Contract for custom semantic colors |
| `theme_extension.dart` | `context.colors` / `context.readColors` extensions |
| `theme_cubit.dart` | Owns theme state, calls `AppMaterialColors.load()` on change |
