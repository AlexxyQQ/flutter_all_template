part of '{{feature_name.snakeCase()}}_list_bloc.dart';

final class {{feature_name.pascalCase()}}Created extends PagedListEvent {
  const {{feature_name.pascalCase()}}Created(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

final class {{feature_name.pascalCase()}}Deleted extends PagedListEvent {
  const {{feature_name.pascalCase()}}Deleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
