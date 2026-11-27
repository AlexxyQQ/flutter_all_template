# Permission feature

One enum, one bloc, one screen, one guard for every OS permission.

## Structure

```
permission/
├── domain/
│   ├── entities/app_permission.dart            # enum AppPermission (+ tryParse)
│   ├── entities/app_permission_status.dart     # domain status enum (no permission_handler types)
│   ├── repositories/                           # IPermissionRepository, IPermissionSkipRepository
│   └── usecases/                               # Check, Request, OpenSettings, CheckLocationService,
│                                               # OpenLocationSettings, IsSkipped, MarkSkipped
├── data/
│   ├── data_sources/                           # permission_handler / geolocator seam
│   ├── helpers/platform_permissions.dart       # AppPermission → platform Permission(s) per OS version
│   ├── helpers/permission_status_resolver.dart # platform statuses → one AppPermissionStatus
│   └── repositories/
│       ├── permission_repository_impl.dart       # check / request / settings (guard())
│       └── permission_skip_repository_impl.dart  # "skipped" flags in IPreferencesStore
└── presentation/
    ├── bloc/                                   # PermissionBloc (depends on the use cases)
    ├── helpers/permission_content.dart         # icon + locale keys per permission
    ├── routes/permission_routes.dart           # /permission/:permission
    ├── routes/permission_gate.dart             # granted-or-skipped policy
    ├── routes/permission_guard.dart            # PermissionGuard(AppPermission)
    └── views/{screens,widgets}/
```

The domain only knows `AppPermission`; which `permission_handler` permissions back it
(and how that changes between Android versions) is a data-layer detail.

## Adding a permission

1. Add a value to `AppPermission`.
2. Map it in `data/helpers/platform_permissions.dart` and give it an icon in
   `presentation/helpers/permission_content.dart` (both are exhaustive switches, so the
   compiler points at them).
3. Add `features.permission.<name>.{title,message,reAskTitle,reAskMessage}` to
   `assets/translations/*.json` and run `rps gen:keys`. `permission_content_test.dart` fails
   when a translation is missing.
4. Declare the platform permission (AndroidManifest / Info.plist).

## Android versions

`PlatformPermissions` returns *alternatives*; the app permission is granted when one
alternative is fully granted:

- `storage`: `READ_EXTERNAL_STORAGE` up to Android 12, photos + videos + audio
  (`READ_MEDIA_*`) on Android 13+ (`Permission.storage` is always denied there).
- `bluetooth`: legacy `BLUETOOTH` up to Android 11, `BLUETOOTH_SCAN` + `BLUETOOTH_CONNECT`
  on Android 12+.

## Bloc

State: `statuses: Map<AppPermission, AppPermissionStatus>`, `skipped: Set<AppPermission>`,
`requesting` (the permission whose prompt is open; clearing it is what lets the UI react to a
finished request even when the status did not change) and `error` (show it with
`failure.displayText`).

Events: `PermissionChecked(p)`, `PermissionRequested(p)` (droppable: one prompt at a time),
`PermissionSkipped(p)`, `PermissionSettingsOpened()`.

**Skipping is not granting**: `PermissionSkipped` only adds to `skipped`; the OS status is
untouched. Use `state.isGranted(p)` before using the feature and `state.canProceed(p)`
(granted or skipped) for flow decisions.

## Location

The location *switch* (GPS) is separate from the location *permission*: a granted
permission with GPS off is still "granted". Use `CheckLocationServiceUseCase` and, when the
user agrees, `OpenLocationSettingsUseCase`. Requesting the permission never opens settings
on its own.

## Showing the screen

The screen returns its result through the router: `true` when the permission was granted or
skipped, `null` when the user backed out. It takes no callbacks, so deep links and state
restoration work.

```dart
final done = await context.router.push<bool>(
  PermissionRoute(permission: AppPermission.camera.name),
);
if (done == true) {
  // continue (e.g. context.router.push(const HomeRoute()))
}
```

Deep link: `/permission/camera` (unknown names show an error state).

## Guarding a route

Build the guard where the router is composed and give it the injected `PermissionGate`
(see the example in `permission_guard.dart`), not `sl()` inside a route config:

```dart
AutoRoute(
  page: CameraRoute.page,
  guards: [PermissionGuard(permission: AppPermission.camera, gate: _permissionGate)],
)
```

Granted (or skipped, unless `allowIfSkipped: false`) → navigation continues. Otherwise the
permission screen is pushed and the original navigation resumes or aborts with its result.

## Notification permission

Delegated to the notification module through `INotificationPermissionApi` (it also needs FCM
authorization and registers the push token once granted). The permission feature does not
touch FCM tokens.
