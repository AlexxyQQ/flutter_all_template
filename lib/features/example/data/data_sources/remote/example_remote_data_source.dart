import 'package:injectable/injectable.dart';

import '../../../../../config/constants/api/api_paths.dart';
import '../../../../../config/constants/type_defs/typedef.dart';
import '../../../../../core/common/domain/entities/params/filter_params.dart';
import '../../../../../core/common/domain/services/network/dio_service.dart';
import '../../../domain/entities/params/example_request_params.dart';
import '../../models/example_model.dart';
import '../example_data_source.dart';

@lazySingleton
class ExampleRemoteDataSource implements ExampleDataSource {
  @override
  ResultFuture<ExampleModel> createExample({
    required ExampleRequestParams params,
  }) {
    return ApiHandler.post<ExampleModel>(
      url: ApiPaths.example,
      data: params.toJson(),
      onSuccess: (data) => ExampleModel.fromJson(data),
    );
  }

  @override
  ResultFuture<ExampleModel> deleteExample({String? id}) {
    return ApiHandler.post<ExampleModel>(
      url: ApiPaths.example + '/$id',
      onSuccess: (data) => ExampleModel.fromJson(data),
    );
  }

  @override
  ResultFuture<ExampleModel> getExample({String? id}) {
    return ApiHandler.get<ExampleModel>(
      url: ApiPaths.example + '/$id',
      onSuccess: (data) => ExampleModel.fromJson(data),
    );
  }

  @override
  ResultFuture<List<ExampleModel>> getExamples({FilterParams? params}) {
    return ApiHandler.get<List<ExampleModel>>(
      url: ApiPaths.example,
      queryParams: params?.toJson(),
      onSuccess: (data) =>
          (data['data'] as List).map((e) => ExampleModel.fromJson(e)).toList(),
    );
  }

  @override
  ResultFuture<ExampleModel> updateExample({
    required ExampleRequestParams params,
  }) {
    return ApiHandler.put<ExampleModel>(
      url: ApiPaths.example + '/${params.id}',
      data: params.toJson(),
      onSuccess: (data) => ExampleModel.fromJson(data),
    );
  }
}
