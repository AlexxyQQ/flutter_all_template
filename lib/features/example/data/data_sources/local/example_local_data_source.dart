import 'package:fpdart/src/either.dart';
import 'package:fpdart/src/unit.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/constants/type_defs/typedef.dart';
import '../../../../../core/common/data/models/helpers/model_conversion_helper.dart';
import '../../../../../core/common/domain/entities/failure.dart';
import '../../../../../core/common/domain/entities/params/filter_params.dart';
import '../../../../../core/common/domain/services/storage/secure_storage_service.dart';
import '../../../../../core/common/locator/service_locator.dart';
import '../../../../../core/generic/data/data_sources/local/secure_storage_data_source.dart';
import '../../../domain/entities/params/example_request_params.dart';
import '../../models/example_model.dart';
import '../example_data_source.dart';

@lazySingleton
class ExampleLocalDataSource extends ISecureStorageDataSource<ExampleModel>
    implements ExampleDataSource {
  ExampleLocalDataSource()
    : super(
        secureStorageService: sl<SecureStorageService>(),
        modelKey: 'app_example',
      );

  @override
  ExampleModel copyWith(existingItem, newValue) {
    return existingItem.copyWith(
      id: newValue.id ?? existingItem.id,
      emptyId: newValue.emptyId ?? existingItem.emptyId,
      defaultId: newValue.defaultId ?? existingItem.defaultId,
      age: newValue.age ?? existingItem.age,
      emptyAge: newValue.emptyAge ?? existingItem.emptyAge,
      defaultAge: newValue.defaultAge ?? existingItem.defaultAge,
      grade: newValue.grade ?? existingItem.grade,
      emptyGrade: newValue.emptyGrade ?? existingItem.emptyGrade,
      defaultGrade: newValue.defaultGrade ?? existingItem.defaultGrade,
      friends: newValue.friends ?? existingItem.friends,
      emptyFriends: newValue.emptyFriends ?? existingItem.emptyFriends,
      defaultFriends: newValue.defaultFriends ?? existingItem.defaultFriends,
      group: newValue.group ?? existingItem.group,
      emptyGroup: newValue.emptyGroup ?? existingItem.emptyGroup,
      defaultGroup: newValue.defaultGroup ?? existingItem.defaultGroup,
      listedGroup: newValue.listedGroup ?? existingItem.listedGroup,
      emptyListedGroup:
          newValue.emptyListedGroup ?? existingItem.emptyListedGroup,
      defaultListedGroup:
          newValue.defaultListedGroup ?? existingItem.defaultListedGroup,
      status: newValue.status ?? existingItem.status,
      defaultStatus: newValue.defaultStatus ?? existingItem.defaultStatus,
      mainSubEntity: newValue.mainSubEntity ?? existingItem.mainSubEntity,
      optionalSubEntity:
          newValue.optionalSubEntity ?? existingItem.optionalSubEntity,
      primaryAddress: newValue.primaryAddress ?? existingItem.primaryAddress,
      secondaryAddress:
          newValue.secondaryAddress ?? existingItem.secondaryAddress,
      settings: newValue.settings ?? existingItem.settings,
      pastAddresses: newValue.pastAddresses ?? existingItem.pastAddresses,
    );
  }

  @override
  ExampleModel fromJson(Map<String, dynamic> json) {
    return ExampleModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(ExampleModel object) {
    return object.toJson();
  }

  @override
  ResultFuture<ExampleModel> createExample({
    required ExampleRequestParams params,
  }) async {
    final data = await create(value: params.toModel());
    return data.fold((l) => Left(l), (r) => Right(r.first));
  }

  @override
  ResultFuture<ExampleModel> deleteExample({String? id}) async {
    final data = await deleteWhere(where: (id) => id == id);
    return data.fold((l) => Left(l), (r) => Right(r.first));
  }

  @override
  ResultFuture<ExampleModel> getExample({String? id}) async {
    final data = await getWhere(where: (id) => id == id);
    return data.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  ResultFuture<List<ExampleModel>> getExamples({FilterParams? params}) async {
    final data = await getAll();
    return data.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  ResultFuture<ExampleModel> updateExample({
    required ExampleRequestParams params,
  }) async {
    final data = await updateWhere(
      where: (id) => id == id,
      newValue: params.toModel(),
    );
    return data.fold((l) => Left(l), (r) => Right(r));
  }
}
