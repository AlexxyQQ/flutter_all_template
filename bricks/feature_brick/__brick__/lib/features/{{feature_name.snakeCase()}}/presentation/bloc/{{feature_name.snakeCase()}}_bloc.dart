import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/constants/type_defs/typedef.dart';
import '../../../../core/common/domain/entities/params/filter_params.dart';
import '../../../../core/generic/presentation/bloc/crud/base_crud_bloc.dart';
import '../../domain/entities/{{feature_name.snakeCase()}}_entity.dart';
{{#use_params}}import '../../domain/entities/params/{{feature_name.snakeCase()}}_request_params.dart';
{{/use_params}}import '../../domain/repositories/{{feature_name.snakeCase()}}_repository.dart';

@injectable
class {{feature_name.pascalCase()}}Bloc extends BaseCrudBloc<{{feature_name.pascalCase()}}Entity>
    with
        ReadCrudMixin<{{feature_name.pascalCase()}}Entity>,
        CreateCrudMixin<{{feature_name.pascalCase()}}Entity>,
        UpdateCrudMixin<{{feature_name.pascalCase()}}Entity>,
        DeleteCrudMixin<{{feature_name.pascalCase()}}Entity>,
        SelectableCrudMixin<{{feature_name.pascalCase()}}Entity>,
        SearchableCrudMixin<{{feature_name.pascalCase()}}Entity>,
        PaginatedCrudMixin<{{feature_name.pascalCase()}}Entity, FilterParams> {
  {{feature_name.pascalCase()}}Bloc({required I{{feature_name.pascalCase()}}Repository repository})
    : _repository = repository,
      super(name: '{{feature_name.pascalCase()}}') {
    registerCreateHandlers();
    registerReadHandlers();
    registerUpdateHandlers();
    registerDeleteHandlers();
    registerPaginationHandlers();
    registerSearchHandlers();
    registerSelectHandlers();
  }

  final I{{feature_name.pascalCase()}}Repository _repository;

  @override
  ResultFuture<{{feature_name.pascalCase()}}Entity?> createEntity(Map<String, dynamic> entity) {
    return _repository.create{{feature_name.pascalCase()}}(
      {{#use_params}}params: {{feature_name.pascalCase()}}RequestParams.fromJson(entity),{{/use_params}}{{^use_params}}data: entity,{{/use_params}}
    );
  }

  @override
  ResultFuture<List<{{feature_name.pascalCase()}}Entity>?> createMultipleEntity(
    List<Map<String, dynamic>> entities,
  ) {
    // TODO: implement createMultipleEntity
    throw UnimplementedError();
  }

  @override
  ResultFuture<bool> deleteEntity({id}) async {
    final result = await _repository.delete{{feature_name.pascalCase()}}(id: id);
    return result.fold((l) => Left(l), (r) => const Right(true));
  }

  @override
  String getEntityId({{feature_name.pascalCase()}}Entity entity) {
    return entity.id;
  }

  @override
  ResultFuture<PaginationResponse<{{feature_name.pascalCase()}}Entity>> paginatedRead({
    required FilterParams filters,
    int? page,
    int? limit,
    String? nextToken,
  }) async {
    final data = await _repository.get{{feature_name.pascalCase()}}s(
      params: filters.copyWith(page: page ?? 0, limit: limit ?? 10),
    );
    return data.fold((l) => Left(l), (r) {
      final result = PaginationResponse<{{feature_name.pascalCase()}}Entity>(
        entities: r,
        hasReachedEnd: r.length < filters.limit,
      );
      return Right(result);
    });
  }

  @override
  ResultFuture<{{feature_name.pascalCase()}}Entity> readEntity({id}) {
    return _repository.get{{feature_name.pascalCase()}}(id: id);
  }

  @override
  ResultFuture<List<{{feature_name.pascalCase()}}Entity>> readMultipleEntity() {
    return _repository.get{{feature_name.pascalCase()}}s();
  }

  @override
  ResultFuture<{{feature_name.pascalCase()}}Entity?> updateEntity(
    id,
    Map<String, dynamic> updatedData,
  ) {
    return _repository.update{{feature_name.pascalCase()}}(
      {{#use_params}}params: {{feature_name.pascalCase()}}RequestParams.fromJson(updatedData).copyWith(id: id),{{/use_params}}{{^use_params}}data: {...updatedData, 'id': id},{{/use_params}}
    );
  }

  @override
  bool isLocalSearchMatch({{feature_name.pascalCase()}}Entity entity, String query) {
    // TODO: implement isLocalSearchMatch
    throw UnimplementedError();
  }

  @override
  ResultFuture<List<{{feature_name.pascalCase()}}Entity>> search({String? query}) {
    return _repository.get{{feature_name.pascalCase()}}s(params: FilterParams(query: query));
  }
}
