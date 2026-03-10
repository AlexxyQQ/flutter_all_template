import '../../../../config/constants/type_defs/typedef.dart';
import '../../../../core/common/domain/entities/params/filter_params.dart';
import '../../domain/entities/params/example_request_params.dart';
import '../models/example_model.dart';

abstract class ExampleDataSource {
  ResultFuture<List<ExampleModel>> getExamples({FilterParams? params});
  ResultFuture<ExampleModel> getExample({String? id});
  ResultFuture<ExampleModel> deleteExample({String? id});
  ResultFuture<ExampleModel> updateExample({
    required ExampleRequestParams params,
  });
  ResultFuture<ExampleModel> createExample({
    required ExampleRequestParams params,
  });
}
