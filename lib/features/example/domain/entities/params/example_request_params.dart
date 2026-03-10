import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../config/constants/enums/app_specifics/account_status.dart';
import '../../../../../core/common/data/models/helpers/model_generation_helper.dart';
import '../../../data/models/example_address_model.dart';
import '../../../data/models/example_model.dart';
import '../../../data/models/example_profile_settings_model.dart';
import '../../../data/models/example_sub_model.dart';
import '../example_address_entity.dart';
import '../example_entity.dart';
import '../example_profile_settings_entity.dart';
import '../example_sub_entity.dart';

part 'example_request_params.freezed.dart';
part 'example_request_params.g.dart';

@freezed
abstract class ExampleRequestParams with _$ExampleRequestParams {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory ExampleRequestParams({
    String? id,
    String? emptyId,
    @Default('id') String? defaultId,
    required int age,
    int? emptyAge,
    @Default(18) int? defaultAge,
    required double grade,
    double? emptyGrade,
    @Default(99.6) double? defaultGrade,
    required List<String> friends,
    List<String>? emptyFriends,
    @Default(const ['a', 'b', 'c']) List<String>? defaultFriends,
    required Map<String, dynamic> group,
    Map<String, dynamic>? emptyGroup,
    @Default(const {'a': 1, 'b': 2, 'c': 3}) Map<String, dynamic>? defaultGroup,
    required List<Map<String, dynamic>> listedGroup,
    List<Map<String, dynamic>>? emptyListedGroup,
    @Default(const [
      {'a': 1, 'b': 2, 'c': 3},
      {'d': 4, 'e': 5, 'f': 6},
    ])
    List<Map<String, dynamic>>? defaultListedGroup,
    @AccountStatusConverter() required AccountStatus status,
    @AccountStatusConverter()
    @Default(AccountStatus.pending)
    AccountStatus? defaultStatus,
    required ExampleSubModel mainSubEntity,
    ExampleSubModel? optionalSubEntity,
    required ExampleAddressModel primaryAddress,
    ExampleAddressModel? secondaryAddress,
    required ExampleProfileSettingsModel settings,
    @Default(const []) List<ExampleAddressModel>? pastAddresses,
  }) = _ExampleRequestParams;

  const ExampleRequestParams._();
  factory ExampleRequestParams.fromJson(Map<String, dynamic> json) =>
      _$ExampleRequestParamsFromJson(json);

  factory ExampleRequestParams.create({
    String? emptyId,
    String? defaultId,
    required int age,
    int? emptyAge,
    int? defaultAge,
    required double grade,
    double? emptyGrade,
    double? defaultGrade,
    required List<String> friends,
    List<String>? emptyFriends,
    List<String>? defaultFriends,
    required Map<String, dynamic> group,
    Map<String, dynamic>? emptyGroup,
    Map<String, dynamic>? defaultGroup,
    required List<Map<String, dynamic>> listedGroup,
    List<Map<String, dynamic>>? emptyListedGroup,
    List<Map<String, dynamic>>? defaultListedGroup,
    required AccountStatus status,
    AccountStatus? defaultStatus,
    required ExampleSubEntity mainSubEntity,
    ExampleSubEntity? optionalSubEntity,
    required ExampleAddressEntity primaryAddress,
    ExampleAddressEntity? secondaryAddress,
    required ExampleProfileSettingsEntity settings,
    List<ExampleAddressEntity>? pastAddresses,
  }) {
    return ExampleRequestParams(
      id: ModelGeneratorHelper.generateUuidFromJson(null),
      emptyId: emptyId,
      defaultId: defaultId,
      age: age,
      emptyAge: emptyAge,
      defaultAge: defaultAge,
      grade: grade,
      emptyGrade: emptyGrade,
      defaultGrade: defaultGrade,
      friends: friends,
      emptyFriends: emptyFriends,
      defaultFriends: defaultFriends,
      group: group,
      emptyGroup: emptyGroup,
      defaultGroup: defaultGroup,
      listedGroup: listedGroup,
      emptyListedGroup: emptyListedGroup,
      defaultListedGroup: defaultListedGroup,
      status: status,
      defaultStatus: defaultStatus,
      mainSubEntity: mainSubEntity.toModel(),
      optionalSubEntity: optionalSubEntity?.toModel(),
      primaryAddress: primaryAddress.toModel(),
      secondaryAddress: secondaryAddress?.toModel(),
      settings: settings.toModel(),
      pastAddresses: pastAddresses?.toModels(),
    );
  }
}

