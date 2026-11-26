# Permission feature

One enum, one spec table, one bloc, one screen, one guard for every OS
permission.

## Structure

```
permission/
├── permission_spec.dart                    # AppPermission → PermissionSpec (platform permission, icon, l10n keys)
├── domain/
│   ├── entities/app_permission.dart        # enum AppPermission (+ tryParse)
│   ├── entities/app_permission_status.dart # domain status enum (no permission_handler types)
│   ├── repository/permission_repository.dart  # IPermissionRepository, IPermissionSkipRepository
│   └── usecases/                           # Check, Request, OpenSettings, IsSkipped, MarkSkipped
├── data/
│   ├── data_sources/permission_platform_data_source.dart  # permission_handler / geolocator seam
│   └── repository/
│       ├── permission_repository_impl.dart       # check / request / openSettings (guard())
│       └── permission_skip_repository_impl.dart  # "skipped" flags in PreferencesStore
└── presentation/
    ├── bloc/                               # PermissionBloc (depends on the use cases)
    ├── routes/permission_route.dart        # /permission/:permission
    ├── routes/permission_gate.dart         # granted-or-skipped policy
    ├── routes/permission_guard.dart        # PermissionGuard(AppPermission)
    └── view/
        ├── screens/permission_screen.dart
        └── widgets/permission_prompt_view.dart
```

## Adding a permission

1. Add a value to `AppPermission`.
2. Add its row to the exhaustive `switch` in `permission_spec.dart`
   (platform `Permission`, icon, title/message/re-ask keys).
3. Add the translation keys to `assets/translations/*.json` and regenerate
   locale keys.
4. Declare the platform permission (AndroidManifest / Info.plist).

The compiler tells you if step 2 is missing.

## Bloc

State: `statuses: Map<AppPermission, AppPermissionStatus>`,
`skipped: Set<AppPermission>`, `isLoading`, `error`, and
`lastRequested`/`requestCount` (lets the UI react to a finished request even if
the status did not change).

Events: `PermissionChecked(p)`, `PermissionRequested(p)` (droppable),
`PermissionSkipped(p)`, `AllPermissionsChecked()`, `PermissionSettingsOpened()`.

**Skipping is not granting**: `PermissionSkipped` only adds to `skipped`; the
OS status is untouched. Use `state.isGranted(p)` before using the feature and
`state.canProceed(p)` (granted or skipped) for flow decisions.

## Showing the screen

```dart
// Pop with a bool result (true = granted or skipped).
final ok = await context.router.push<bool>(
  PermissionScreenRoute(permission: AppPermission.camera.name),
);

// Or continue to a typed route afterwards.
context.router.push(
  PermissionScreenRoute(
    permission: AppPermission.location.name,
    nextRoute: const HomeRoute(),
  ),
);
```

Destinations are typed `PageRouteInfo`s only, never path strings.
Deep link: `/permission/camera` (unknown names show an error state).

## Guarding a route

```dart
AutoRoute(
  page: CameraRoute.page,
  guards: [PermissionGuard(permission: AppPermission.camera, gate: sl())],
)
```

Granted (or skipped, unless `allowIfSkipped: false`) → navigation continues.
Otherwise the permission screen is shown with `redirectUntil`, and the
original navigation resumes or aborts with the user's choice.

## Notification permission

Delegated to the notification module through `NotificationPermissionApi`
(it also needs FCM authorization and registers the push token once granted).
The permission feature does not touch FCM tokens.
