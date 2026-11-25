import 'package:flutter_all_template/core/generic/presentation/bloc/selection_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SelectionCubit<String> cubit;

  setUp(() => cubit = SelectionCubit<String>());
  tearDown(() => cubit.close());

  test('toggle selects and deselects', () {
    cubit.toggle('a');
    expect(cubit.isSelected('a'), isTrue);
    cubit.toggle('a');
    expect(cubit.state, isEmpty);
  });

  test('selectAll, retainOnly and clear', () {
    cubit.selectAll(['a', 'b', 'c']);
    expect(cubit.state, {'a', 'b', 'c'});

    cubit.retainOnly(['b', 'c', 'd']);
    expect(cubit.state, {'b', 'c'});

    cubit.clear();
    expect(cubit.state, isEmpty);
  });

  test('state is unmodifiable', () {
    cubit.select('a');
    expect(() => cubit.state.add('b'), throwsUnsupportedError);
  });
}
