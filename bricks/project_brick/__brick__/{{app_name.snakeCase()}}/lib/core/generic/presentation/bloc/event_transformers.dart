import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

/// Waits until no new event arrived for [duration], then handles only the
/// latest one, cancelling a still-running handler for an older event.
///
/// Use for search-as-you-type / filter changes: no request per keystroke and
/// results can never arrive out of order.
EventTransformer<E> debounceRestartable<E>(Duration duration) {
  final switchToLatest = restartable<E>();
  if (duration == Duration.zero) {
    return switchToLatest;
  }
  return (events, mapper) =>
      switchToLatest(events.debounceTime(duration), mapper);
}
