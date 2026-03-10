import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../config/constants/enums/app_specifics/account_status.dart';
import 'example_address_entity.dart';
import 'example_profile_settings_entity.dart';
import 'example_sub_entity.dart';

part 'example_entity.freezed.dart';

@freezed
abstract class ExampleEntity with _$ExampleEntity {
  const ExampleEntity._();

  const factory ExampleEntity({
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
    required AccountStatus status,
    @Default(AccountStatus.pending) AccountStatus? defaultStatus,
    required ExampleSubEntity mainSubEntity,
    ExampleSubEntity? optionalSubEntity,
    required ExampleAddressEntity primaryAddress,
    ExampleAddressEntity? secondaryAddress,
    required ExampleProfileSettingsEntity settings,
    @Default(const []) List<ExampleAddressEntity>? pastAddresses,
  }) = _ExampleEntity;
}
