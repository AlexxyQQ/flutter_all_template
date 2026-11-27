import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../../core/services/analytics/domain/analytics_service.dart';
import '../../core/services/logger/data/app_logger.dart';

/// Logs navigation at debug level and records screen views in analytics.
///
/// Only route **names** are used. Route arguments and paths are never logged
/// or tracked: they routinely carry IDs, e-mails or tokens. Dialogs, sheets
/// and other popup routes are not screens and are not tracked.
///
/// A [NavigatorObserver] can only be attached to one navigator, so this is
/// `@injectable` (a new instance per resolve): give every router its own,
/// e.g. `navigatorObservers: () => [sl<AppRouteObserver>()]`.
@injectable
class AppRouteObserver extends AutoRouteObserver {
  AppRouteObserver({required IAnalyticsService analytics})
    : _analytics = analytics;

  static const String _name = 'APP_ROUTER';

  final IAnalyticsService _analytics;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('PUSH', from: _nameOf(previousRoute), to: _nameOf(route));
    _trackScreen(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('POP', from: _nameOf(route), to: _nameOf(previousRoute));
    // Closing a dialog does not show a new screen.
    if (route is! PopupRoute) {
      _trackScreen(previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _log('REPLACE', from: _nameOf(oldRoute), to: _nameOf(newRoute));
    _trackScreen(newRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('REMOVE', to: _nameOf(route));
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    _log('TAB', from: previousRoute.name, to: route.name);
    _analytics.trackScreen(name: route.name);
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    _log('TAB INIT', from: previousRoute?.name, to: route.name);
    _analytics.trackScreen(name: route.name);
  }

  void _trackScreen(Route<dynamic>? route) {
    final name = _nameOf(route);
    if (route is PageRoute && name != null) {
      _analytics.trackScreen(name: name);
    }
  }

  void _log(String action, {String? from, String? to}) {
    final buffer = StringBuffer(action.padRight(10));
    if (from != null && to != null) {
      buffer.write('$from -> $to');
    } else {
      buffer.write(to ?? from ?? '-');
    }
    AppLogger.debug(buffer.toString(), name: _name);
  }

  static String? _nameOf(Route<dynamic>? route) => route?.settings.name;
}
