// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example_request_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExampleRequestParams {

// --- required fields ---
 int get age; double get grade; List<String> get friends; Map<String, dynamic> get group; List<Map<String, dynamic>> get listedGroup;@AccountStatusConverter() AccountStatus get status;@ExampleSubEntityConverter() ExampleSubEntity get mainSubEntity;@ExampleAddressEntityConverter() ExampleAddressEntity get primaryAddress;@ExampleProfileSettingsEntityConverter() ExampleProfileSettingsEntity get settings;// --- optional fields ---
 String? get id; String? get emptyId; String? get defaultId; int? get emptyAge; int? get defaultAge; double? get emptyGrade; double? get defaultGrade; List<String>? get emptyFriends; List<String>? get defaultFriends; Map<String, dynamic>? get emptyGroup; Map<String, dynamic>? get defaultGroup; List<Map<String, dynamic>>? get emptyListedGroup; List<Map<String, dynamic>>? get defaultListedGroup;@AccountStatusConverter() AccountStatus get defaultStatus;@NullableExampleSubEntityConverter() ExampleSubEntity? get optionalSubEntity;@NullableExampleAddressEntityConverter() ExampleAddressEntity? get secondaryAddress;@ExampleAddressEntityConverter() List<ExampleAddressEntity> get pastAddresses;
/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExampleRequestParamsCopyWith<ExampleRequestParams> get copyWith => _$ExampleRequestParamsCopyWithImpl<ExampleRequestParams>(this as ExampleRequestParams, _$identity);

  /// Serializes this ExampleRequestParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExampleRequestParams&&(identical(other.age, age) || other.age == age)&&(identical(other.grade, grade) || other.grade == grade)&&const DeepCollectionEquality().equals(other.friends, friends)&&const DeepCollectionEquality().equals(other.group, group)&&const DeepCollectionEquality().equals(other.listedGroup, listedGroup)&&(identical(other.status, status) || other.status == status)&&(identical(other.mainSubEntity, mainSubEntity) || other.mainSubEntity == mainSubEntity)&&(identical(other.primaryAddress, primaryAddress) || other.primaryAddress == primaryAddress)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.id, id) || other.id == id)&&(identical(other.emptyId, emptyId) || other.emptyId == emptyId)&&(identical(other.defaultId, defaultId) || other.defaultId == defaultId)&&(identical(other.emptyAge, emptyAge) || other.emptyAge == emptyAge)&&(identical(other.defaultAge, defaultAge) || other.defaultAge == defaultAge)&&(identical(other.emptyGrade, emptyGrade) || other.emptyGrade == emptyGrade)&&(identical(other.defaultGrade, defaultGrade) || other.defaultGrade == defaultGrade)&&const DeepCollectionEquality().equals(other.emptyFriends, emptyFriends)&&const DeepCollectionEquality().equals(other.defaultFriends, defaultFriends)&&const DeepCollectionEquality().equals(other.emptyGroup, emptyGroup)&&const DeepCollectionEquality().equals(other.defaultGroup, defaultGroup)&&const DeepCollectionEquality().equals(other.emptyListedGroup, emptyListedGroup)&&const DeepCollectionEquality().equals(other.defaultListedGroup, defaultListedGroup)&&(identical(other.defaultStatus, defaultStatus) || other.defaultStatus == defaultStatus)&&(identical(other.optionalSubEntity, optionalSubEntity) || other.optionalSubEntity == optionalSubEntity)&&(identical(other.secondaryAddress, secondaryAddress) || other.secondaryAddress == secondaryAddress)&&const DeepCollectionEquality().equals(other.pastAddresses, pastAddresses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,age,grade,const DeepCollectionEquality().hash(friends),const DeepCollectionEquality().hash(group),const DeepCollectionEquality().hash(listedGroup),status,mainSubEntity,primaryAddress,settings,id,emptyId,defaultId,emptyAge,defaultAge,emptyGrade,defaultGrade,const DeepCollectionEquality().hash(emptyFriends),const DeepCollectionEquality().hash(defaultFriends),const DeepCollectionEquality().hash(emptyGroup),const DeepCollectionEquality().hash(defaultGroup),const DeepCollectionEquality().hash(emptyListedGroup),const DeepCollectionEquality().hash(defaultListedGroup),defaultStatus,optionalSubEntity,secondaryAddress,const DeepCollectionEquality().hash(pastAddresses)]);

