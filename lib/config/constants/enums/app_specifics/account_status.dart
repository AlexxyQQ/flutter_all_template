import 'package:json_annotation/json_annotation.dart';

part 'account_status.g.dart';

@JsonEnum(alwaysCreate: true)
enum AccountStatus {
  @JsonValue('active')
  active,
  @JsonValue('inactive')
  inactive,
  @JsonValue('suspended')
  suspended,
  @JsonValue('pending')
  pending;

  String toJson() => _$AccountStatusEnumMap[this]!;

  static AccountStatus? fromString(String? value) => values.firstWhere(
    (element) => element.name.toLowerCase() == value?.toLowerCase(),
    orElse: () => values.first,
  );
}

class AccountStatusConverter implements JsonConverter<AccountStatus?, String?> {
  const AccountStatusConverter();

  @override
  AccountStatus? fromJson(String? json) {
    if (json == null) return null;
    return AccountStatus.values
        .where((e) => e.name.toLowerCase() == json.toLowerCase())
        .firstOrNull;
  }

  @override
  String? toJson(AccountStatus? object) => object?.toJson();
}
