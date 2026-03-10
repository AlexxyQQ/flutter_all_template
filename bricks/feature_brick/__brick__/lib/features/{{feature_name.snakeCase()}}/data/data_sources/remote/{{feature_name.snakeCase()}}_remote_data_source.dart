import 'package:injectable/injectable.dart';

import '../../../../../config/constants/api/api_paths.dart';
import '../../../../../config/constants/type_defs/typedef.dart';
import '../../../../../core/common/domain/entities/params/filter_params.dart';
import '../../../../../core/common/domain/services/network/dio_service.dart';
{{#use_params}}import '../../../domain/entities/params/{{feature_name.snakeCase()}}_request_params.dart';
{{/use_params}}import '../../models/{{feature_name.snakeCase()}}_model.dart';
import '../{{feature_name.snakeCase()}}_data_source.dart';

@lazySingleton
class {{feature_name.pascalCase()}}RemoteDataSource implements {{feature_name.pascalCase()}}DataSource {
  @override
  ResultFuture<{{feature_name.pascalCase()}}Model> create{{feature_name.pascalCase()}}({
    {{#use_params}}required {{feature_name.pascalCase()}}RequestParams params,{{/use_params}}{{^use_params}}required Map<String, dynamic> data,{{/use_params}}
  }) {
    return ApiHandler.post<{{feature_name.pascalCase()}}Model>(
      url: ApiPaths.{{feature_name.camelCase()}},
      {{#use_params}}data: params.toJson(),{{/use_params}}{{^use_params}}data: data,{{/use_params}}
      onSuccess: (response) => {{feature_name.pascalCase()}}Model.fromJson(response),
    );
  }

  @override
  ResultFuture<{{feature_name.pascalCase()}}Model> delete{{feature_name.pascalCase()}}({String? id}) {
    return ApiHandler.delete<{{feature_name.pascalCase()}}Model>(
      url: '${ApiPaths.{{feature_name.camelCase()}}}/$id',
      onSuccess: (response) => {{feature_name.pascalCase()}}Model.fromJson(response),
    );
  }

  @override
  ResultFuture<{{feature_name.pascalCase()}}Model> get{{feature_name.pascalCase()}}({String? id}) {
    return ApiHandler.get<{{feature_name.pascalCase()}}Model>(
      url: '${ApiPaths.{{feature_name.camelCase()}}}/$id',
      onSuccess: (response) => {{feature_name.pascalCase()}}Model.fromJson(response),
    );
  }

  @override
  ResultFuture<List<{{feature_name.pascalCase()}}Model>> get{{feature_name.pascalCase()}}s({FilterParams? params}) {
    return ApiHandler.get<List<{{feature_name.pascalCase()}}Model>>(
      url: ApiPaths.{{feature_name.camelCase()}},
      queryParams: params?.toJson(),
      onSuccess: (response) =>
          (response['data'] as List).map((e) => {{feature_name.pascalCase()}}Model.fromJson(e)).toList(),
    );
  }

  @override
  ResultFuture<{{feature_name.pascalCase()}}Model> update{{feature_name.pascalCase()}}({
    {{#use_params}}required {{feature_name.pascalCase()}}RequestParams params,{{/use_params}}{{^use_params}}required Map<String, dynamic> data,{{/use_params}}
  }) {
    {{#use_params}}final entityId = params.id;{{/use_params}}{{^use_params}}final entityId = data['id'] as String?;{{/use_params}}
    return ApiHandler.put<{{feature_name.pascalCase()}}Model>(
      url: '${ApiPaths.{{feature_name.camelCase()}}}/$entityId',
      {{#use_params}}data: params.toJson(),{{/use_params}}{{^use_params}}data: data,{{/use_params}}
      onSuccess: (response) => {{feature_name.pascalCase()}}Model.fromJson(response),
    );
  }
}
