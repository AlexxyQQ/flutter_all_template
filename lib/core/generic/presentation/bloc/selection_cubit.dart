import 'package:flutter_bloc/flutter_bloc.dart';

/// Multi-selection of item keys (usually ids), kept separate from the list
/// bloc so lists that don't need selection don't carry it.
///
/// ```dart
/// BlocProvider(create: (_) => SelectionCubit<String>());
/// context.read<SelectionCubit<String>>().toggle(todo.id);
/// ```
class SelectionCubit<K> extends Cubit<Set<K>> {
  SelectionCubit() : super(Set<K>.unmodifiable(const <Never>{}));

  bool isSelected(K key) => state.contains(key);

  void toggle(K key) => isSelected(key) ? deselect(key) : select(key);

  void select(K key) => _set({...state, key});

  void deselect(K key) => _set(state.difference({key}));

  void selectAll(Iterable<K> keys) => _set({...state, ...keys});

  void clear() => _set(const {});

  /// Drops selected keys that are no longer in [keys] (e.g. after a refresh
  /// or delete).
  void retainOnly(Iterable<K> keys) => _set(state.intersection(keys.toSet()));

  void _set(Set<K> next) => emit(Set<K>.unmodifiable(next));
}
