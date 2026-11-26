import 'package:injectable/injectable.dart';

import '../../../../config/constants/type_defs/typedef.dart';
import '../../../../core/generic/domain/entities/page.dart';
import '../entities/{{feature_name.snakeCase()}}.dart';
{{#use_params}}import '../params/{{feature_name.snakeCase()}}_params.dart';
{{/use_params}}import '../repositories/{{feature_name.snakeCase()}}_repository.dart';

/// Loads one page of {{feature_name.pascalCase()}}s matching [query].
@lazySingleton
class Get{{feature_name.pascalCase()}}sUseCase {
  const Get{{feature_name.pascalCase()}}sUseCase({required I{{feature_name.pascalCase()}}Repository repository}) : _repository = repository;

  final I{{feature_name.pascalCase()}}Repository _repository;

  ResultFuture<PageResult<{{feature_name.pascalCase()}}>> call({
    required PageRequest page,
    {{#use_params}}{{feature_name.pascalCase()}}Query{{/use_params}}{{^use_params}}String{{/use_params}} query = {{#use_params}}const {{feature_name.pascalCase()}}Query(){{/use_params}}{{^use_params}}''{{/use_params}},
  }) => _repository.get{{feature_name.pascalCase()}}s(page: page, query: query);
}
