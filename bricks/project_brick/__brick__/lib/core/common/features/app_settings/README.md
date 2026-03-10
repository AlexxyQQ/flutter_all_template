# App Settings Feature

A Clean Architecture module that persists and exposes user-level app settings (theme, locale, auth token, etc.) via a `BLoC` backed by local `SharedPreferences`-style storage.

## Directory Structure

```
app_settings/
├── data/
│   ├── data_sources/local/
│   │   └── app_setting_local_data_source.dart   # SharedPreferences read/write
│   ├── models/
│   │   ├── app_setting.dart                     # Freezed model + JSON
│   │   └── app_setting.g.dart / .freezed.dart   # Generated
│   └── repositories/
│       └── app_setting_repository_impl.dart
├── domain/
│   ├── repositories/
│   │   └── app_setting_repository.dart          # Abstract interface
│   └── services/cache/
│       └── app_setting_cache.dart               # In-memory cache layer
└── presentation/
    └── bloc/
        └── app_setting_bloc.dart                # BLoC (Read + Update + custom events)
```

## Dependencies

```yaml
dependencies:
  flutter_bloc: ^9.x.x
  fpdart: ^1.2.0
  injectable: ^2.x.x
  get_it: ^9.x.x
  freezed_annotation: ^2.x.x
  json_annotation: ^4.x.x

dev_dependencies:
  freezed: ^3.x.x
  json_serializable: ^6.x.x
  build_runner: ^2.x.x
```

## The `AppSetting` Model

Extend the `AppSetting` Freezed class with whatever fields your app requires:

```dart
// data/models/app_setting.dart
@freezed
class AppSetting with _$AppSetting {
  const factory AppSetting({
    @Default(false) bool isDarkMode,
    @Default('en')  String locale,
    String? accessToken,
    String? refreshToken,
    // Add your own fields here
  }) = _AppSetting;

  factory AppSetting.fromJson(Map<String, dynamic> json) =>
      _$AppSettingFromJson(json);
}
```

Regenerate after changes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## `AppSettingBloc` Events

| Event | Description |
|-------|-------------|
| `ReadEntityEvent` | Load settings from local storage |
| `UpdateEntityEvent(id, data)` | Partial update via map |
| `UpdateSettingEvent(data: fn)` | Functional update: `(current) => newSetting` |
| `OnLogOutEvent` | Clear tokens and reset state |

## Usage

### Provide the Bloc

`AppSettingBloc` is registered as `@injectable`. It is typically provided globally in `GlobalBlocProvider`:

```dart
BlocProvider(
  create: (_) => sl<AppSettingBloc>()..add(const ReadEntityEvent()),
)
```

### Read settings anywhere

```dart
final settings = context.read<AppSettingBloc>().state.selectedEntity;
final isDark = settings?.isDarkMode ?? false;
```

### Update a single field

```dart
context.read<AppSettingBloc>().add(
  UpdateSettingEvent(
    data: (current) => current.copyWith(isDarkMode: true),
  ),
);
```

### Logout

```dart
context.read<AppSettingBloc>().add(OnLogOutEvent());

// Listen for completion
BlocListener<AppSettingBloc, BaseCrudState<AppSetting>>(
  listener: (context, state) {
    if (state.successMessage == LocaleKeys.common_success_loggedOut) {
      sl<NavigationService>().replaceAll([const LoginRoute()]);
    }
  },
)
```

## Adding New Persisted Fields

1. Add the field to `AppSetting` and run `build_runner`.
2. Add a getter/setter to `AppSettingLocalDataSource`.
3. Update `AppSettingRepositoryImpl` to read/write the new field.
4. No BLoC changes needed — use `UpdateSettingEvent` to set the field.

## Copying to a New Project

1. Copy the entire `app_settings/` folder.
2. Add dependencies to `pubspec.yaml`.
3. Run `build_runner`.
4. Register `AppSettingBloc` in `GlobalBlocProvider`.
5. Add your own fields to `AppSetting` and rerun `build_runner`.
