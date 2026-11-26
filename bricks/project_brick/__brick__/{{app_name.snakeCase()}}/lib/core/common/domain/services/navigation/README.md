# Navigation service

`NavigationService` is a `@lazySingleton` facade over the auto_route `AppRouter`
(`lib/core/common/presentation/routes/app_router.dart`). Use it from blocs and services that
have no `BuildContext`; widgets should use `context.router`.

```dart
class MyService {
  MyService({required NavigationService nav}) : _nav = nav;
  final NavigationService _nav;

  Future<void> openHome() => _nav.push(const HomeRoute());
}
```

Available helpers: `push`, `replace`, `pushNamed`, `replaceNamed`, `replaceAll`,
`maybePop`, `popForced`, `popUntil`, `popUntilRoot`, `canPop`, `removeWhere`, `checkIfAlreadyOpened`
and `current`. Only pass `AppPaths` constants or allow-listed values to the `*Named`
methods, never raw push payloads or deep-link parameters.

## Adding a route

1. Annotate the screen with `@RoutePage()` and expose a `...Routes` class holding its
   `AutoRoute` (see `lib/features/home/presentation/routes/home_route.dart`).
2. Register it in `AppRouter.routes`.
3. `rps gen` (or `dart run build_runner build --delete-conflicting-outputs`).
