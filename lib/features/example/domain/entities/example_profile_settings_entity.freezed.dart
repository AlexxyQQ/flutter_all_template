// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example_profile_settings_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExampleProfileSettingsEntity {

 Role get userRole; Role get fallbackRole; bool get emailNotificationsEnabled; bool get smsNotificationsEnabled; ExampleAddressEntity? get billingAddress;
/// Create a copy of ExampleProfileSettingsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExampleProfileSettingsEntityCopyWith<ExampleProfileSettingsEntity> get copyWith => _$ExampleProfileSettingsEntityCopyWithImpl<ExampleProfileSettingsEntity>(this as ExampleProfileSettingsEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExampleProfileSettingsEntity&&(identical(other.userRole, userRole) || other.userRole == userRole)&&(identical(other.fallbackRole, fallbackRole) || other.fallbackRole == fallbackRole)&&(identical(other.emailNotificationsEnabled, emailNotificationsEnabled) || other.emailNotificationsEnabled == emailNotificationsEnabled)&&(identical(other.smsNotificationsEnabled, smsNotificationsEnabled) || other.smsNotificationsEnabled == smsNotificationsEnabled)&&(identical(other.billingAddress, billingAddress) || other.billingAddress == billingAddress));
}


@override
int get hashCode => Object.hash(runtimeType,userRole,fallbackRole,emailNotificationsEnabled,smsNotificationsEnabled,billingAddress);

@override
String toString() {
  return 'ExampleProfileSettingsEntity(userRole: $userRole, fallbackRole: $fallbackRole, emailNotificationsEnabled: $emailNotificationsEnabled, smsNotificationsEnabled: $smsNotificationsEnabled, billingAddress: $billingAddress)';
}


}

