import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/logger/data/app_logger.dart';

/// Global [BlocObserver]. Logs errors (reported to the crash sink in release)
/// and, in debug, which bloc handled which event type.
///
/// Full states/events are never logged: they can contain user data or tokens.
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    AppLogger.debug(
      '${bloc.runtimeType} <- ${event.runtimeType}',
      name: 'Bloc',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    AppLogger.error(
      'Unhandled error in ${bloc.runtimeType}',
      error: error,
      stackTrace: stackTrace,
      name: 'Bloc',
    );
    super.onError(bloc, error, stackTrace);
  }
}
