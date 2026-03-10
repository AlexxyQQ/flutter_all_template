import '../../../../config/constants/type_defs/typedef.dart';
import '../../../../core/common/domain/entities/params/filter_params.dart';
{{#use_params}}import '../../domain/entities/params/{{feature_name.snakeCase()}}_request_params.dart';
{{/use_params}}import '../models/{{feature_name.snakeCase()}}_model.dart';

abstract class {{feature_name.pascalCase()}}DataSource {
  ResultFuture<List<{{feature_name.pascalCase()}}Model>> get{{feature_name.pascalCase()}}s({FilterParams? params});
  ResultFuture<{{feature_name.pascalCase()}}Model> get{{feature_name.pascalCase()}}({String? id});
  ResultFuture<{{feature_name.pascalCase()}}Model> delete{{feature_name.pascalCase()}}({String? id});
  ResultFuture<{{feature_name.pascalCase()}}Model> update{{feature_name.pascalCase()}}({
    {{#use_params}}required {{feature_name.pascalCase()}}RequestParams params,{{/use_params}}{{^use_params}}required Map<String, dynamic> data,{{/use_params}}
  });
  ResultFuture<{{feature_name.pascalCase()}}Model> create{{feature_name.pascalCase()}}({
    {{#use_params}}required {{feature_name.pascalCase()}}RequestParams params,{{/use_params}}{{^use_params}}required Map<String, dynamic> data,{{/use_params}}
  });
}
