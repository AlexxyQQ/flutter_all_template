import 'package:freezed_annotation/freezed_annotation.dart';

part '{{feature_name.snakeCase()}}_entity.freezed.dart';

@freezed
abstract class {{feature_name.pascalCase()}}Entity with _${{feature_name.pascalCase()}}Entity {
  const {{feature_name.pascalCase()}}Entity._();

  const factory {{feature_name.pascalCase()}}Entity({
    required String id,
    // TODO: add your domain fields here
  }) = _{{feature_name.pascalCase()}}Entity;
}
