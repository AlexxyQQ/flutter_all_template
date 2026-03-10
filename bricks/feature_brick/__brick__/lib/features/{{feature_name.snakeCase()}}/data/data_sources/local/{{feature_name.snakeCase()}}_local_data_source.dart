import 'package:fpdart/src/either.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/constants/type_defs/typedef.dart';
import '../../../../../core/common/domain/entities/params/filter_params.dart';
import '../../../../../core/common/domain/services/storage/secure_storage_service.dart';
import '../../../../../core/common/locator/service_locator.dart';
import '../../../../../core/generic/data/data_sources/local/secure_storage_data_source.dart';
{{#use_params}}import '../../../domain/entities/params/{{feature_name.snakeCase()}}_request_params.dart';
{{/use_params}}import '../../models/{{feature_name.snakeCase()}}_model.dart';
import '../{{feature_name.snakeCase()}}_data_source.dart';

@lazySingleton
class {{feature_name.pascalCase()}}LocalDataSource extends ISecureStorageDataSource<{{feature_name.pascalCase()}}Model>
    implements {{feature_name.pascalCase()}}DataSource {
  {{feature_name.pascalCase()}}LocalDataSource()
    : super(
        secureStorageService: sl<SecureStorageService>(),
        modelKey: 'app_{{feature_name.snakeCase()}}',
      );

  @override
  {{feature_name.pascalCase()}}Model copyWith(existingItem, newValue) {
    return existingItem.copyWith(
      id: newValue.id ?? existingItem.id,
      // TODO: add copyWith field merges for each model field
    );
  }

  @override
  {{feature_name.pascalCase()}}Model fromJson(Map<String, dynamic> json) {
    return {{feature_name.pascalCase()}}Model.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson({{feature_name.pascalCase()}}Model object) {
    return object.toJson();
  }

  @override
  ResultFuture<{{feature_name.pascalCase()}}Model> create{{feature_name.pascalCase()}}({
    {{#use_params}}required {{feature_name.pascalCase()}}RequestParams params,{{/use_params}}{{^use_params}}required Map<String, dynamic> data,{{/use_params}}
  }) async {
    {{#use_params}}final result = await create(value: params.toModel());{{/use_params}}{{^use_params}}final result = await create(value: {{feature_name.pascalCase()}}Model.fromJson(data));{{/use_params}}
    return result.fold((l) => Left(l), (r) => Right(r.first));
  }

  @override
  ResultFuture<{{feature_name.pascalCase()}}Model> delete{{feature_name.pascalCase()}}({String? id}) async {
    final result = await deleteWhere(where: (item) => item.id == id);
    return result.fold((l) => Left(l), (r) => Right(r.first));
  }

  @override
  ResultFuture<{{feature_name.pascalCase()}}Model> get{{feature_name.pascalCase()}}({String? id}) async {
    final result = await getWhere(where: (item) => item.id == id);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  ResultFuture<List<{{feature_name.pascalCase()}}Model>> get{{feature_name.pascalCase()}}s({FilterParams? params}) async {
    final result = await getAll();
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  ResultFuture<{{feature_name.pascalCase()}}Model> update{{feature_name.pascalCase()}}({
    {{#use_params}}required {{feature_name.pascalCase()}}RequestParams params,{{/use_params}}{{^use_params}}required Map<String, dynamic> data,{{/use_params}}
  }) async {
    {{#use_params}}final result = await updateWhere(
      where: (item) => item.id == params.id,
      newValue: params.toModel(),
    );{{/use_params}}{{^use_params}}final result = await updateWhere(
      where: (item) => item.id == data['id'],
      newValue: {{feature_name.pascalCase()}}Model.fromJson(data),
    );{{/use_params}}
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
