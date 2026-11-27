import 'package:equatable/equatable.dart';

/// A {{feature_name.pascalCase()}}. Pure domain object: no JSON, no Flutter.
///
/// Add your domain fields here, in `{{feature_name.pascalCase()}}Model` and (if present) the params.
final class {{feature_name.pascalCase()}} extends Equatable {
  const {{feature_name.pascalCase()}}({
    required this.id,
    required this.title,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final DateTime updatedAt;

  {{feature_name.pascalCase()}} copyWith({String? title, DateTime? updatedAt}) => {{feature_name.pascalCase()}}(
    id: id,
    title: title ?? this.title,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  List<Object?> get props => [id, title, updatedAt];
}