// -----------------------------------------------------------------------------
// Params -> Model & Entity
// -----------------------------------------------------------------------------
extension ExampleRequestParamsMapper on ExampleRequestParams {
  ExampleModel toModel() {
    return ExampleModel(
      id: id ?? ModelGeneratorHelper.generateUuidFromJson(id),
      emptyId: emptyId,
      defaultId: defaultId,
      age: age,
      emptyAge: emptyAge,
      defaultAge: defaultAge,
      grade: grade,
      emptyGrade: emptyGrade,
      defaultGrade: defaultGrade,
      friends: friends,
      emptyFriends: emptyFriends,
      defaultFriends: defaultFriends,
      group: group,
      emptyGroup: emptyGroup,
      defaultGroup: defaultGroup,
      listedGroup: listedGroup,
      emptyListedGroup: emptyListedGroup,
      defaultListedGroup: defaultListedGroup,
      status: status,
      defaultStatus: defaultStatus,
      mainSubEntity: mainSubEntity,
      optionalSubEntity: optionalSubEntity,
      primaryAddress: primaryAddress,
      secondaryAddress: secondaryAddress,
      settings: settings,
      pastAddresses: pastAddresses,
    );
  }

  ExampleEntity toEntity() {
    return ExampleEntity(
      id: id ?? ModelGeneratorHelper.generateUuidFromJson(id),
      emptyId: emptyId,
      defaultId: defaultId,
      age: age,
      emptyAge: emptyAge,
      defaultAge: defaultAge,
      grade: grade,
      emptyGrade: emptyGrade,
      defaultGrade: defaultGrade,
      friends: friends,
      emptyFriends: emptyFriends,
      defaultFriends: defaultFriends,
      group: group,
      emptyGroup: emptyGroup,
      defaultGroup: defaultGroup,
      listedGroup: listedGroup,
      emptyListedGroup: emptyListedGroup,
      defaultListedGroup: defaultListedGroup,
      status: status,
      defaultStatus: defaultStatus,
      mainSubEntity: mainSubEntity.toEntity(),
      optionalSubEntity: optionalSubEntity?.toEntity(),
      primaryAddress: primaryAddress.toEntity(),
      secondaryAddress: secondaryAddress?.toEntity(),
      settings: settings.toEntity(),
      pastAddresses: pastAddresses?.toEntities(),
    );
  }
}

// -----------------------------------------------------------------------------
// Model -> Params
// -----------------------------------------------------------------------------
extension ExampleModelMapper on ExampleModel {
  ExampleRequestParams toParams() {
    return ExampleRequestParams(
      id: id,

      emptyId: emptyId,
      defaultId: defaultId,
      age: age,
      emptyAge: emptyAge,
      defaultAge: defaultAge,
      grade: grade,
      emptyGrade: emptyGrade,
      defaultGrade: defaultGrade,
      friends: friends,
      emptyFriends: emptyFriends,
      defaultFriends: defaultFriends,
      group: group,
      emptyGroup: emptyGroup,
      defaultGroup: defaultGroup,
      listedGroup: listedGroup,
      emptyListedGroup: emptyListedGroup,
      defaultListedGroup: defaultListedGroup,
      status: status,
      defaultStatus: defaultStatus,
      mainSubEntity: mainSubEntity,
      optionalSubEntity: optionalSubEntity,
      primaryAddress: primaryAddress,
      secondaryAddress: secondaryAddress,
      settings: settings,
      pastAddresses: pastAddresses,
    );
  }
}

// -----------------------------------------------------------------------------
// Entity -> Params
// -----------------------------------------------------------------------------
extension ExampleEntityMapper on ExampleEntity {
  ExampleRequestParams toParams() {
    return ExampleRequestParams(
      id: id,

      emptyId: emptyId,
      defaultId: defaultId,
      age: age,
      emptyAge: emptyAge,
      defaultAge: defaultAge,
      grade: grade,
      emptyGrade: emptyGrade,
      defaultGrade: defaultGrade,
      friends: friends,
      emptyFriends: emptyFriends,
      defaultFriends: defaultFriends,
      group: group,
      emptyGroup: emptyGroup,
      defaultGroup: defaultGroup,
      listedGroup: listedGroup,
      emptyListedGroup: emptyListedGroup,
      defaultListedGroup: defaultListedGroup,
      status: status,
      defaultStatus: defaultStatus,
      mainSubEntity: mainSubEntity.toModel(),
      optionalSubEntity: optionalSubEntity?.toModel(),
      primaryAddress: primaryAddress.toModel(),
      secondaryAddress: secondaryAddress?.toModel(),
      settings: settings.toModel(),
      pastAddresses: pastAddresses?.toModels(),
    );
  }
}

// -----------------------------------------------------------------------------
// HELPER MAPPERS
// -----------------------------------------------------------------------------
extension ExampleRequestParamsListMapper on List<ExampleRequestParams> {
  List<ExampleModel> toModels() => map((e) => e.toModel()).toList();
  List<ExampleEntity> toEntities() => map((e) => e.toEntity()).toList();
}

extension ExampleModelListMapper on List<ExampleModel> {
  List<ExampleRequestParams> toModels() => map((e) => e.toParams()).toList();
}

extension ExampleEntityListMapper on List<ExampleEntity> {
  List<ExampleRequestParams> toParams() => map((e) => e.toParams()).toList();
}
