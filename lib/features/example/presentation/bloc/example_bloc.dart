import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/constants/type_defs/typedef.dart';
import '../../../../core/common/domain/entities/params/filter_params.dart';
import '../../../../core/generic/presentation/bloc/crud/base_crud_bloc.dart';
import '../../domain/entities/example_entity.dart';
import '../../domain/entities/params/example_request_params.dart';
import '../../domain/repositories/example_repository.dart';

@injectable
class ExampleBloc extends BaseCrudBloc<ExampleEntity>
    with
        ReadCrudMixin<ExampleEntity>,
        CreateCrudMixin<ExampleEntity>,
        UpdateCrudMixin<ExampleEntity>,
        DeleteCrudMixin<ExampleEntity>,
        SelectableCrudMixin<ExampleEntity>,
        SearchableCrudMixin<ExampleEntity>,
        PaginatedCrudMixin<ExampleEntity, FilterParams> {
  ExampleBloc({required IExampleRepository repository})
    : _repository = repository,
      super(name: 'Example') {
    registerCreateHandlers();
    registerReadHandlers();
    registerUpdateHandlers();
    registerDeleteHandlers();
    registerPaginationHandlers();
    registerSearchHandlers();
    registerSelectHandlers();
  }

  final IExampleRepository _repository;

  @override
  ResultFuture<ExampleEntity?> createEntity(Map<String, dynamic> entity) {
    return _repository.createExample(
      params: ExampleRequestParams.fromJson(entity),
    );
  }

  @override
  ResultFuture<List<ExampleEntity>?> createMultipleEntity(
    List<Map<String, dynamic>> entities,
  ) {
    // TODO: implement createMultipleEntity
    throw UnimplementedError();
  }

  @override
  ResultFuture<bool> deleteEntity({id}) async {
    final result = await _repository.deleteExample(id: id);
    return result.fold((l) => Left(l), (r) => const Right(true));
  }

  @override
  String getEntityId(ExampleEntity entity) {
    return entity.id;
  }

  @override
  ResultFuture<PaginationResponse<ExampleEntity>> paginatedRead({
    required FilterParams filters,
    int? page,
    int? limit,
    String? nextToken,
  }) async {
    final data = await _repository.getExamples(
      params: filters.copyWith(page: page ?? 0, limit: limit ?? 10),
    );
    return data.fold((l) => Left(l), (r) {
      final result = PaginationResponse<ExampleEntity>(
        entities: r,
        hasReachedEnd: r.length < filters.limit,
      );
      return Right(result);
    });
  }

  @override
  ResultFuture<ExampleEntity> readEntity({id}) {
    return _repository.getExample(id: id);
  }

  @override
  ResultFuture<List<ExampleEntity>> readMultipleEntity() {
    return _repository.getExamples();
  }

  @override
  ResultFuture<ExampleEntity?> updateEntity(
    id,
    Map<String, dynamic> updatedData,
  ) {
    return _repository.updateExample(
      params: ExampleRequestParams.fromJson(updatedData).copyWith(id: id),
    );
  }

  @override
  bool isLocalSearchMatch(ExampleEntity entity, String query) {
    // TODO: implement isLocalSearchMatch
    throw UnimplementedError();
  }

  @override
  ResultFuture<List<ExampleEntity>> search({String? query}) {
    return _repository.getExamples(params: FilterParams(query: query));
  }
}
