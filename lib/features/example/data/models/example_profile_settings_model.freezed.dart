// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example_profile_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExampleProfileSettingsModel {

@RoleConverter() Role get userRole;@RoleConverter() Role get fallbackRole; bool get emailNotificationsEnabled; bool get smsNotificationsEnabled; ExampleAddressModel? get billingAddress;
/// Create a copy of ExampleProfileSettingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExampleProfileSettingsModelCopyWith<ExampleProfileSettingsModel> get copyWith => _$ExampleProfileSettingsModelCopyWithImpl<ExampleProfileSettingsModel>(this as ExampleProfileSettingsModel, _$identity);

  /// Serializes this ExampleProfileSettingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExampleProfileSettingsModel&&(identical(other.userRole, userRole) || other.userRole == userRole)&&(identical(other.fallbackRole, fallbackRole) || other.fallbackRole == fallbackRole)&&(identical(other.emailNotificationsEnabled, emailNotificationsEnabled) || other.emailNotificationsEnabled == emailNotificationsEnabled)&&(identical(other.smsNotificationsEnabled, smsNotificationsEnabled) || other.smsNotificationsEnabled == smsNotificationsEnabled)&&(identical(other.billingAddress, billingAddress) || other.billingAddress == billingAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userRole,fallbackRole,emailNotificationsEnabled,smsNotificationsEnabled,billingAddress);

@override
String toString() {
  return 'ExampleProfileSettingsModel(userRole: $userRole, fallbackRole: $fallbackRole, emailNotificationsEnabled: $emailNotificationsEnabled, smsNotificationsEnabled: $smsNotificationsEnabled, billingAddress: $billingAddress)';
}


}

