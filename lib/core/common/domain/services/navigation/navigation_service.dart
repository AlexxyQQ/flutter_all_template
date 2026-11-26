import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../../../presentation/routes/app_router.dart';

/// Router access for code that has no `BuildContext` (services, dialogs
/// helpers). Widgets should prefer `context.router`.
@lazySingleton
class NavigationService {
  const NavigationService(this._appRouter);

  final AppRouter _appRouter;

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

  void popForced<T extends Object?>([T? result]) => _appRouter.pop<T>(result);

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

  /// Pops the route named [name] if it is on top, otherwise removes it from
  /// the stack.
  FutureOr<bool> closeSpecificRoute({required String name}) {
    if (_appRouter.current.name == name) {
      return _appRouter.maybePop();
    }
    return _appRouter.removeWhere((route) => route.name == name);
  }

  bool checkIfAlreadyOpened({required String name}) =>
      _appRouter.current.name == name;

  RouteData<Object?> get current => _appRouter.current;
}
