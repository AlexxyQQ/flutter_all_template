import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/constants/type_defs/typedef.dart';
import '../../../common/domain/entities/failure.dart';

/// State of loading a single value of type [T] (a profile, settings, a detail
/// page…). Use with a plain `Cubit<LoadState<T>>` or [LoadCubit].
///
/// ```dart
/// BlocBuilder<ProfileCubit, LoadState<Profile>>(
///   builder: (context, state) => switch (state) {
///     LoadInitial() || LoadInProgress(previous: null) => const Loader(),
///     LoadInProgress(:final previous?) => ProfileView(previous, busy: true),
///     LoadSuccess(:final data) => ProfileView(data),
///     LoadFailure(:final failure) => ErrorView(failure.message.tr()),
///   },
/// );
/// ```
sealed class LoadState<T> extends Equatable {
  const LoadState();

  /// The latest successfully loaded value, if any (also while reloading or
  /// after a failed reload).
  T? get dataOrNull => switch (this) {
    LoadInitial() => null,
    LoadInProgress(:final previous) => previous,
    LoadSuccess(:final data) => data,
    LoadFailure(:final previous) => previous,
  };

  Failure? get failureOrNull => switch (this) {
    LoadFailure(:final failure) => failure,
    _ => null,
  };

  bool get isLoading => this is LoadInProgress<T>;
}

final class LoadInitial<T> extends LoadState<T> {
  const LoadInitial();

  @override
  List<Object?> get props => const [];
}

final class LoadInProgress<T> extends LoadState<T> {
  const LoadInProgress({this.previous});

  /// Value from a previous successful load, kept visible while reloading.
  final T? previous;

  @override
  List<Object?> get props => [previous];
}

final class LoadSuccess<T> extends LoadState<T> {
  const LoadSuccess(this.data);

  final T data;

  @override
  List<Object?> get props => [data];
}

final class LoadFailure<T> extends LoadState<T> {
  const LoadFailure(this.failure, {this.previous});

  /// `failure.message` is a localization key — translate it in the widget.
  final Failure failure;

  /// Value from a previous successful load: a failed reload never wipes it.
  final T? previous;

  @override
  List<Object?> get props => [failure, previous];
}

/// A cubit that loads one value of type [T].
///
/// ```dart
/// @injectable
/// class ProfileCubit extends LoadCubit<Profile> {
///   ProfileCubit(this._repository);
///   final IProfileRepository _repository;
///
///   Future<void> load() => run(_repository.getProfile);
/// }
/// ```
abstract class LoadCubit<T> extends Cubit<LoadState<T>> {
  LoadCubit([super.initialState = const LoadInitial()]);

  /// Emits [LoadInProgress] (keeping the current value), awaits [request] and
  /// emits [LoadSuccess] or [LoadFailure].
  Future<void> run(ResultFuture<T> Function() request) async {
    final previous = state.dataOrNull;
    emit(LoadInProgress(previous: previous));
    final result = await request();
    if (isClosed) {
      return;
    }
    emit(
      result.fold<LoadState<T>>(
        (failure) => LoadFailure<T>(failure, previous: previous),
        LoadSuccess<T>.new,
      ),
    );
  }
}
