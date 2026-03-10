# Context Extensions

A collection of `BuildContext` and type extensions that reduce boilerplate across the UI layer. All extensions are imported via the files inside each sub-folder.

## Directory Structure

```
extensions/
├── currency/          # Number → formatted currency string
├── date_time/         # DateTime helpers and formatters
├── dialog/            # Show dialogs and bottom sheets from context
├── size/              # Responsive sizing (screen %, ScreenUtil wrappers)
├── snackbar/          # Typed snackbar helpers
├── text/              # String manipulation helpers
├── theme/             # context.colors, context.textStyles, context.appTheme
└── validation/        # Form field validators
```

---

## Snackbar Extension

**File:** `snackbar/snackbar_extension.dart`

```dart
// Success (green, floating)
context.showSuccessSnackBar(message: 'Profile saved');

// Error (red, floating) — no-ops silently when message is null/empty
context.showErrorSnackBar(message: failure.message);

// Top notification (covers status bar — use for connection errors)
context.showTopSnackBar(
  title:   'No internet',
  message: 'Check your connection',
  isError: true,
);

// Standard bottom snackbar with optional undo action
context.showStandardSnackBar(
  message: 'Item deleted',
  action: SnackBarAction(label: 'Undo', onPressed: _restore),
);
```

---

## Theme Extension

**File:** `theme/theme_extension.dart`

```dart
// Colour tokens (semantic, respects light/dark)
context.colors.primary
context.colors.surface
context.colors.error

// Text styles
context.textStyles.titleLarge
context.textStyles.bodyMedium

// Custom component theme
context.appTheme.button
context.appTheme.chip
```

---

## Size Extension

**File:** `size/size_extension.dart`

Wraps `flutter_screenutil` so you never import it directly in widgets:

```dart
// Responsive pixels
16.w    // width-scaled
24.h    // height-scaled
14.sp   // font scale

// BorderRadius
12.borderCircular   // BorderRadius.circular(12.r)

// Percentage of screen
context.screenWidth  * 0.5
context.screenHeight * 0.3
```

---

## Dialog Extension

**File:** `dialog/dialog_extension.dart`

```dart
// Show a modal bottom sheet
context.showAppBottomSheet(child: const MySheet());

// Show a full dialog
context.showAppDialog(child: const ConfirmDialog());
```

---

## DateTime Extension

**File:** `date_time/date_time_extension.dart`

```dart
final dt = DateTime.now();
dt.toDisplayDate()        // e.g. "03 Mar 2026"
dt.toApiFormat()          // e.g. "2026-03-03"
dt.isToday                // bool
dt.timeAgo()              // e.g. "2 hours ago"
```

Format constants live in:
`lib/config/constants/date_time/date_time_formatter_string_constant.dart`

---

## Currency Extension

**File:** `currency/currency_extension.dart`

```dart
final price = 1299.50;
price.toCurrency()           // "1,299.50"
price.toCurrencyWithSymbol() // "$1,299.50"
```

---

## Validation Extension

**File:** `validation/validation_extension.dart`

Ready-to-use `FormFieldValidator<String>` factories:

```dart
TextFormField(
  validator: context.requiredValidator('Name'),
)

TextFormField(
  validator: context.emailValidator(),
)

TextFormField(
  validator: context.minLengthValidator(8),
)
```

---

## Text Extension

**File:** `text/text_extension.dart`

```dart
'hello world'.toTitleCase()   // "Hello World"
'  trimmed  '.trimAndLower()  // "trimmed"
''.isNullOrEmpty              // true
```

---

## Copying to a New Project

1. Copy the entire `extensions/` folder.
2. Ensure `flutter_screenutil` is in `pubspec.yaml` (required by `size/`).
3. Make sure the theme resolution extensions (`theme/`) reference your own `AppMaterialColors` and text style resolver.
4. Import individual extension files or create a barrel export.
