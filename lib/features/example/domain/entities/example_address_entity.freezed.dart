// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example_address_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExampleAddressEntity {

 String get street; String get city; String get zipCode; double get latitude; double get longitude; bool get isVerified;
/// Create a copy of ExampleAddressEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExampleAddressEntityCopyWith<ExampleAddressEntity> get copyWith => _$ExampleAddressEntityCopyWithImpl<ExampleAddressEntity>(this as ExampleAddressEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExampleAddressEntity&&(identical(other.street, street) || other.street == street)&&(identical(other.city, city) || other.city == city)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}


@override
int get hashCode => Object.hash(runtimeType,street,city,zipCode,latitude,longitude,isVerified);

@override
String toString() {
  return 'ExampleAddressEntity(street: $street, city: $city, zipCode: $zipCode, latitude: $latitude, longitude: $longitude, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class $ExampleAddressEntityCopyWith<$Res>  {
  factory $ExampleAddressEntityCopyWith(ExampleAddressEntity value, $Res Function(ExampleAddressEntity) _then) = _$ExampleAddressEntityCopyWithImpl;
@useResult
$Res call({
 String street, String city, String zipCode, double latitude, double longitude, bool isVerified
});




}
/// @nodoc
class _$ExampleAddressEntityCopyWithImpl<$Res>
    implements $ExampleAddressEntityCopyWith<$Res> {
  _$ExampleAddressEntityCopyWithImpl(this._self, this._then);

  final ExampleAddressEntity _self;
  final $Res Function(ExampleAddressEntity) _then;

/// Create a copy of ExampleAddressEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? street = null,Object? city = null,Object? zipCode = null,Object? latitude = null,Object? longitude = null,Object? isVerified = null,}) {
  return _then(_self.copyWith(
street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,zipCode: null == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ExampleAddressEntity].
extension ExampleAddressEntityPatterns on ExampleAddressEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExampleAddressEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExampleAddressEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExampleAddressEntity value)  $default,){
final _that = this;
switch (_that) {
case _ExampleAddressEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExampleAddressEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ExampleAddressEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String street,  String city,  String zipCode,  double latitude,  double longitude,  bool isVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExampleAddressEntity() when $default != null:
return $default(_that.street,_that.city,_that.zipCode,_that.latitude,_that.longitude,_that.isVerified);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String street,  String city,  String zipCode,  double latitude,  double longitude,  bool isVerified)  $default,) {final _that = this;
switch (_that) {
case _ExampleAddressEntity():
return $default(_that.street,_that.city,_that.zipCode,_that.latitude,_that.longitude,_that.isVerified);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String street,  String city,  String zipCode,  double latitude,  double longitude,  bool isVerified)?  $default,) {final _that = this;
switch (_that) {
case _ExampleAddressEntity() when $default != null:
return $default(_that.street,_that.city,_that.zipCode,_that.latitude,_that.longitude,_that.isVerified);case _:
  return null;

}
}

}

/// @nodoc


class _ExampleAddressEntity extends ExampleAddressEntity {
  const _ExampleAddressEntity({required this.street, required this.city, required this.zipCode, required this.latitude, required this.longitude, this.isVerified = false}): super._();
  

@override final  String street;
@override final  String city;
@override final  String zipCode;
@override final  double latitude;
@override final  double longitude;
@override@JsonKey() final  bool isVerified;

/// Create a copy of ExampleAddressEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExampleAddressEntityCopyWith<_ExampleAddressEntity> get copyWith => __$ExampleAddressEntityCopyWithImpl<_ExampleAddressEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExampleAddressEntity&&(identical(other.street, street) || other.street == street)&&(identical(other.city, city) || other.city == city)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}


@override
int get hashCode => Object.hash(runtimeType,street,city,zipCode,latitude,longitude,isVerified);

@override
String toString() {
  return 'ExampleAddressEntity(street: $street, city: $city, zipCode: $zipCode, latitude: $latitude, longitude: $longitude, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class _$ExampleAddressEntityCopyWith<$Res> implements $ExampleAddressEntityCopyWith<$Res> {
  factory _$ExampleAddressEntityCopyWith(_ExampleAddressEntity value, $Res Function(_ExampleAddressEntity) _then) = __$ExampleAddressEntityCopyWithImpl;
@override @useResult
$Res call({
 String street, String city, String zipCode, double latitude, double longitude, bool isVerified
});




}
/// @nodoc
class __$ExampleAddressEntityCopyWithImpl<$Res>
    implements _$ExampleAddressEntityCopyWith<$Res> {
  __$ExampleAddressEntityCopyWithImpl(this._self, this._then);

  final _ExampleAddressEntity _self;
  final $Res Function(_ExampleAddressEntity) _then;

/// Create a copy of ExampleAddressEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? street = null,Object? city = null,Object? zipCode = null,Object? latitude = null,Object? longitude = null,Object? isVerified = null,}) {
  return _then(_ExampleAddressEntity(
street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,zipCode: null == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
