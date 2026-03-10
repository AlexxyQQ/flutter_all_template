import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../presentation/routes/app_router.dart';
import '../logger/logger_service.dart';

typedef RouteFailure = void Function(NavigationFailure)?;

@injectable
class NavigationService {
  factory NavigationService(AppRouter appRouter) {
    _instance ??= NavigationService._internal(appRouter);
    return _instance!;
  }
  const NavigationService._(this._appRouter);

  factory NavigationService._internal(AppRouter appRouter) =>
      NavigationService._(appRouter);
  final AppRouter _appRouter;
  static NavigationService? _instance;

  Future<dynamic> push(PageRouteInfo route, {OnNavigationFailure? onFailure}) {
    return _appRouter.push(route, onFailure: onFailure);
  }

  Future<void> replace(PageRouteInfo route, {OnNavigationFailure? onFailure}) {
    return _appRouter.replace(route, onFailure: onFailure);
  }

  Future<void> pushNamed(String routeName, {Object? arguments}) {
    return _appRouter.pushPath(routeName);
  }

  Future<void> replaceNamed(
    String routeName, {
    OnNavigationFailure? onFailure,
  }) {
    return _appRouter.replacePath(routeName, onFailure: onFailure);
  }

  void popForced<T extends Object?>([T? result]) {
    _appRouter.pop(result);
  }

  Future<bool> maybePop([dynamic data]) {
    return _appRouter.maybePopTop(data);
  }

  Future<void> replaceAll(
    List<PageRouteInfo<dynamic>> routes, {
    RouteFailure onFailure,
    bool updateExistingRoutes = true,
  }) {
    return _appRouter.replaceAll(
      routes,
      onFailure: onFailure,
      updateExistingRoutes: updateExistingRoutes,
    );
  }

  void popUntil(RoutePredicate predicate, {bool scoped = true}) {
    return _appRouter.popUntil(predicate, scoped: scoped);
  }

  /// **MODIFIED METHOD**
  /// Pushes a widget as a new page and returns a result of type [T] when it's popped.
  Future<T?> pushWidget<T extends Object?>({
    required BuildContext context,
    required Widget widget,
  }) async {
    return Navigator.of(
      context,
    ).push<T>(MaterialPageRoute(builder: (context) => widget));
  }

  void popUntilRoot() {
    _appRouter.popUntilRoot();
  }

  bool canPop() {
    return _appRouter.canPop();
  }

  bool removeWhere(RouteDataPredicate predicate, {bool notify = true}) {
    return _appRouter.removeWhere(predicate, notify: notify);
  }

  FutureOr<bool> closeSpecificRoute({required String name}) {
    final routeName = _appRouter.current.name;
    AppLogger.info('${routeName} vs $name');
    if (routeName == name) {
      return _appRouter.maybePop();
    } else {
      return _appRouter.removeWhere((route) => route.name == name);
    }
  }

  bool checkIfAlreadyOpened({required String name}) {
    final routeName = _appRouter.current.name;
    AppLogger.info(routeName);
    if (routeName == name) {
      return true;
    } else {
      return false;
    }
  }

  RouteData get current => _appRouter.current;
}