/// @nodoc
abstract mixin class $ExampleProfileSettingsEntityCopyWith<$Res>  {
  factory $ExampleProfileSettingsEntityCopyWith(ExampleProfileSettingsEntity value, $Res Function(ExampleProfileSettingsEntity) _then) = _$ExampleProfileSettingsEntityCopyWithImpl;
@useResult
$Res call({
 Role userRole, Role fallbackRole, bool emailNotificationsEnabled, bool smsNotificationsEnabled, ExampleAddressEntity? billingAddress
});


$ExampleAddressEntityCopyWith<$Res>? get billingAddress;

}
/// @nodoc
class _$ExampleProfileSettingsEntityCopyWithImpl<$Res>
    implements $ExampleProfileSettingsEntityCopyWith<$Res> {
  _$ExampleProfileSettingsEntityCopyWithImpl(this._self, this._then);

  final ExampleProfileSettingsEntity _self;
  final $Res Function(ExampleProfileSettingsEntity) _then;

/// Create a copy of ExampleProfileSettingsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userRole = null,Object? fallbackRole = null,Object? emailNotificationsEnabled = null,Object? smsNotificationsEnabled = null,Object? billingAddress = freezed,}) {
  return _then(_self.copyWith(
userRole: null == userRole ? _self.userRole : userRole // ignore: cast_nullable_to_non_nullable
as Role,fallbackRole: null == fallbackRole ? _self.fallbackRole : fallbackRole // ignore: cast_nullable_to_non_nullable
as Role,emailNotificationsEnabled: null == emailNotificationsEnabled ? _self.emailNotificationsEnabled : emailNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,smsNotificationsEnabled: null == smsNotificationsEnabled ? _self.smsNotificationsEnabled : smsNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,billingAddress: freezed == billingAddress ? _self.billingAddress : billingAddress // ignore: cast_nullable_to_non_nullable
as ExampleAddressEntity?,
  ));
}
/// Create a copy of ExampleProfileSettingsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleAddressEntityCopyWith<$Res>? get billingAddress {
    if (_self.billingAddress == null) {
    return null;
  }

  return $ExampleAddressEntityCopyWith<$Res>(_self.billingAddress!, (value) {
    return _then(_self.copyWith(billingAddress: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExampleProfileSettingsEntity].
extension ExampleProfileSettingsEntityPatterns on ExampleProfileSettingsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExampleProfileSettingsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExampleProfileSettingsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExampleProfileSettingsEntity value)  $default,){
final _that = this;
switch (_that) {
case _ExampleProfileSettingsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExampleProfileSettingsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ExampleProfileSettingsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Role userRole,  Role fallbackRole,  bool emailNotificationsEnabled,  bool smsNotificationsEnabled,  ExampleAddressEntity? billingAddress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExampleProfileSettingsEntity() when $default != null:
return $default(_that.userRole,_that.fallbackRole,_that.emailNotificationsEnabled,_that.smsNotificationsEnabled,_that.billingAddress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Role userRole,  Role fallbackRole,  bool emailNotificationsEnabled,  bool smsNotificationsEnabled,  ExampleAddressEntity? billingAddress)  $default,) {final _that = this;
switch (_that) {
case _ExampleProfileSettingsEntity():
return $default(_that.userRole,_that.fallbackRole,_that.emailNotificationsEnabled,_that.smsNotificationsEnabled,_that.billingAddress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Role userRole,  Role fallbackRole,  bool emailNotificationsEnabled,  bool smsNotificationsEnabled,  ExampleAddressEntity? billingAddress)?  $default,) {final _that = this;
switch (_that) {
case _ExampleProfileSettingsEntity() when $default != null:
return $default(_that.userRole,_that.fallbackRole,_that.emailNotificationsEnabled,_that.smsNotificationsEnabled,_that.billingAddress);case _:
  return null;

}
}

}

/// @nodoc


class _ExampleProfileSettingsEntity extends ExampleProfileSettingsEntity {
  const _ExampleProfileSettingsEntity({required this.userRole, this.fallbackRole = Role.guest, this.emailNotificationsEnabled = true, this.smsNotificationsEnabled = false, this.billingAddress}): super._();
  

@override final  Role userRole;
@override@JsonKey() final  Role fallbackRole;
@override@JsonKey() final  bool emailNotificationsEnabled;
@override@JsonKey() final  bool smsNotificationsEnabled;
@override final  ExampleAddressEntity? billingAddress;

/// Create a copy of ExampleProfileSettingsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExampleProfileSettingsEntityCopyWith<_ExampleProfileSettingsEntity> get copyWith => __$ExampleProfileSettingsEntityCopyWithImpl<_ExampleProfileSettingsEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExampleProfileSettingsEntity&&(identical(other.userRole, userRole) || other.userRole == userRole)&&(identical(other.fallbackRole, fallbackRole) || other.fallbackRole == fallbackRole)&&(identical(other.emailNotificationsEnabled, emailNotificationsEnabled) || other.emailNotificationsEnabled == emailNotificationsEnabled)&&(identical(other.smsNotificationsEnabled, smsNotificationsEnabled) || other.smsNotificationsEnabled == smsNotificationsEnabled)&&(identical(other.billingAddress, billingAddress) || other.billingAddress == billingAddress));
}


@override
int get hashCode => Object.hash(runtimeType,userRole,fallbackRole,emailNotificationsEnabled,smsNotificationsEnabled,billingAddress);

@override
String toString() {
  return 'ExampleProfileSettingsEntity(userRole: $userRole, fallbackRole: $fallbackRole, emailNotificationsEnabled: $emailNotificationsEnabled, smsNotificationsEnabled: $smsNotificationsEnabled, billingAddress: $billingAddress)';
}


}

/// @nodoc
abstract mixin class _$ExampleProfileSettingsEntityCopyWith<$Res> implements $ExampleProfileSettingsEntityCopyWith<$Res> {
  factory _$ExampleProfileSettingsEntityCopyWith(_ExampleProfileSettingsEntity value, $Res Function(_ExampleProfileSettingsEntity) _then) = __$ExampleProfileSettingsEntityCopyWithImpl;
@override @useResult
$Res call({
 Role userRole, Role fallbackRole, bool emailNotificationsEnabled, bool smsNotificationsEnabled, ExampleAddressEntity? billingAddress
});


@override $ExampleAddressEntityCopyWith<$Res>? get billingAddress;

}
/// @nodoc
class __$ExampleProfileSettingsEntityCopyWithImpl<$Res>
    implements _$ExampleProfileSettingsEntityCopyWith<$Res> {
  __$ExampleProfileSettingsEntityCopyWithImpl(this._self, this._then);

  final _ExampleProfileSettingsEntity _self;
  final $Res Function(_ExampleProfileSettingsEntity) _then;

/// Create a copy of ExampleProfileSettingsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userRole = null,Object? fallbackRole = null,Object? emailNotificationsEnabled = null,Object? smsNotificationsEnabled = null,Object? billingAddress = freezed,}) {
  return _then(_ExampleProfileSettingsEntity(
userRole: null == userRole ? _self.userRole : userRole // ignore: cast_nullable_to_non_nullable
as Role,fallbackRole: null == fallbackRole ? _self.fallbackRole : fallbackRole // ignore: cast_nullable_to_non_nullable
as Role,emailNotificationsEnabled: null == emailNotificationsEnabled ? _self.emailNotificationsEnabled : emailNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,smsNotificationsEnabled: null == smsNotificationsEnabled ? _self.smsNotificationsEnabled : smsNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,billingAddress: freezed == billingAddress ? _self.billingAddress : billingAddress // ignore: cast_nullable_to_non_nullable
as ExampleAddressEntity?,
  ));
}

/// Create a copy of ExampleProfileSettingsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleAddressEntityCopyWith<$Res>? get billingAddress {
    if (_self.billingAddress == null) {
    return null;
  }

  return $ExampleAddressEntityCopyWith<$Res>(_self.billingAddress!, (value) {
    return _then(_self.copyWith(billingAddress: value));
  });
}
}

// dart format on
