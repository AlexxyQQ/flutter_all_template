import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_all_template/core/common/domain/entities/failure.dart';
import 'package:flutter_all_template/core/generic/presentation/bloc/load_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

class _NameCubit extends LoadCubit<String> {
  Either<Failure, String> next = const Right('name');

  Future<void> load() => run(() async => next);
}

const failure = Failure(message: 'error.key');

void main() {
  blocTest<_NameCubit, LoadState<String>>(
    'emits in progress then success',
    build: _NameCubit.new,
    act: (cubit) => cubit.load(),
    expect: () => const [LoadInProgress<String>(), LoadSuccess('name')],
  );

  blocTest<_NameCubit, LoadState<String>>(
    'a failed reload keeps the previous value',
    build: _NameCubit.new,
    seed: () => const LoadSuccess('old'),
    act: (cubit) {
      cubit.next = const Left(failure);
      return cubit.load();
    },
    expect: () => const [
      LoadInProgress<String>(previous: 'old'),
      LoadFailure<String>(failure, previous: 'old'),
    ],
    verify: (cubit) {
      expect(cubit.state.dataOrNull, 'old');
      expect(cubit.state.failureOrNull, failure);
    },
  );

  test('helpers', () {
    expect(const LoadInitial<int>().dataOrNull, isNull);
    expect(const LoadInProgress<int>(previous: 1).isLoading, isTrue);
    expect(const LoadSuccess(2).dataOrNull, 2);
    expect(const LoadSuccess(2).failureOrNull, isNull);
  });
}
