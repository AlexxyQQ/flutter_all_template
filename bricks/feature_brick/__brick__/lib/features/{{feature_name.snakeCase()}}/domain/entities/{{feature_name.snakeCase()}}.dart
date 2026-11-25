import 'package:freezed_annotation/freezed_annotation.dart';

part '{{feature_name.snakeCase()}}.freezed.dart';

/// A {{feature_name.pascalCase()}}. Pure domain object: no JSON, no Flutter.
///
/// Add your domain fields here, in `{{feature_name.pascalCase()}}Model` and (if present) the params.
@freezed
abstract class {{feature_name.pascalCase()}} with _${{feature_name.pascalCase()}} {
  const factory {{feature_name.pascalCase()}}({
    required String id,
    required String title,
    required DateTime updatedAt,
  }) = _{{feature_name.pascalCase()}};
}
