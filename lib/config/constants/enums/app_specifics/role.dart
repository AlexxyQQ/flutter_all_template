import 'package:json_annotation/json_annotation.dart';

part 'role.g.dart';

@JsonEnum(alwaysCreate: true)
enum Role {
  @JsonValue('admin')
  admin,
  @JsonValue('moderator')
  moderator,
  @JsonValue('user')
  user,
  @JsonValue('guest')
  guest;

  String toJson() => _$RoleEnumMap[this]!;

  static Role? fromString(String? value) => values.firstWhere(
    (element) => element.name.toLowerCase() == value?.toLowerCase(),
    orElse: () => values.first,
  );
}

class RoleConverter implements JsonConverter<Role, String?> {
  const RoleConverter();

  @override
  Role fromJson(String? json) {
    if (json == null) return Role.values.first;
    return Role.values.firstWhere(
      (e) => e.name.toLowerCase() == json.toLowerCase(),
      orElse: () => Role.values.first,
    );
  }

  @override
  String? toJson(Role object) => object.toJson();
}
