import 'package:injectable/injectable.dart';

import '../../../../config/constants/type_defs/typedef.dart';
import '../entities/{{feature_name.snakeCase()}}.dart';
{{#use_params}}import '../params/{{feature_name.snakeCase()}}_params.dart';
{{/use_params}}import '../repositories/{{feature_name.snakeCase()}}_repository.dart';

/// Creates a {{feature_name.pascalCase()}}. The only business rule: the title is trimmed.
@lazySingleton
class Create{{feature_name.pascalCase()}}UseCase {
  const Create{{feature_name.pascalCase()}}UseCase({required I{{feature_name.pascalCase()}}Repository repository}) : _repository = repository;

  final I{{feature_name.pascalCase()}}Repository _repository;

  ResultFuture<{{feature_name.pascalCase()}}> call({{#use_params}}{required Create{{feature_name.pascalCase()}}Params params}{{/use_params}}{{^use_params}}{required String title}{{/use_params}}) =>
      _repository.create{{feature_name.pascalCase()}}(
        {{#use_params}}params: Create{{feature_name.pascalCase()}}Params(title: params.title.trim()){{/use_params}}{{^use_params}}title: title.trim(){{/use_params}},
      );
}
