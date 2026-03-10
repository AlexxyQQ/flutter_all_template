import 'package:fpdart/fpdart.dart';

import '../../../domain/entities/failure.dart';

// --- Extension for SINGLE models ---

extension EitherFutureModelExtension<M> on Future<Either<Failure, M>> {
  /// Applies a [converter] function to the [Right] value of an [Either].
  ///
  /// If the [Future] returns a [Left], it is returned unchanged.
  Future<Either<Failure, E>> mapModelToEntity<E>(
    E Function(M model) converter,
  ) async {
    final either = await this;
    return either.map(converter);
  }

  /// A convenience wrapper for models that have a `.toEntity()` method.
  Future<Either<Failure, E>> toEntity<E>(E Function(M model) toEntity) async {
    return this.mapModelToEntity(toEntity);
  }
}

// --- Extension for LISTS of models ---

extension EitherFutureListExtension<M> on Future<Either<Failure, List<M>>> {
  /// Applies a [converter] function to each item in the [Right] List.
  ///
  /// If the [Future] returns a [Left], it is returned unchanged.
  Future<Either<Failure, List<E>>> mapModelListToEntityList<E>(
    E Function(M model) converter,
  ) async {
    final either = await this;
    // .map on Either -> process the Right(value)
    // .map on List -> process each item in the list
    return either.map((modelList) => modelList.map(converter).toList());
  }

  /// A convenience wrapper for lists of models that have a `.toEntity()` method.
  Future<Either<Failure, List<E>>> toEntityList<E>(
    E Function(M model) toEntity,
  ) async {
    return this.mapModelListToEntityList(toEntity);
  }
}

// --- Extension for Direct Data Access (Unwrapping) ---

extension EitherFutureUnwrap<L, R> on Future<Either<L, R>> {
  /// Unwraps the [Right] value (the successful data).
  ///
  /// **Throws**: The [Left] value (e.g., [Failure]) as an exception if the result is an error.
  /// Use this when you want to exit the functional flow and use standard try-catch blocks.
  Future<R> get right async {
    final either = await this;
    return either.fold(
      (left) => throw left as Object, // Throw the error model
      (right) => right, // Return the success data
    );
  }

  /// Unwraps the [Right] value, returning `null` if it was an error.
  /// Useful if you want to ignore errors safely.
  Future<R?> get rightOrNull async {
    final either = await this;
    return either.fold((left) => null, (right) => right);
  }
}
