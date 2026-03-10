import '../../../../config/constants/type_defs/typedef.dart';
import '../../../../core/common/domain/entities/params/filter_params.dart';
import '../entities/{{feature_name.snakeCase()}}_entity.dart';
{{#use_params}}import '../entities/params/{{feature_name.snakeCase()}}_request_params.dart';
{{/use_params}}
abstract class I{{feature_name.pascalCase()}}Repository {
  ResultFuture<List<{{feature_name.pascalCase()}}Entity>> get{{feature_name.pascalCase()}}s({FilterParams? params});
  ResultFuture<{{feature_name.pascalCase()}}Entity> get{{feature_name.pascalCase()}}({String? id});
  ResultFuture<{{feature_name.pascalCase()}}Entity> delete{{feature_name.pascalCase()}}({String? id});
  ResultFuture<{{feature_name.pascalCase()}}Entity> update{{feature_name.pascalCase()}}({
    {{#use_params}}required {{feature_name.pascalCase()}}RequestParams params,{{/use_params}}{{^use_params}}required Map<String, dynamic> data,{{/use_params}}
  });
  ResultFuture<{{feature_name.pascalCase()}}Entity> create{{feature_name.pascalCase()}}({
    {{#use_params}}required {{feature_name.pascalCase()}}RequestParams params,{{/use_params}}{{^use_params}}required Map<String, dynamic> data,{{/use_params}}
  });
}
