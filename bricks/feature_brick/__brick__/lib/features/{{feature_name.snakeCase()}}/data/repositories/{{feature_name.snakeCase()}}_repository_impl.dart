import 'package:injectable/injectable.dart';

import '../../../../config/constants/type_defs/typedef.dart';
import '../../../../core/common/data/models/helpers/model_conversion_helper.dart';
import '../../../../core/common/domain/entities/params/filter_params.dart';
import '../../domain/entities/{{feature_name.snakeCase()}}_entity.dart';
{{#use_params}}import '../../domain/entities/params/{{feature_name.snakeCase()}}_request_params.dart';
{{/use_params}}import '../../domain/repositories/{{feature_name.snakeCase()}}_repository.dart';
{{#use_local_datasource}}import '../data_sources/local/{{feature_name.snakeCase()}}_local_data_source.dart';
{{/use_local_datasource}}import '../data_sources/remote/{{feature_name.snakeCase()}}_remote_data_source.dart';
import '../models/{{feature_name.snakeCase()}}_model.dart';

@lazySingleton
class {{feature_name.pascalCase()}}RepositoryImpl implements I{{feature_name.pascalCase()}}Repository {
  {{feature_name.pascalCase()}}RepositoryImpl({
    {{#use_local_datasource}}required {{feature_name.pascalCase()}}LocalDataSource localDataSource,
    {{/use_local_datasource}}required {{feature_name.pascalCase()}}RemoteDataSource remoteDataSource,
  }) : {{#use_local_datasource}}_localDataSource = localDataSource,
       {{/use_local_datasource}}_remoteDataSource = remoteDataSource;

  {{#use_local_datasource}}final {{feature_name.pascalCase()}}LocalDataSource _localDataSource;
  {{/use_local_datasource}}final {{feature_name.pascalCase()}}RemoteDataSource _remoteDataSource;

  @override
  ResultFuture<{{feature_name.pascalCase()}}Entity> create{{feature_name.pascalCase()}}({
    {{#use_params}}required {{feature_name.pascalCase()}}RequestParams params,{{/use_params}}{{^use_params}}required Map<String, dynamic> data,{{/use_params}}
  }) {
    return _remoteDataSource
        .create{{feature_name.pascalCase()}}({{#use_params}}params: params{{/use_params}}{{^use_params}}data: data{{/use_params}})
        .mapModelToEntity((model) => model.toEntity());
  }

  @override
  ResultFuture<{{feature_name.pascalCase()}}Entity> delete{{feature_name.pascalCase()}}({String? id}) {
    return _remoteDataSource
        .delete{{feature_name.pascalCase()}}(id: id)
        .mapModelToEntity((model) => model.toEntity());
  }

  @override
  ResultFuture<{{feature_name.pascalCase()}}Entity> get{{feature_name.pascalCase()}}({String? id}) {
    return _remoteDataSource
        .get{{feature_name.pascalCase()}}(id: id)
        .mapModelToEntity((model) => model.toEntity());
  }

  @override
  ResultFuture<List<{{feature_name.pascalCase()}}Entity>> get{{feature_name.pascalCase()}}s({FilterParams? params}) {
    return _remoteDataSource
        .get{{feature_name.pascalCase()}}s(params: params)
        .mapModelListToEntityList((models) => models.toEntity());
  }

  @override
  ResultFuture<{{feature_name.pascalCase()}}Entity> update{{feature_name.pascalCase()}}({
    {{#use_params}}required {{feature_name.pascalCase()}}RequestParams params,{{/use_params}}{{^use_params}}required Map<String, dynamic> data,{{/use_params}}
  }) {
    return _remoteDataSource
        .update{{feature_name.pascalCase()}}({{#use_params}}params: params{{/use_params}}{{^use_params}}data: data{{/use_params}})
        .mapModelToEntity((model) => model.toEntity());
  }
}
