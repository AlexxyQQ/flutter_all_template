import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../config/constants/enums/app_specifics/account_status.dart';
import '../../../../core/common/data/models/helpers/model_generation_helper.dart';
import '../../domain/entities/example_entity.dart';
import 'example_address_model.dart';
import 'example_profile_settings_model.dart';
import 'example_sub_model.dart';

part 'example_model.freezed.dart';
part 'example_model.g.dart';

@freezed
abstract class ExampleModel with _$ExampleModel {
  const ExampleModel._();

  @JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
  const factory ExampleModel({
    @JsonKey(fromJson: ModelGeneratorHelper.generateUuidFromJson)
    required String id,
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
    AccountStatus defaultStatus,
    required ExampleSubModel mainSubEntity,
    ExampleSubModel? optionalSubEntity,
    required ExampleAddressModel primaryAddress,
    ExampleAddressModel? secondaryAddress,
    required ExampleProfileSettingsModel settings,
    @Default(const []) List<ExampleAddressModel> pastAddresses,
  }) = _ExampleModel;

  factory ExampleModel.fromJson(Map<String, dynamic> json) =>
      _$ExampleModelFromJson(json);
}

// -----------------------------------------------------------------------------
// MODEL -> ENTITY
// -----------------------------------------------------------------------------
extension ExampleModelMapper on ExampleModel {
  ExampleEntity toEntity() {
    return ExampleEntity(
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
      mainSubEntity: mainSubEntity.toEntity(),
      optionalSubEntity: optionalSubEntity?.toEntity(),
      primaryAddress: primaryAddress.toEntity(),
      secondaryAddress: secondaryAddress?.toEntity(),
      settings: settings.toEntity(),
      pastAddresses: pastAddresses.map((e) => e.toEntity()).toList(),
    );
  }
}

// -----------------------------------------------------------------------------
// ENTITY -> MODEL
// -----------------------------------------------------------------------------
extension ExampleEntityMapper on ExampleEntity {
  ExampleModel toModel() {
    return ExampleModel(
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
      pastAddresses: pastAddresses.map((e) => e.toModel()).toList(),
    );
  }
}

// -----------------------------------------------------------------------------
// HELPER LIST MAPPERS
// -----------------------------------------------------------------------------
extension ExampleModelListMapper on List<ExampleModel> {
  List<ExampleEntity> toEntities() => map((e) => e.toEntity()).toList();
}

extension ExampleEntityListMapper on List<ExampleEntity> {
  List<ExampleModel> toModels() => map((e) => e.toModel()).toList();
}
