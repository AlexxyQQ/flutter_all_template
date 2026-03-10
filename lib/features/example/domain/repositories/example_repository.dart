import '../../../../config/constants/type_defs/typedef.dart';
import '../../../../core/common/domain/entities/params/filter_params.dart';
import '../entities/example_entity.dart';
import '../entities/params/example_request_params.dart';

abstract class IExampleRepository {
  ResultFuture<List<ExampleEntity>> getExamples({FilterParams? params});
  ResultFuture<ExampleEntity> getExample({String? id});
  ResultFuture<ExampleEntity> deleteExample({String? id});
  ResultFuture<ExampleEntity> updateExample({
    required ExampleRequestParams params,
  });
  ResultFuture<ExampleEntity> createExample({
    required ExampleRequestParams params,
  });
}
