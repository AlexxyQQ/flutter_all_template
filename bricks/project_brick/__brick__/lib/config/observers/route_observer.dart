import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../core/common/domain/services/logger/logger_service.dart';

@injectable
class AppRouteObserver extends AutoRouteObserver {
  // ---------------------------------------------------------------------------
  // CONFIGURATION
  // ---------------------------------------------------------------------------
  static const bool _showArgs = true; // Set to false to hide arguments

  // ---------------------------------------------------------------------------
  // HELPER METHODS
  // ---------------------------------------------------------------------------

  /// Centralized logging to ensure consistent formatting
  void _log({
    required String emoji,
    required String action,
    String? from,
    String? to,
    Object? args,
  }) {
    final fromPath = from ?? 'null';
    final toPath = to ?? 'null';

    // Format: 🚀 ACTION    | /previous ---> /current
    final logMessage = StringBuffer()..write('$emoji ${action.padRight(2)} | ');

    if (from != null && to != null) {
      logMessage.write('$fromPath ---> $toPath');
    } else if (to != null) {
      logMessage.write(toPath);
    } else {
      logMessage.write(fromPath);
    }

    if (_showArgs && args != null) {
      logMessage.write('\n    📦 Args: $args');
    }

    // Using the Singleton Logger Service
    // We use .info so it appears clearly in the log file
    AppLogger.info('[APP_ROUTER] ${logMessage.toString()}');
  }

  String? _getRouteName(Route? route) {
    return route?.settings.name;
  }

  // ---------------------------------------------------------------------------
  // OVERRIDES
  // ---------------------------------------------------------------------------

  @override
  void didPush(Route route, Route? previousRoute) {
    _log(
      emoji: '➡️',
      action: 'PUSH',
      from: _getRouteName(previousRoute),
      to: _getRouteName(route),
      args: route.settings.arguments,
    );
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _log(
      emoji: '⬅️',
      action: 'POP',
      from: _getRouteName(previousRoute), // The route remaining
      to: _getRouteName(route), // The route popped
      args: route.settings.arguments,
    );
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _log(
      emoji: '🔀',
      action: 'REPLACE',
      from: _getRouteName(oldRoute),
      to: _getRouteName(newRoute),
      args: newRoute?.settings.arguments,
    );
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _log(emoji: '🗑️', action: 'REMOVE', to: _getRouteName(route));
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    _log(
      emoji: '📑',
      action: 'TAB CHANGE',
      from: previousRoute.path,
      to: route.path,
    );
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    _log(
      emoji: '💡',
      action: 'TAB INIT',
      from: previousRoute?.path,
      to: route.path,
    );
  }
}
