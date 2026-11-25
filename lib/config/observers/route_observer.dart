import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../../core/common/domain/services/logger/logger_service.dart';

/// Logs navigation at debug level.
///
/// Only route **names/paths** are logged. Route arguments are never logged:
/// they routinely carry IDs, e-mails or tokens.
@injectable
class AppRouteObserver extends AutoRouteObserver {
  static const String _name = 'APP_ROUTER';

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

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('PUSH', from: _nameOf(previousRoute), to: _nameOf(route));
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('POP', from: _nameOf(route), to: _nameOf(previousRoute));
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _log('REPLACE', from: _nameOf(oldRoute), to: _nameOf(newRoute));
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('REMOVE', to: _nameOf(route));
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    _log('TAB', from: previousRoute.name, to: route.name);
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    _log('TAB INIT', from: previousRoute?.name, to: route.name);
  }
}