/// @nodoc
abstract mixin class $ExampleProfileSettingsModelCopyWith<$Res>  {
  factory $ExampleProfileSettingsModelCopyWith(ExampleProfileSettingsModel value, $Res Function(ExampleProfileSettingsModel) _then) = _$ExampleProfileSettingsModelCopyWithImpl;
@useResult
$Res call({
@RoleConverter() Role userRole,@RoleConverter() Role fallbackRole, bool emailNotificationsEnabled, bool smsNotificationsEnabled, ExampleAddressModel? billingAddress
});


$ExampleAddressModelCopyWith<$Res>? get billingAddress;

}
/// @nodoc
class _$ExampleProfileSettingsModelCopyWithImpl<$Res>
    implements $ExampleProfileSettingsModelCopyWith<$Res> {
  _$ExampleProfileSettingsModelCopyWithImpl(this._self, this._then);

  final ExampleProfileSettingsModel _self;
  final $Res Function(ExampleProfileSettingsModel) _then;

/// Create a copy of ExampleProfileSettingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userRole = null,Object? fallbackRole = null,Object? emailNotificationsEnabled = null,Object? smsNotificationsEnabled = null,Object? billingAddress = freezed,}) {
  return _then(_self.copyWith(
userRole: null == userRole ? _self.userRole : userRole // ignore: cast_nullable_to_non_nullable
as Role,fallbackRole: null == fallbackRole ? _self.fallbackRole : fallbackRole // ignore: cast_nullable_to_non_nullable
as Role,emailNotificationsEnabled: null == emailNotificationsEnabled ? _self.emailNotificationsEnabled : emailNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,smsNotificationsEnabled: null == smsNotificationsEnabled ? _self.smsNotificationsEnabled : smsNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,billingAddress: freezed == billingAddress ? _self.billingAddress : billingAddress // ignore: cast_nullable_to_non_nullable
as ExampleAddressModel?,
  ));
}
/// Create a copy of ExampleProfileSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleAddressModelCopyWith<$Res>? get billingAddress {
    if (_self.billingAddress == null) {
    return null;
  }

  return $ExampleAddressModelCopyWith<$Res>(_self.billingAddress!, (value) {
    return _then(_self.copyWith(billingAddress: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExampleProfileSettingsModel].
extension ExampleProfileSettingsModelPatterns on ExampleProfileSettingsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExampleProfileSettingsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExampleProfileSettingsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExampleProfileSettingsModel value)  $default,){
final _that = this;
switch (_that) {
case _ExampleProfileSettingsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExampleProfileSettingsModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExampleProfileSettingsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@RoleConverter()  Role userRole, @RoleConverter()  Role fallbackRole,  bool emailNotificationsEnabled,  bool smsNotificationsEnabled,  ExampleAddressModel? billingAddress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExampleProfileSettingsModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@RoleConverter()  Role userRole, @RoleConverter()  Role fallbackRole,  bool emailNotificationsEnabled,  bool smsNotificationsEnabled,  ExampleAddressModel? billingAddress)  $default,) {final _that = this;
switch (_that) {
case _ExampleProfileSettingsModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@RoleConverter()  Role userRole, @RoleConverter()  Role fallbackRole,  bool emailNotificationsEnabled,  bool smsNotificationsEnabled,  ExampleAddressModel? billingAddress)?  $default,) {final _that = this;
switch (_that) {
case _ExampleProfileSettingsModel() when $default != null:
return $default(_that.userRole,_that.fallbackRole,_that.emailNotificationsEnabled,_that.smsNotificationsEnabled,_that.billingAddress);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class _ExampleProfileSettingsModel extends ExampleProfileSettingsModel {
  const _ExampleProfileSettingsModel({@RoleConverter() required this.userRole, @RoleConverter() this.fallbackRole = Role.guest, this.emailNotificationsEnabled = true, this.smsNotificationsEnabled = false, this.billingAddress}): super._();
  factory _ExampleProfileSettingsModel.fromJson(Map<String, dynamic> json) => _$ExampleProfileSettingsModelFromJson(json);

@override@RoleConverter() final  Role userRole;
@override@JsonKey()@RoleConverter() final  Role fallbackRole;
@override@JsonKey() final  bool emailNotificationsEnabled;
@override@JsonKey() final  bool smsNotificationsEnabled;
@override final  ExampleAddressModel? billingAddress;

/// Create a copy of ExampleProfileSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExampleProfileSettingsModelCopyWith<_ExampleProfileSettingsModel> get copyWith => __$ExampleProfileSettingsModelCopyWithImpl<_ExampleProfileSettingsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExampleProfileSettingsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExampleProfileSettingsModel&&(identical(other.userRole, userRole) || other.userRole == userRole)&&(identical(other.fallbackRole, fallbackRole) || other.fallbackRole == fallbackRole)&&(identical(other.emailNotificationsEnabled, emailNotificationsEnabled) || other.emailNotificationsEnabled == emailNotificationsEnabled)&&(identical(other.smsNotificationsEnabled, smsNotificationsEnabled) || other.smsNotificationsEnabled == smsNotificationsEnabled)&&(identical(other.billingAddress, billingAddress) || other.billingAddress == billingAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userRole,fallbackRole,emailNotificationsEnabled,smsNotificationsEnabled,billingAddress);

@override
String toString() {
  return 'ExampleProfileSettingsModel(userRole: $userRole, fallbackRole: $fallbackRole, emailNotificationsEnabled: $emailNotificationsEnabled, smsNotificationsEnabled: $smsNotificationsEnabled, billingAddress: $billingAddress)';
}


}

/// @nodoc
abstract mixin class _$ExampleProfileSettingsModelCopyWith<$Res> implements $ExampleProfileSettingsModelCopyWith<$Res> {
  factory _$ExampleProfileSettingsModelCopyWith(_ExampleProfileSettingsModel value, $Res Function(_ExampleProfileSettingsModel) _then) = __$ExampleProfileSettingsModelCopyWithImpl;
@override @useResult
$Res call({
@RoleConverter() Role userRole,@RoleConverter() Role fallbackRole, bool emailNotificationsEnabled, bool smsNotificationsEnabled, ExampleAddressModel? billingAddress
});


@override $ExampleAddressModelCopyWith<$Res>? get billingAddress;

}
/// @nodoc
class __$ExampleProfileSettingsModelCopyWithImpl<$Res>
    implements _$ExampleProfileSettingsModelCopyWith<$Res> {
  __$ExampleProfileSettingsModelCopyWithImpl(this._self, this._then);

  final _ExampleProfileSettingsModel _self;
  final $Res Function(_ExampleProfileSettingsModel) _then;

/// Create a copy of ExampleProfileSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userRole = null,Object? fallbackRole = null,Object? emailNotificationsEnabled = null,Object? smsNotificationsEnabled = null,Object? billingAddress = freezed,}) {
  return _then(_ExampleProfileSettingsModel(
userRole: null == userRole ? _self.userRole : userRole // ignore: cast_nullable_to_non_nullable
as Role,fallbackRole: null == fallbackRole ? _self.fallbackRole : fallbackRole // ignore: cast_nullable_to_non_nullable
as Role,emailNotificationsEnabled: null == emailNotificationsEnabled ? _self.emailNotificationsEnabled : emailNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,smsNotificationsEnabled: null == smsNotificationsEnabled ? _self.smsNotificationsEnabled : smsNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,billingAddress: freezed == billingAddress ? _self.billingAddress : billingAddress // ignore: cast_nullable_to_non_nullable
as ExampleAddressModel?,
  ));
}

/// Create a copy of ExampleProfileSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleAddressModelCopyWith<$Res>? get billingAddress {
    if (_self.billingAddress == null) {
    return null;
  }

  return $ExampleAddressModelCopyWith<$Res>(_self.billingAddress!, (value) {
    return _then(_self.copyWith(billingAddress: value));
  });
}
}

// dart format on
