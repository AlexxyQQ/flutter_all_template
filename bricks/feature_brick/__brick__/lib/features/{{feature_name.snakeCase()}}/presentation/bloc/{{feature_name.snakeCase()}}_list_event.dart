part of '{{feature_name.snakeCase()}}_list_bloc.dart';{{^has_mutations}}

// Feature-specific events (extend `PagedListEvent`) go here.{{/has_mutations}}{{#include_create}}

final class {{feature_name.pascalCase()}}Created extends PagedListEvent {
  const {{feature_name.pascalCase()}}Created(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}{{/include_create}}{{#include_update}}

final class {{feature_name.pascalCase()}}Updated extends PagedListEvent {
  {{#use_params}}const {{feature_name.pascalCase()}}Updated({required this.id, this.title});

  final String id;
  final String? title;

  @override
  List<Object?> get props => [id, title];{{/use_params}}{{^use_params}}const {{feature_name.pascalCase()}}Updated(this.item);

  final {{feature_name.pascalCase()}} item;

  @override
  List<Object?> get props => [item];{{/use_params}}
}{{/include_update}}{{#include_delete}}

final class {{feature_name.pascalCase()}}Deleted extends PagedListEvent {
  const {{feature_name.pascalCase()}}Deleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}{{/include_delete}}
