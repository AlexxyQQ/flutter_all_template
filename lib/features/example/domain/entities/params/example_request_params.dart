import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../config/constants/enums/app_specifics/account_status.dart';
import '../example_address_entity.dart';
import '../example_profile_settings_entity.dart';
import '../example_sub_entity.dart';
import 'example_entity_converters.dart';

part 'example_request_params.freezed.dart';
part 'example_request_params.g.dart';

@freezed
abstract class ExampleRequestParams with _$ExampleRequestParams {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory ExampleRequestParams({
    // --- required fields ---
    required int age,
    required double grade,
    required List<String> friends,
    required Map<String, dynamic> group,
    required List<Map<String, dynamic>> listedGroup,
    @AccountStatusConverter() required AccountStatus status,
    @ExampleSubEntityConverter() required ExampleSubEntity mainSubEntity,
    @ExampleAddressEntityConverter() required ExampleAddressEntity primaryAddress,
    @ExampleProfileSettingsEntityConverter()
    required ExampleProfileSettingsEntity settings,
    // --- optional fields ---
    String? id,
    String? emptyId,
    @Default('id') String? defaultId,
    int? emptyAge,
    @Default(18) int? defaultAge,
    double? emptyGrade,
    @Default(99.6) double? defaultGrade,
    List<String>? emptyFriends,
    @Default(const ['a', 'b', 'c']) List<String>? defaultFriends,
    Map<String, dynamic>? emptyGroup,
    @Default(const {'a': 1, 'b': 2, 'c': 3}) Map<String, dynamic>? defaultGroup,
    List<Map<String, dynamic>>? emptyListedGroup,
    @Default(const [
      {'a': 1, 'b': 2, 'c': 3},
      {'d': 4, 'e': 5, 'f': 6},
    ])
    List<Map<String, dynamic>>? defaultListedGroup,
    @AccountStatusConverter()
    @Default(AccountStatus.pending)
    AccountStatus defaultStatus,
    @NullableExampleSubEntityConverter() ExampleSubEntity? optionalSubEntity,
    @NullableExampleAddressEntityConverter() ExampleAddressEntity? secondaryAddress,
    @ExampleAddressEntityConverter()
    @Default(const [])
    List<ExampleAddressEntity> pastAddresses,
  }) = _ExampleRequestParams;

  const ExampleRequestParams._();
  factory ExampleRequestParams.fromJson(Map<String, dynamic> json) =>
      _$ExampleRequestParamsFromJson(json);
}
