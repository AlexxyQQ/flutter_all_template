import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_address_entity.freezed.dart';

@freezed
abstract class ExampleAddressEntity with _$ExampleAddressEntity {
  const factory ExampleAddressEntity({
    required String street,
    required String city,
    required String zipCode,
    required double latitude,
    required double longitude,
    @Default(false) bool isVerified,
  }) = _ExampleAddressEntity;

  const ExampleAddressEntity._();
}