@override
String toString() {
  return 'ExampleRequestParams(age: $age, grade: $grade, friends: $friends, group: $group, listedGroup: $listedGroup, status: $status, mainSubEntity: $mainSubEntity, primaryAddress: $primaryAddress, settings: $settings, id: $id, emptyId: $emptyId, defaultId: $defaultId, emptyAge: $emptyAge, defaultAge: $defaultAge, emptyGrade: $emptyGrade, defaultGrade: $defaultGrade, emptyFriends: $emptyFriends, defaultFriends: $defaultFriends, emptyGroup: $emptyGroup, defaultGroup: $defaultGroup, emptyListedGroup: $emptyListedGroup, defaultListedGroup: $defaultListedGroup, defaultStatus: $defaultStatus, optionalSubEntity: $optionalSubEntity, secondaryAddress: $secondaryAddress, pastAddresses: $pastAddresses)';
}


}

/// @nodoc
abstract mixin class $ExampleRequestParamsCopyWith<$Res>  {
  factory $ExampleRequestParamsCopyWith(ExampleRequestParams value, $Res Function(ExampleRequestParams) _then) = _$ExampleRequestParamsCopyWithImpl;
@useResult
$Res call({
 int age, double grade, List<String> friends, Map<String, dynamic> group, List<Map<String, dynamic>> listedGroup,@AccountStatusConverter() AccountStatus status,@ExampleSubEntityConverter() ExampleSubEntity mainSubEntity,@ExampleAddressEntityConverter() ExampleAddressEntity primaryAddress,@ExampleProfileSettingsEntityConverter() ExampleProfileSettingsEntity settings, String? id, String? emptyId, String? defaultId, int? emptyAge, int? defaultAge, double? emptyGrade, double? defaultGrade, List<String>? emptyFriends, List<String>? defaultFriends, Map<String, dynamic>? emptyGroup, Map<String, dynamic>? defaultGroup, List<Map<String, dynamic>>? emptyListedGroup, List<Map<String, dynamic>>? defaultListedGroup,@AccountStatusConverter() AccountStatus defaultStatus,@NullableExampleSubEntityConverter() ExampleSubEntity? optionalSubEntity,@NullableExampleAddressEntityConverter() ExampleAddressEntity? secondaryAddress,@ExampleAddressEntityConverter() List<ExampleAddressEntity> pastAddresses
});


$ExampleSubEntityCopyWith<$Res> get mainSubEntity;$ExampleAddressEntityCopyWith<$Res> get primaryAddress;$ExampleProfileSettingsEntityCopyWith<$Res> get settings;$ExampleSubEntityCopyWith<$Res>? get optionalSubEntity;$ExampleAddressEntityCopyWith<$Res>? get secondaryAddress;

}
/// @nodoc
class _$ExampleRequestParamsCopyWithImpl<$Res>
    implements $ExampleRequestParamsCopyWith<$Res> {
  _$ExampleRequestParamsCopyWithImpl(this._self, this._then);

  final ExampleRequestParams _self;
  final $Res Function(ExampleRequestParams) _then;

/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? age = null,Object? grade = null,Object? friends = null,Object? group = null,Object? listedGroup = null,Object? status = null,Object? mainSubEntity = null,Object? primaryAddress = null,Object? settings = null,Object? id = freezed,Object? emptyId = freezed,Object? defaultId = freezed,Object? emptyAge = freezed,Object? defaultAge = freezed,Object? emptyGrade = freezed,Object? defaultGrade = freezed,Object? emptyFriends = freezed,Object? defaultFriends = freezed,Object? emptyGroup = freezed,Object? defaultGroup = freezed,Object? emptyListedGroup = freezed,Object? defaultListedGroup = freezed,Object? defaultStatus = null,Object? optionalSubEntity = freezed,Object? secondaryAddress = freezed,Object? pastAddresses = null,}) {
  return _then(_self.copyWith(
age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as double,friends: null == friends ? _self.friends : friends // ignore: cast_nullable_to_non_nullable
as List<String>,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,listedGroup: null == listedGroup ? _self.listedGroup : listedGroup // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,mainSubEntity: null == mainSubEntity ? _self.mainSubEntity : mainSubEntity // ignore: cast_nullable_to_non_nullable
as ExampleSubEntity,primaryAddress: null == primaryAddress ? _self.primaryAddress : primaryAddress // ignore: cast_nullable_to_non_nullable
as ExampleAddressEntity,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as ExampleProfileSettingsEntity,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,emptyId: freezed == emptyId ? _self.emptyId : emptyId // ignore: cast_nullable_to_non_nullable
as String?,defaultId: freezed == defaultId ? _self.defaultId : defaultId // ignore: cast_nullable_to_non_nullable
as String?,emptyAge: freezed == emptyAge ? _self.emptyAge : emptyAge // ignore: cast_nullable_to_non_nullable
as int?,defaultAge: freezed == defaultAge ? _self.defaultAge : defaultAge // ignore: cast_nullable_to_non_nullable
as int?,emptyGrade: freezed == emptyGrade ? _self.emptyGrade : emptyGrade // ignore: cast_nullable_to_non_nullable
as double?,defaultGrade: freezed == defaultGrade ? _self.defaultGrade : defaultGrade // ignore: cast_nullable_to_non_nullable
as double?,emptyFriends: freezed == emptyFriends ? _self.emptyFriends : emptyFriends // ignore: cast_nullable_to_non_nullable
as List<String>?,defaultFriends: freezed == defaultFriends ? _self.defaultFriends : defaultFriends // ignore: cast_nullable_to_non_nullable
as List<String>?,emptyGroup: freezed == emptyGroup ? _self.emptyGroup : emptyGroup // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,defaultGroup: freezed == defaultGroup ? _self.defaultGroup : defaultGroup // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,emptyListedGroup: freezed == emptyListedGroup ? _self.emptyListedGroup : emptyListedGroup // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,defaultListedGroup: freezed == defaultListedGroup ? _self.defaultListedGroup : defaultListedGroup // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,defaultStatus: null == defaultStatus ? _self.defaultStatus : defaultStatus // ignore: cast_nullable_to_non_nullable
as AccountStatus,optionalSubEntity: freezed == optionalSubEntity ? _self.optionalSubEntity : optionalSubEntity // ignore: cast_nullable_to_non_nullable
as ExampleSubEntity?,secondaryAddress: freezed == secondaryAddress ? _self.secondaryAddress : secondaryAddress // ignore: cast_nullable_to_non_nullable
as ExampleAddressEntity?,pastAddresses: null == pastAddresses ? _self.pastAddresses : pastAddresses // ignore: cast_nullable_to_non_nullable
as List<ExampleAddressEntity>,
  ));
}
/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleSubEntityCopyWith<$Res> get mainSubEntity {
  
  return $ExampleSubEntityCopyWith<$Res>(_self.mainSubEntity, (value) {
    return _then(_self.copyWith(mainSubEntity: value));
  });
}/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleAddressEntityCopyWith<$Res> get primaryAddress {
  
  return $ExampleAddressEntityCopyWith<$Res>(_self.primaryAddress, (value) {
    return _then(_self.copyWith(primaryAddress: value));
  });
}/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleProfileSettingsEntityCopyWith<$Res> get settings {
  
  return $ExampleProfileSettingsEntityCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleSubEntityCopyWith<$Res>? get optionalSubEntity {
    if (_self.optionalSubEntity == null) {
    return null;
  }

  return $ExampleSubEntityCopyWith<$Res>(_self.optionalSubEntity!, (value) {
    return _then(_self.copyWith(optionalSubEntity: value));
  });
}/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleAddressEntityCopyWith<$Res>? get secondaryAddress {
    if (_self.secondaryAddress == null) {
    return null;
  }

  return $ExampleAddressEntityCopyWith<$Res>(_self.secondaryAddress!, (value) {
    return _then(_self.copyWith(secondaryAddress: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExampleRequestParams].
extension ExampleRequestParamsPatterns on ExampleRequestParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExampleRequestParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExampleRequestParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExampleRequestParams value)  $default,){
final _that = this;
switch (_that) {
case _ExampleRequestParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExampleRequestParams value)?  $default,){
final _that = this;
switch (_that) {
case _ExampleRequestParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int age,  double grade,  List<String> friends,  Map<String, dynamic> group,  List<Map<String, dynamic>> listedGroup, @AccountStatusConverter()  AccountStatus status, @ExampleSubEntityConverter()  ExampleSubEntity mainSubEntity, @ExampleAddressEntityConverter()  ExampleAddressEntity primaryAddress, @ExampleProfileSettingsEntityConverter()  ExampleProfileSettingsEntity settings,  String? id,  String? emptyId,  String? defaultId,  int? emptyAge,  int? defaultAge,  double? emptyGrade,  double? defaultGrade,  List<String>? emptyFriends,  List<String>? defaultFriends,  Map<String, dynamic>? emptyGroup,  Map<String, dynamic>? defaultGroup,  List<Map<String, dynamic>>? emptyListedGroup,  List<Map<String, dynamic>>? defaultListedGroup, @AccountStatusConverter()  AccountStatus defaultStatus, @NullableExampleSubEntityConverter()  ExampleSubEntity? optionalSubEntity, @NullableExampleAddressEntityConverter()  ExampleAddressEntity? secondaryAddress, @ExampleAddressEntityConverter()  List<ExampleAddressEntity> pastAddresses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExampleRequestParams() when $default != null:
return $default(_that.age,_that.grade,_that.friends,_that.group,_that.listedGroup,_that.status,_that.mainSubEntity,_that.primaryAddress,_that.settings,_that.id,_that.emptyId,_that.defaultId,_that.emptyAge,_that.defaultAge,_that.emptyGrade,_that.defaultGrade,_that.emptyFriends,_that.defaultFriends,_that.emptyGroup,_that.defaultGroup,_that.emptyListedGroup,_that.defaultListedGroup,_that.defaultStatus,_that.optionalSubEntity,_that.secondaryAddress,_that.pastAddresses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int age,  double grade,  List<String> friends,  Map<String, dynamic> group,  List<Map<String, dynamic>> listedGroup, @AccountStatusConverter()  AccountStatus status, @ExampleSubEntityConverter()  ExampleSubEntity mainSubEntity, @ExampleAddressEntityConverter()  ExampleAddressEntity primaryAddress, @ExampleProfileSettingsEntityConverter()  ExampleProfileSettingsEntity settings,  String? id,  String? emptyId,  String? defaultId,  int? emptyAge,  int? defaultAge,  double? emptyGrade,  double? defaultGrade,  List<String>? emptyFriends,  List<String>? defaultFriends,  Map<String, dynamic>? emptyGroup,  Map<String, dynamic>? defaultGroup,  List<Map<String, dynamic>>? emptyListedGroup,  List<Map<String, dynamic>>? defaultListedGroup, @AccountStatusConverter()  AccountStatus defaultStatus, @NullableExampleSubEntityConverter()  ExampleSubEntity? optionalSubEntity, @NullableExampleAddressEntityConverter()  ExampleAddressEntity? secondaryAddress, @ExampleAddressEntityConverter()  List<ExampleAddressEntity> pastAddresses)  $default,) {final _that = this;
switch (_that) {
case _ExampleRequestParams():
return $default(_that.age,_that.grade,_that.friends,_that.group,_that.listedGroup,_that.status,_that.mainSubEntity,_that.primaryAddress,_that.settings,_that.id,_that.emptyId,_that.defaultId,_that.emptyAge,_that.defaultAge,_that.emptyGrade,_that.defaultGrade,_that.emptyFriends,_that.defaultFriends,_that.emptyGroup,_that.defaultGroup,_that.emptyListedGroup,_that.defaultListedGroup,_that.defaultStatus,_that.optionalSubEntity,_that.secondaryAddress,_that.pastAddresses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int age,  double grade,  List<String> friends,  Map<String, dynamic> group,  List<Map<String, dynamic>> listedGroup, @AccountStatusConverter()  AccountStatus status, @ExampleSubEntityConverter()  ExampleSubEntity mainSubEntity, @ExampleAddressEntityConverter()  ExampleAddressEntity primaryAddress, @ExampleProfileSettingsEntityConverter()  ExampleProfileSettingsEntity settings,  String? id,  String? emptyId,  String? defaultId,  int? emptyAge,  int? defaultAge,  double? emptyGrade,  double? defaultGrade,  List<String>? emptyFriends,  List<String>? defaultFriends,  Map<String, dynamic>? emptyGroup,  Map<String, dynamic>? defaultGroup,  List<Map<String, dynamic>>? emptyListedGroup,  List<Map<String, dynamic>>? defaultListedGroup, @AccountStatusConverter()  AccountStatus defaultStatus, @NullableExampleSubEntityConverter()  ExampleSubEntity? optionalSubEntity, @NullableExampleAddressEntityConverter()  ExampleAddressEntity? secondaryAddress, @ExampleAddressEntityConverter()  List<ExampleAddressEntity> pastAddresses)?  $default,) {final _that = this;
switch (_that) {
case _ExampleRequestParams() when $default != null:
return $default(_that.age,_that.grade,_that.friends,_that.group,_that.listedGroup,_that.status,_that.mainSubEntity,_that.primaryAddress,_that.settings,_that.id,_that.emptyId,_that.defaultId,_that.emptyAge,_that.defaultAge,_that.emptyGrade,_that.defaultGrade,_that.emptyFriends,_that.defaultFriends,_that.emptyGroup,_that.defaultGroup,_that.emptyListedGroup,_that.defaultListedGroup,_that.defaultStatus,_that.optionalSubEntity,_that.secondaryAddress,_that.pastAddresses);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _ExampleRequestParams extends ExampleRequestParams {
  const _ExampleRequestParams({required this.age, required this.grade, required final  List<String> friends, required final  Map<String, dynamic> group, required final  List<Map<String, dynamic>> listedGroup, @AccountStatusConverter() required this.status, @ExampleSubEntityConverter() required this.mainSubEntity, @ExampleAddressEntityConverter() required this.primaryAddress, @ExampleProfileSettingsEntityConverter() required this.settings, this.id, this.emptyId, this.defaultId = 'id', this.emptyAge, this.defaultAge = 18, this.emptyGrade, this.defaultGrade = 99.6, final  List<String>? emptyFriends, final  List<String>? defaultFriends = const ['a', 'b', 'c'], final  Map<String, dynamic>? emptyGroup, final  Map<String, dynamic>? defaultGroup = const {'a' : 1, 'b' : 2, 'c' : 3}, final  List<Map<String, dynamic>>? emptyListedGroup, final  List<Map<String, dynamic>>? defaultListedGroup = const [{'a' : 1, 'b' : 2, 'c' : 3}, {'d' : 4, 'e' : 5, 'f' : 6}], @AccountStatusConverter() this.defaultStatus = AccountStatus.pending, @NullableExampleSubEntityConverter() this.optionalSubEntity, @NullableExampleAddressEntityConverter() this.secondaryAddress, @ExampleAddressEntityConverter() final  List<ExampleAddressEntity> pastAddresses = const []}): _friends = friends,_group = group,_listedGroup = listedGroup,_emptyFriends = emptyFriends,_defaultFriends = defaultFriends,_emptyGroup = emptyGroup,_defaultGroup = defaultGroup,_emptyListedGroup = emptyListedGroup,_defaultListedGroup = defaultListedGroup,_pastAddresses = pastAddresses,super._();
  factory _ExampleRequestParams.fromJson(Map<String, dynamic> json) => _$ExampleRequestParamsFromJson(json);

// --- required fields ---
@override final  int age;
@override final  double grade;
 final  List<String> _friends;
@override List<String> get friends {
  if (_friends is EqualUnmodifiableListView) return _friends;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_friends);
}

 final  Map<String, dynamic> _group;
@override Map<String, dynamic> get group {
  if (_group is EqualUnmodifiableMapView) return _group;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_group);
}

 final  List<Map<String, dynamic>> _listedGroup;
@override List<Map<String, dynamic>> get listedGroup {
  if (_listedGroup is EqualUnmodifiableListView) return _listedGroup;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_listedGroup);
}

@override@AccountStatusConverter() final  AccountStatus status;
@override@ExampleSubEntityConverter() final  ExampleSubEntity mainSubEntity;
@override@ExampleAddressEntityConverter() final  ExampleAddressEntity primaryAddress;
@override@ExampleProfileSettingsEntityConverter() final  ExampleProfileSettingsEntity settings;
// --- optional fields ---
@override final  String? id;
@override final  String? emptyId;
@override@JsonKey() final  String? defaultId;
@override final  int? emptyAge;
@override@JsonKey() final  int? defaultAge;
@override final  double? emptyGrade;
@override@JsonKey() final  double? defaultGrade;
 final  List<String>? _emptyFriends;
@override List<String>? get emptyFriends {
  final value = _emptyFriends;
  if (value == null) return null;
  if (_emptyFriends is EqualUnmodifiableListView) return _emptyFriends;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _defaultFriends;
@override@JsonKey() List<String>? get defaultFriends {
  final value = _defaultFriends;
  if (value == null) return null;
  if (_defaultFriends is EqualUnmodifiableListView) return _defaultFriends;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, dynamic>? _emptyGroup;
@override Map<String, dynamic>? get emptyGroup {
  final value = _emptyGroup;
  if (value == null) return null;
  if (_emptyGroup is EqualUnmodifiableMapView) return _emptyGroup;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _defaultGroup;
@override@JsonKey() Map<String, dynamic>? get defaultGroup {
  final value = _defaultGroup;
  if (value == null) return null;
  if (_defaultGroup is EqualUnmodifiableMapView) return _defaultGroup;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<Map<String, dynamic>>? _emptyListedGroup;
@override List<Map<String, dynamic>>? get emptyListedGroup {
  final value = _emptyListedGroup;
  if (value == null) return null;
  if (_emptyListedGroup is EqualUnmodifiableListView) return _emptyListedGroup;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Map<String, dynamic>>? _defaultListedGroup;
@override@JsonKey() List<Map<String, dynamic>>? get defaultListedGroup {
  final value = _defaultListedGroup;
  if (value == null) return null;
  if (_defaultListedGroup is EqualUnmodifiableListView) return _defaultListedGroup;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey()@AccountStatusConverter() final  AccountStatus defaultStatus;
@override@NullableExampleSubEntityConverter() final  ExampleSubEntity? optionalSubEntity;
@override@NullableExampleAddressEntityConverter() final  ExampleAddressEntity? secondaryAddress;
 final  List<ExampleAddressEntity> _pastAddresses;
@override@JsonKey()@ExampleAddressEntityConverter() List<ExampleAddressEntity> get pastAddresses {
  if (_pastAddresses is EqualUnmodifiableListView) return _pastAddresses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pastAddresses);
}


/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExampleRequestParamsCopyWith<_ExampleRequestParams> get copyWith => __$ExampleRequestParamsCopyWithImpl<_ExampleRequestParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExampleRequestParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExampleRequestParams&&(identical(other.age, age) || other.age == age)&&(identical(other.grade, grade) || other.grade == grade)&&const DeepCollectionEquality().equals(other._friends, _friends)&&const DeepCollectionEquality().equals(other._group, _group)&&const DeepCollectionEquality().equals(other._listedGroup, _listedGroup)&&(identical(other.status, status) || other.status == status)&&(identical(other.mainSubEntity, mainSubEntity) || other.mainSubEntity == mainSubEntity)&&(identical(other.primaryAddress, primaryAddress) || other.primaryAddress == primaryAddress)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.id, id) || other.id == id)&&(identical(other.emptyId, emptyId) || other.emptyId == emptyId)&&(identical(other.defaultId, defaultId) || other.defaultId == defaultId)&&(identical(other.emptyAge, emptyAge) || other.emptyAge == emptyAge)&&(identical(other.defaultAge, defaultAge) || other.defaultAge == defaultAge)&&(identical(other.emptyGrade, emptyGrade) || other.emptyGrade == emptyGrade)&&(identical(other.defaultGrade, defaultGrade) || other.defaultGrade == defaultGrade)&&const DeepCollectionEquality().equals(other._emptyFriends, _emptyFriends)&&const DeepCollectionEquality().equals(other._defaultFriends, _defaultFriends)&&const DeepCollectionEquality().equals(other._emptyGroup, _emptyGroup)&&const DeepCollectionEquality().equals(other._defaultGroup, _defaultGroup)&&const DeepCollectionEquality().equals(other._emptyListedGroup, _emptyListedGroup)&&const DeepCollectionEquality().equals(other._defaultListedGroup, _defaultListedGroup)&&(identical(other.defaultStatus, defaultStatus) || other.defaultStatus == defaultStatus)&&(identical(other.optionalSubEntity, optionalSubEntity) || other.optionalSubEntity == optionalSubEntity)&&(identical(other.secondaryAddress, secondaryAddress) || other.secondaryAddress == secondaryAddress)&&const DeepCollectionEquality().equals(other._pastAddresses, _pastAddresses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,age,grade,const DeepCollectionEquality().hash(_friends),const DeepCollectionEquality().hash(_group),const DeepCollectionEquality().hash(_listedGroup),status,mainSubEntity,primaryAddress,settings,id,emptyId,defaultId,emptyAge,defaultAge,emptyGrade,defaultGrade,const DeepCollectionEquality().hash(_emptyFriends),const DeepCollectionEquality().hash(_defaultFriends),const DeepCollectionEquality().hash(_emptyGroup),const DeepCollectionEquality().hash(_defaultGroup),const DeepCollectionEquality().hash(_emptyListedGroup),const DeepCollectionEquality().hash(_defaultListedGroup),defaultStatus,optionalSubEntity,secondaryAddress,const DeepCollectionEquality().hash(_pastAddresses)]);

@override
String toString() {
  return 'ExampleRequestParams(age: $age, grade: $grade, friends: $friends, group: $group, listedGroup: $listedGroup, status: $status, mainSubEntity: $mainSubEntity, primaryAddress: $primaryAddress, settings: $settings, id: $id, emptyId: $emptyId, defaultId: $defaultId, emptyAge: $emptyAge, defaultAge: $defaultAge, emptyGrade: $emptyGrade, defaultGrade: $defaultGrade, emptyFriends: $emptyFriends, defaultFriends: $defaultFriends, emptyGroup: $emptyGroup, defaultGroup: $defaultGroup, emptyListedGroup: $emptyListedGroup, defaultListedGroup: $defaultListedGroup, defaultStatus: $defaultStatus, optionalSubEntity: $optionalSubEntity, secondaryAddress: $secondaryAddress, pastAddresses: $pastAddresses)';
}


}

/// @nodoc
abstract mixin class _$ExampleRequestParamsCopyWith<$Res> implements $ExampleRequestParamsCopyWith<$Res> {
  factory _$ExampleRequestParamsCopyWith(_ExampleRequestParams value, $Res Function(_ExampleRequestParams) _then) = __$ExampleRequestParamsCopyWithImpl;
@override @useResult
$Res call({
 int age, double grade, List<String> friends, Map<String, dynamic> group, List<Map<String, dynamic>> listedGroup,@AccountStatusConverter() AccountStatus status,@ExampleSubEntityConverter() ExampleSubEntity mainSubEntity,@ExampleAddressEntityConverter() ExampleAddressEntity primaryAddress,@ExampleProfileSettingsEntityConverter() ExampleProfileSettingsEntity settings, String? id, String? emptyId, String? defaultId, int? emptyAge, int? defaultAge, double? emptyGrade, double? defaultGrade, List<String>? emptyFriends, List<String>? defaultFriends, Map<String, dynamic>? emptyGroup, Map<String, dynamic>? defaultGroup, List<Map<String, dynamic>>? emptyListedGroup, List<Map<String, dynamic>>? defaultListedGroup,@AccountStatusConverter() AccountStatus defaultStatus,@NullableExampleSubEntityConverter() ExampleSubEntity? optionalSubEntity,@NullableExampleAddressEntityConverter() ExampleAddressEntity? secondaryAddress,@ExampleAddressEntityConverter() List<ExampleAddressEntity> pastAddresses
});


@override $ExampleSubEntityCopyWith<$Res> get mainSubEntity;@override $ExampleAddressEntityCopyWith<$Res> get primaryAddress;@override $ExampleProfileSettingsEntityCopyWith<$Res> get settings;@override $ExampleSubEntityCopyWith<$Res>? get optionalSubEntity;@override $ExampleAddressEntityCopyWith<$Res>? get secondaryAddress;

}
/// @nodoc
class __$ExampleRequestParamsCopyWithImpl<$Res>
    implements _$ExampleRequestParamsCopyWith<$Res> {
  __$ExampleRequestParamsCopyWithImpl(this._self, this._then);

  final _ExampleRequestParams _self;
  final $Res Function(_ExampleRequestParams) _then;

/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? age = null,Object? grade = null,Object? friends = null,Object? group = null,Object? listedGroup = null,Object? status = null,Object? mainSubEntity = null,Object? primaryAddress = null,Object? settings = null,Object? id = freezed,Object? emptyId = freezed,Object? defaultId = freezed,Object? emptyAge = freezed,Object? defaultAge = freezed,Object? emptyGrade = freezed,Object? defaultGrade = freezed,Object? emptyFriends = freezed,Object? defaultFriends = freezed,Object? emptyGroup = freezed,Object? defaultGroup = freezed,Object? emptyListedGroup = freezed,Object? defaultListedGroup = freezed,Object? defaultStatus = null,Object? optionalSubEntity = freezed,Object? secondaryAddress = freezed,Object? pastAddresses = null,}) {
  return _then(_ExampleRequestParams(
age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as double,friends: null == friends ? _self._friends : friends // ignore: cast_nullable_to_non_nullable
as List<String>,group: null == group ? _self._group : group // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,listedGroup: null == listedGroup ? _self._listedGroup : listedGroup // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,mainSubEntity: null == mainSubEntity ? _self.mainSubEntity : mainSubEntity // ignore: cast_nullable_to_non_nullable
as ExampleSubEntity,primaryAddress: null == primaryAddress ? _self.primaryAddress : primaryAddress // ignore: cast_nullable_to_non_nullable
as ExampleAddressEntity,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as ExampleProfileSettingsEntity,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,emptyId: freezed == emptyId ? _self.emptyId : emptyId // ignore: cast_nullable_to_non_nullable
as String?,defaultId: freezed == defaultId ? _self.defaultId : defaultId // ignore: cast_nullable_to_non_nullable
as String?,emptyAge: freezed == emptyAge ? _self.emptyAge : emptyAge // ignore: cast_nullable_to_non_nullable
as int?,defaultAge: freezed == defaultAge ? _self.defaultAge : defaultAge // ignore: cast_nullable_to_non_nullable
as int?,emptyGrade: freezed == emptyGrade ? _self.emptyGrade : emptyGrade // ignore: cast_nullable_to_non_nullable
as double?,defaultGrade: freezed == defaultGrade ? _self.defaultGrade : defaultGrade // ignore: cast_nullable_to_non_nullable
as double?,emptyFriends: freezed == emptyFriends ? _self._emptyFriends : emptyFriends // ignore: cast_nullable_to_non_nullable
as List<String>?,defaultFriends: freezed == defaultFriends ? _self._defaultFriends : defaultFriends // ignore: cast_nullable_to_non_nullable
as List<String>?,emptyGroup: freezed == emptyGroup ? _self._emptyGroup : emptyGroup // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,defaultGroup: freezed == defaultGroup ? _self._defaultGroup : defaultGroup // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,emptyListedGroup: freezed == emptyListedGroup ? _self._emptyListedGroup : emptyListedGroup // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,defaultListedGroup: freezed == defaultListedGroup ? _self._defaultListedGroup : defaultListedGroup // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,defaultStatus: null == defaultStatus ? _self.defaultStatus : defaultStatus // ignore: cast_nullable_to_non_nullable
as AccountStatus,optionalSubEntity: freezed == optionalSubEntity ? _self.optionalSubEntity : optionalSubEntity // ignore: cast_nullable_to_non_nullable
as ExampleSubEntity?,secondaryAddress: freezed == secondaryAddress ? _self.secondaryAddress : secondaryAddress // ignore: cast_nullable_to_non_nullable
as ExampleAddressEntity?,pastAddresses: null == pastAddresses ? _self._pastAddresses : pastAddresses // ignore: cast_nullable_to_non_nullable
as List<ExampleAddressEntity>,
  ));
}

/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleSubEntityCopyWith<$Res> get mainSubEntity {
  
  return $ExampleSubEntityCopyWith<$Res>(_self.mainSubEntity, (value) {
    return _then(_self.copyWith(mainSubEntity: value));
  });
}/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleAddressEntityCopyWith<$Res> get primaryAddress {
  
  return $ExampleAddressEntityCopyWith<$Res>(_self.primaryAddress, (value) {
    return _then(_self.copyWith(primaryAddress: value));
  });
}/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleProfileSettingsEntityCopyWith<$Res> get settings {
  
  return $ExampleProfileSettingsEntityCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleSubEntityCopyWith<$Res>? get optionalSubEntity {
    if (_self.optionalSubEntity == null) {
    return null;
  }

  return $ExampleSubEntityCopyWith<$Res>(_self.optionalSubEntity!, (value) {
    return _then(_self.copyWith(optionalSubEntity: value));
  });
}/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleAddressEntityCopyWith<$Res>? get secondaryAddress {
    if (_self.secondaryAddress == null) {
    return null;
  }

  return $ExampleAddressEntityCopyWith<$Res>(_self.secondaryAddress!, (value) {
    return _then(_self.copyWith(secondaryAddress: value));
  });
}
}

// dart format on
