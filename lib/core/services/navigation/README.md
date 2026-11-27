# Navigation service

`NavigationService` is a `@lazySingleton` facade over the auto_route `RootStackRouter`
(the app registers `AppRouter` from `lib/app/router/app_router.dart` as that type, so core never
imports the app or its features). Use it from blocs and services that
have no `BuildContext`; widgets should use `context.router`.

```dart
class MyService {
  MyService({required NavigationService nav}) : _nav = nav;
  final NavigationService _nav;

  Future<void> openHome() => _nav.push(const HomeRoute());
}
```

Use `navigateToPath` for allowlisted notification destinations. It reuses a
destination already in the stack and can set the initial route before the
navigator mounts. Pass trusted app paths to all path-based helpers.

`current` and `checkIfAlreadyOpened` inspect the active page, including nested
pages. `maybePop` and `popForced` start with the active navigator, including
pageless overlays. `closeSpecificRoute` searches the active stack hierarchy by
page name.

## Presenting modals

Inject `ModalService` and call `showPopup<T>` with an `AppPopupDialog` or
`showSheet<T>` with an `AppBottomSheet`. Widgets can pass their context.
Services can omit it to use the mounted root navigator. Return a typed value
with `Navigator.of(context).pop(result)` inside the builder. Normal dismissal
completes with `null`.

## Adding a route

1. Annotate the screen with `@RoutePage()` and expose a `...Routes` class holding its
   `AutoRoute` (see `lib/features/home/presentation/routes/home_route.dart`).
2. Register it in `AppRouter.routes`.
3. `rps gen` (or `dart run build_runner build --delete-conflicting-outputs`).
