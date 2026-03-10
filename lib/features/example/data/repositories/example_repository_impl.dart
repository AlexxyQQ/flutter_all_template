import '../../../../config/constants/type_defs/typedef.dart';
import '../../../../core/common/data/models/helpers/model_conversion_helper.dart';
import '../../../../core/common/domain/entities/params/filter_params.dart';
import '../../domain/entities/example_entity.dart';
import '../../domain/entities/params/example_request_params.dart';
import '../../domain/repositories/example_repository.dart';
import '../data_sources/local/example_local_data_source.dart';
import '../data_sources/remote/example_remote_data_source.dart';
import '../models/example_model.dart';

class ExampleRepositoryImpl implements IExampleRepository {
  ExampleRepositoryImpl({
    required ExampleLocalDataSource localDataSource,
    required ExampleRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  final ExampleLocalDataSource _localDataSource;
  final ExampleRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<ExampleEntity> createExample({
    required ExampleRequestParams params,
  }) {
    return _remoteDataSource
        .createExample(params: params)
        .mapModelToEntity((model) => model.toEntity());
  }

  @override
  ResultFuture<ExampleEntity> deleteExample({String? id}) {
    return _remoteDataSource
        .deleteExample(id: id)
        .mapModelToEntity((model) => model.toEntity());
  }

  @override
  ResultFuture<ExampleEntity> getExample({String? id}) {
    return _remoteDataSource
        .getExample(id: id)
        .mapModelToEntity((model) => model.toEntity());
  }

  @override
  ResultFuture<List<ExampleEntity>> getExamples({FilterParams? params}) {
    return _remoteDataSource
        .getExamples(params: params)
        .mapModelListToEntityList((models) => models.toEntity());
  }

  @override
  ResultFuture<ExampleEntity> updateExample({
    required ExampleRequestParams params,
  }) {
    return _remoteDataSource
        .updateExample(params: params)
        .mapModelToEntity((model) => model.toEntity());
  }
}
