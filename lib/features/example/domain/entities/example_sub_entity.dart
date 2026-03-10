import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_sub_entity.freezed.dart';

@freezed
abstract class ExampleSubEntity with _$ExampleSubEntity {
  const ExampleSubEntity._();

  const factory ExampleSubEntity({
    required String subId,
    required String description,
    required bool isActive,
    @Default(true) bool isVisible,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ExampleSubEntity;
}
