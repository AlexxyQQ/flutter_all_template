import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../../../presentation/routes/app_router.dart';

/// Router access for code that has no `BuildContext` (services, dialogs
/// helpers). Widgets should prefer `context.router`.
@lazySingleton
class NavigationService {
  const NavigationService({required AppRouter appRouter})
    : _appRouter = appRouter;

  final AppRouter _appRouter;

  /// The mounted root navigator context used to present app-wide modals.
  BuildContext? get modalContext {
    final context = _appRouter.navigatorKey.currentContext;
    return context != null && context.mounted ? context : null;
  }

  Future<T?> push<T extends Object?>(
    PageRouteInfo<Object?> route, {
    OnNavigationFailure? onFailure,
  }) => _appRouter.push<T>(route, onFailure: onFailure);

  Future<void> replace(
    PageRouteInfo<Object?> route, {
    OnNavigationFailure? onFailure,
  }) => _appRouter.replace(route, onFailure: onFailure);

  /// Pushes an app path (e.g. an `AppPaths` constant). Never pass untrusted
  /// input (push payloads, deep-link params) here without an allowlist.
  Future<void> pushNamed(String path, {OnNavigationFailure? onFailure}) =>
      _appRouter.pushPath(path, onFailure: onFailure);

  Future<void> replaceNamed(String path, {OnNavigationFailure? onFailure}) =>
      _appRouter.replacePath(path, onFailure: onFailure);

  /// Opens a trusted app path, reusing an existing destination in the stack.
  Future<void> navigateToPath(String path, {OnNavigationFailure? onFailure}) =>
      _appRouter.navigatePath(path, onFailure: onFailure);

  void popForced<T extends Object?>([T? result]) {
    final top = _appRouter.topMostRouter();
    StackRouter? router = top is StackRouter ? top : top.parentAsStackRouter;
    while (router != null) {
      if (router.canPop(ignoreChildRoutes: true, ignoreParentRoutes: true)) {
        router.pop<T>(result);
        return;
      }
      router = router.parentAsStackRouter;
    }
    _appRouter.pop<T>(result);
  }

  Future<bool> maybePop<T extends Object?>([T? result]) =>
      _appRouter.maybePopTop<T>(result);

  Future<void> replaceAll(
    List<PageRouteInfo<Object?>> routes, {
    OnNavigationFailure? onFailure,
    bool updateExistingRoutes = true,
  }) => _appRouter.replaceAll(
    routes,
    onFailure: onFailure,
    updateExistingRoutes: updateExistingRoutes,
  );

  void popUntil(RoutePredicate predicate, {bool scoped = true}) =>
      _appRouter.popUntil(predicate, scoped: scoped);

  void popUntilRoot() => _appRouter.popUntilRoot();

  bool canPop() => _appRouter.canPop();

  bool removeWhere(RouteDataPredicate predicate, {bool notify = true}) =>
      _appRouter.removeWhere(predicate, notify: notify);

  /// Closes the nearest matching page in the active stack hierarchy.
  FutureOr<bool> closeSpecificRoute({required String name}) {
    final top = _appRouter.topMostRouter();
    StackRouter? router = top is StackRouter ? top : top.parentAsStackRouter;
    while (router != null) {
      for (final page in router.stack.reversed) {
        final route = page.routeData;
        if (route.name != name) {
          continue;
        }
        if (route == router.currentChild) {
          // A pageless route belongs to its own caller, even if it covers
          // the named page.
          return router.hasPagelessTopRoute ? false : router.maybePop();
        }
        router.removeRoute(route);
        return true;
      }
      router = router.parentAsStackRouter;
    }
    return false;
  }

  bool checkIfAlreadyOpened({required String name}) =>
      _appRouter.hasEntries && current.name == name;

  RouteData<Object?> get current => _appRouter.topRoute;
}
