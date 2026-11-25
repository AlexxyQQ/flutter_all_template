import 'package:equatable/equatable.dart';

/// Input for creating a {{feature_name.pascalCase()}}. The server assigns `id` and `updatedAt`.
final class Create{{feature_name.pascalCase()}}Params extends Equatable {
  const Create{{feature_name.pascalCase()}}Params({required this.title});

  final String title;

  @override
  List<Object?> get props => [title];
}

/// Partial update of a {{feature_name.pascalCase()}}: only non-null fields are changed.
final class Update{{feature_name.pascalCase()}}Params extends Equatable {
  const Update{{feature_name.pascalCase()}}Params({required this.id, this.title});

  final String id;
  final String? title;

  @override
  List<Object?> get props => [id, title];
}

/// Filter for the {{feature_name.pascalCase()}} list.
final class {{feature_name.pascalCase()}}Query extends Equatable {
  const {{feature_name.pascalCase()}}Query({this.search = ''});

  /// Case-insensitive title filter; empty = no filter.
  final String search;

  @override
  List<Object?> get props => [search];
}
