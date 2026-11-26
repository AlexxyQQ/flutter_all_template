import 'package:fpdart/fpdart.dart';

import '../../../core/common/domain/entities/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef ResultVoid = ResultFuture<void>;
