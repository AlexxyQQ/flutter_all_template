import 'package:fpdart/fpdart.dart';

import '../../../domain/entities/failure.dart';

/// Maps the success value of a `ResultFuture` of a single model.
extension EitherFutureModelExtension<M> on Future<Either<Failure, M>> {
  /// Applies [converter] to the [Right] value; a [Left] is returned unchanged.
  Future<Either<Failure, E>> mapModelToEntity<E>(
    E Function(M model) converter,
  ) async => (await this).map(converter);
}

/// Maps every item of the success value of a `ResultFuture` of a list.
extension EitherFutureListExtension<M> on Future<Either<Failure, List<M>>> {
  /// Applies [converter] to each item of the [Right] list; a [Left] is
  /// returned unchanged.
  Future<Either<Failure, List<E>>> mapModelListToEntityList<E>(
    E Function(M model) converter,
  ) async => (await this).map((models) => models.map(converter).toList());
}

extension EitherFutureUnwrap<L, R> on Future<Either<L, R>> {
  /// The [Right] value, or `null` if the result is a [Left].
  Future<R?> get rightOrNull async =>
      (await this).fold((_) => null, (right) => right);
}
