import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/example_address_entity.dart';

// TODO: Ensure all nested models are imported here

part 'example_address_model.freezed.dart';
part 'example_address_model.g.dart';

@freezed
abstract class ExampleAddressModel with _$ExampleAddressModel {
  const ExampleAddressModel._();

  @JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
  const factory ExampleAddressModel({
    required String street,
    required String city,
    required String zipCode,
    required double latitude,
    required double longitude,
    @Default(false) bool isVerified,
  }) = _ExampleAddressModel;

  factory ExampleAddressModel.fromJson(Map<String, dynamic> json) =>
      _$ExampleAddressModelFromJson(json);
}

// -----------------------------------------------------------------------------
// MODEL -> ENTITY
// -----------------------------------------------------------------------------
extension ExampleAddressModelMapper on ExampleAddressModel {
  ExampleAddressEntity toEntity() {
    return ExampleAddressEntity(
      street: street,
      city: city,
      zipCode: zipCode,
      latitude: latitude,
      longitude: longitude,
      isVerified: isVerified,
    );
  }
}

// -----------------------------------------------------------------------------
// ENTITY -> MODEL
// -----------------------------------------------------------------------------
extension ExampleAddressEntityMapper on ExampleAddressEntity {
  ExampleAddressModel toModel() {
    return ExampleAddressModel(
      street: street,
      city: city,
      zipCode: zipCode,
      latitude: latitude,
      longitude: longitude,
      isVerified: isVerified,
    );
  }
}

// -----------------------------------------------------------------------------
// HELPER LIST MAPPERS
// -----------------------------------------------------------------------------
extension ExampleAddressModelListMapper on List<ExampleAddressModel> {
  List<ExampleAddressEntity> toEntities() => map((e) => e.toEntity()).toList();
}

extension ExampleAddressEntityListMapper on List<ExampleAddressEntity> {
  List<ExampleAddressModel> toModels() => map((e) => e.toModel()).toList();
}
