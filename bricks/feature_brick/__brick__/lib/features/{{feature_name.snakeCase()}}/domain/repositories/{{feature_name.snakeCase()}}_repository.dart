import '../../../../core/error/typedef.dart';
import '../../../../core/generic/domain/entities/page.dart';
import '../entities/{{feature_name.snakeCase()}}.dart';
{{#use_params}}import '../params/{{feature_name.snakeCase()}}_params.dart';
{{/use_params}}
abstract interface class I{{feature_name.pascalCase()}}Repository {
  /// One page of items matching [query].
  ResultFuture<PageResult<{{feature_name.pascalCase()}}>> get{{feature_plural.pascalCase()}}({
    required PageRequest page,
    {{#use_params}}{{feature_name.pascalCase()}}Query{{/use_params}}{{^use_params}}String{{/use_params}} query = {{#use_params}}const {{feature_name.pascalCase()}}Query(){{/use_params}}{{^use_params}}''{{/use_params}},
  });

  ResultFuture<{{feature_name.pascalCase()}}> get{{feature_name.pascalCase()}}({required String id});{{#include_create}}

  ResultFuture<{{feature_name.pascalCase()}}> create{{feature_name.pascalCase()}}({{#use_params}}{required Create{{feature_name.pascalCase()}}Params params}{{/use_params}}{{^use_params}}{required String title}{{/use_params}});{{/include_create}}{{#include_update}}

  ResultFuture<{{feature_name.pascalCase()}}> update{{feature_name.pascalCase()}}({{#use_params}}{required Update{{feature_name.pascalCase()}}Params params}{{/use_params}}{{^use_params}}{required {{feature_name.pascalCase()}} item}{{/use_params}});{{/include_update}}{{#include_delete}}

  ResultFuture<void> delete{{feature_name.pascalCase()}}({required String id});{{/include_delete}}
}
