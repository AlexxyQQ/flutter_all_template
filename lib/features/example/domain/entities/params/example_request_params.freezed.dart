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

 String? get id; String? get emptyId; String? get defaultId; int get age; int? get emptyAge; int? get defaultAge; double get grade; double? get emptyGrade; double? get defaultGrade; List<String> get friends; List<String>? get emptyFriends; List<String>? get defaultFriends; Map<String, dynamic> get group; Map<String, dynamic>? get emptyGroup; Map<String, dynamic>? get defaultGroup; List<Map<String, dynamic>> get listedGroup; List<Map<String, dynamic>>? get emptyListedGroup; List<Map<String, dynamic>>? get defaultListedGroup;@AccountStatusConverter() AccountStatus get status;@AccountStatusConverter() AccountStatus? get defaultStatus; ExampleSubModel get mainSubEntity; ExampleSubModel? get optionalSubEntity; ExampleAddressModel get primaryAddress; ExampleAddressModel? get secondaryAddress; ExampleProfileSettingsModel get settings; List<ExampleAddressModel>? get pastAddresses;
/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExampleRequestParamsCopyWith<ExampleRequestParams> get copyWith => _$ExampleRequestParamsCopyWithImpl<ExampleRequestParams>(this as ExampleRequestParams, _$identity);

  /// Serializes this ExampleRequestParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExampleRequestParams&&(identical(other.id, id) || other.id == id)&&(identical(other.emptyId, emptyId) || other.emptyId == emptyId)&&(identical(other.defaultId, defaultId) || other.defaultId == defaultId)&&(identical(other.age, age) || other.age == age)&&(identical(other.emptyAge, emptyAge) || other.emptyAge == emptyAge)&&(identical(other.defaultAge, defaultAge) || other.defaultAge == defaultAge)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.emptyGrade, emptyGrade) || other.emptyGrade == emptyGrade)&&(identical(other.defaultGrade, defaultGrade) || other.defaultGrade == defaultGrade)&&const DeepCollectionEquality().equals(other.friends, friends)&&const DeepCollectionEquality().equals(other.emptyFriends, emptyFriends)&&const DeepCollectionEquality().equals(other.defaultFriends, defaultFriends)&&const DeepCollectionEquality().equals(other.group, group)&&const DeepCollectionEquality().equals(other.emptyGroup, emptyGroup)&&const DeepCollectionEquality().equals(other.defaultGroup, defaultGroup)&&const DeepCollectionEquality().equals(other.listedGroup, listedGroup)&&const DeepCollectionEquality().equals(other.emptyListedGroup, emptyListedGroup)&&const DeepCollectionEquality().equals(other.defaultListedGroup, defaultListedGroup)&&(identical(other.status, status) || other.status == status)&&(identical(other.defaultStatus, defaultStatus) || other.defaultStatus == defaultStatus)&&(identical(other.mainSubEntity, mainSubEntity) || other.mainSubEntity == mainSubEntity)&&(identical(other.optionalSubEntity, optionalSubEntity) || other.optionalSubEntity == optionalSubEntity)&&(identical(other.primaryAddress, primaryAddress) || other.primaryAddress == primaryAddress)&&(identical(other.secondaryAddress, secondaryAddress) || other.secondaryAddress == secondaryAddress)&&(identical(other.settings, settings) || other.settings == settings)&&const DeepCollectionEquality().equals(other.pastAddresses, pastAddresses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,emptyId,defaultId,age,emptyAge,defaultAge,grade,emptyGrade,defaultGrade,const DeepCollectionEquality().hash(friends),const DeepCollectionEquality().hash(emptyFriends),const DeepCollectionEquality().hash(defaultFriends),const DeepCollectionEquality().hash(group),const DeepCollectionEquality().hash(emptyGroup),const DeepCollectionEquality().hash(defaultGroup),const DeepCollectionEquality().hash(listedGroup),const DeepCollectionEquality().hash(emptyListedGroup),const DeepCollectionEquality().hash(defaultListedGroup),status,defaultStatus,mainSubEntity,optionalSubEntity,primaryAddress,secondaryAddress,settings,const DeepCollectionEquality().hash(pastAddresses)]);

@override
String toString() {
  return 'ExampleRequestParams(id: $id, emptyId: $emptyId, defaultId: $defaultId, age: $age, emptyAge: $emptyAge, defaultAge: $defaultAge, grade: $grade, emptyGrade: $emptyGrade, defaultGrade: $defaultGrade, friends: $friends, emptyFriends: $emptyFriends, defaultFriends: $defaultFriends, group: $group, emptyGroup: $emptyGroup, defaultGroup: $defaultGroup, listedGroup: $listedGroup, emptyListedGroup: $emptyListedGroup, defaultListedGroup: $defaultListedGroup, status: $status, defaultStatus: $defaultStatus, mainSubEntity: $mainSubEntity, optionalSubEntity: $optionalSubEntity, primaryAddress: $primaryAddress, secondaryAddress: $secondaryAddress, settings: $settings, pastAddresses: $pastAddresses)';
}


}

/// @nodoc
abstract mixin class $ExampleRequestParamsCopyWith<$Res>  {
  factory $ExampleRequestParamsCopyWith(ExampleRequestParams value, $Res Function(ExampleRequestParams) _then) = _$ExampleRequestParamsCopyWithImpl;
@useResult
$Res call({
 String? id, String? emptyId, String? defaultId, int age, int? emptyAge, int? defaultAge, double grade, double? emptyGrade, double? defaultGrade, List<String> friends, List<String>? emptyFriends, List<String>? defaultFriends, Map<String, dynamic> group, Map<String, dynamic>? emptyGroup, Map<String, dynamic>? defaultGroup, List<Map<String, dynamic>> listedGroup, List<Map<String, dynamic>>? emptyListedGroup, List<Map<String, dynamic>>? defaultListedGroup,@AccountStatusConverter() AccountStatus status,@AccountStatusConverter() AccountStatus? defaultStatus, ExampleSubModel mainSubEntity, ExampleSubModel? optionalSubEntity, ExampleAddressModel primaryAddress, ExampleAddressModel? secondaryAddress, ExampleProfileSettingsModel settings, List<ExampleAddressModel>? pastAddresses
});


$ExampleSubModelCopyWith<$Res> get mainSubEntity;$ExampleSubModelCopyWith<$Res>? get optionalSubEntity;$ExampleAddressModelCopyWith<$Res> get primaryAddress;$ExampleAddressModelCopyWith<$Res>? get secondaryAddress;$ExampleProfileSettingsModelCopyWith<$Res> get settings;

}
/// @nodoc
class _$ExampleRequestParamsCopyWithImpl<$Res>
    implements $ExampleRequestParamsCopyWith<$Res> {
  _$ExampleRequestParamsCopyWithImpl(this._self, this._then);

  final ExampleRequestParams _self;
  final $Res Function(ExampleRequestParams) _then;

/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? emptyId = freezed,Object? defaultId = freezed,Object? age = null,Object? emptyAge = freezed,Object? defaultAge = freezed,Object? grade = null,Object? emptyGrade = freezed,Object? defaultGrade = freezed,Object? friends = null,Object? emptyFriends = freezed,Object? defaultFriends = freezed,Object? group = null,Object? emptyGroup = freezed,Object? defaultGroup = freezed,Object? listedGroup = null,Object? emptyListedGroup = freezed,Object? defaultListedGroup = freezed,Object? status = null,Object? defaultStatus = freezed,Object? mainSubEntity = null,Object? optionalSubEntity = freezed,Object? primaryAddress = null,Object? secondaryAddress = freezed,Object? settings = null,Object? pastAddresses = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,emptyId: freezed == emptyId ? _self.emptyId : emptyId // ignore: cast_nullable_to_non_nullable
as String?,defaultId: freezed == defaultId ? _self.defaultId : defaultId // ignore: cast_nullable_to_non_nullable
as String?,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,emptyAge: freezed == emptyAge ? _self.emptyAge : emptyAge // ignore: cast_nullable_to_non_nullable
as int?,defaultAge: freezed == defaultAge ? _self.defaultAge : defaultAge // ignore: cast_nullable_to_non_nullable
as int?,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as double,emptyGrade: freezed == emptyGrade ? _self.emptyGrade : emptyGrade // ignore: cast_nullable_to_non_nullable
as double?,defaultGrade: freezed == defaultGrade ? _self.defaultGrade : defaultGrade // ignore: cast_nullable_to_non_nullable
as double?,friends: null == friends ? _self.friends : friends // ignore: cast_nullable_to_non_nullable
as List<String>,emptyFriends: freezed == emptyFriends ? _self.emptyFriends : emptyFriends // ignore: cast_nullable_to_non_nullable
as List<String>?,defaultFriends: freezed == defaultFriends ? _self.defaultFriends : defaultFriends // ignore: cast_nullable_to_non_nullable
as List<String>?,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,emptyGroup: freezed == emptyGroup ? _self.emptyGroup : emptyGroup // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,defaultGroup: freezed == defaultGroup ? _self.defaultGroup : defaultGroup // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,listedGroup: null == listedGroup ? _self.listedGroup : listedGroup // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,emptyListedGroup: freezed == emptyListedGroup ? _self.emptyListedGroup : emptyListedGroup // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,defaultListedGroup: freezed == defaultListedGroup ? _self.defaultListedGroup : defaultListedGroup // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,defaultStatus: freezed == defaultStatus ? _self.defaultStatus : defaultStatus // ignore: cast_nullable_to_non_nullable
as AccountStatus?,mainSubEntity: null == mainSubEntity ? _self.mainSubEntity : mainSubEntity // ignore: cast_nullable_to_non_nullable
as ExampleSubModel,optionalSubEntity: freezed == optionalSubEntity ? _self.optionalSubEntity : optionalSubEntity // ignore: cast_nullable_to_non_nullable
as ExampleSubModel?,primaryAddress: null == primaryAddress ? _self.primaryAddress : primaryAddress // ignore: cast_nullable_to_non_nullable
as ExampleAddressModel,secondaryAddress: freezed == secondaryAddress ? _self.secondaryAddress : secondaryAddress // ignore: cast_nullable_to_non_nullable
as ExampleAddressModel?,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as ExampleProfileSettingsModel,pastAddresses: freezed == pastAddresses ? _self.pastAddresses : pastAddresses // ignore: cast_nullable_to_non_nullable
as List<ExampleAddressModel>?,
  ));
}
/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleSubModelCopyWith<$Res> get mainSubEntity {
  
  return $ExampleSubModelCopyWith<$Res>(_self.mainSubEntity, (value) {
    return _then(_self.copyWith(mainSubEntity: value));
  });
}/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleSubModelCopyWith<$Res>? get optionalSubEntity {
    if (_self.optionalSubEntity == null) {
    return null;
  }

  return $ExampleSubModelCopyWith<$Res>(_self.optionalSubEntity!, (value) {
    return _then(_self.copyWith(optionalSubEntity: value));
  });
}/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleAddressModelCopyWith<$Res> get primaryAddress {
  
  return $ExampleAddressModelCopyWith<$Res>(_self.primaryAddress, (value) {
    return _then(_self.copyWith(primaryAddress: value));
  });
}/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleAddressModelCopyWith<$Res>? get secondaryAddress {
    if (_self.secondaryAddress == null) {
    return null;
  }

  return $ExampleAddressModelCopyWith<$Res>(_self.secondaryAddress!, (value) {
    return _then(_self.copyWith(secondaryAddress: value));
  });
}/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleProfileSettingsModelCopyWith<$Res> get settings {
  
  return $ExampleProfileSettingsModelCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? emptyId,  String? defaultId,  int age,  int? emptyAge,  int? defaultAge,  double grade,  double? emptyGrade,  double? defaultGrade,  List<String> friends,  List<String>? emptyFriends,  List<String>? defaultFriends,  Map<String, dynamic> group,  Map<String, dynamic>? emptyGroup,  Map<String, dynamic>? defaultGroup,  List<Map<String, dynamic>> listedGroup,  List<Map<String, dynamic>>? emptyListedGroup,  List<Map<String, dynamic>>? defaultListedGroup, @AccountStatusConverter()  AccountStatus status, @AccountStatusConverter()  AccountStatus? defaultStatus,  ExampleSubModel mainSubEntity,  ExampleSubModel? optionalSubEntity,  ExampleAddressModel primaryAddress,  ExampleAddressModel? secondaryAddress,  ExampleProfileSettingsModel settings,  List<ExampleAddressModel>? pastAddresses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExampleRequestParams() when $default != null:
return $default(_that.id,_that.emptyId,_that.defaultId,_that.age,_that.emptyAge,_that.defaultAge,_that.grade,_that.emptyGrade,_that.defaultGrade,_that.friends,_that.emptyFriends,_that.defaultFriends,_that.group,_that.emptyGroup,_that.defaultGroup,_that.listedGroup,_that.emptyListedGroup,_that.defaultListedGroup,_that.status,_that.defaultStatus,_that.mainSubEntity,_that.optionalSubEntity,_that.primaryAddress,_that.secondaryAddress,_that.settings,_that.pastAddresses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? emptyId,  String? defaultId,  int age,  int? emptyAge,  int? defaultAge,  double grade,  double? emptyGrade,  double? defaultGrade,  List<String> friends,  List<String>? emptyFriends,  List<String>? defaultFriends,  Map<String, dynamic> group,  Map<String, dynamic>? emptyGroup,  Map<String, dynamic>? defaultGroup,  List<Map<String, dynamic>> listedGroup,  List<Map<String, dynamic>>? emptyListedGroup,  List<Map<String, dynamic>>? defaultListedGroup, @AccountStatusConverter()  AccountStatus status, @AccountStatusConverter()  AccountStatus? defaultStatus,  ExampleSubModel mainSubEntity,  ExampleSubModel? optionalSubEntity,  ExampleAddressModel primaryAddress,  ExampleAddressModel? secondaryAddress,  ExampleProfileSettingsModel settings,  List<ExampleAddressModel>? pastAddresses)  $default,) {final _that = this;
switch (_that) {
case _ExampleRequestParams():
return $default(_that.id,_that.emptyId,_that.defaultId,_that.age,_that.emptyAge,_that.defaultAge,_that.grade,_that.emptyGrade,_that.defaultGrade,_that.friends,_that.emptyFriends,_that.defaultFriends,_that.group,_that.emptyGroup,_that.defaultGroup,_that.listedGroup,_that.emptyListedGroup,_that.defaultListedGroup,_that.status,_that.defaultStatus,_that.mainSubEntity,_that.optionalSubEntity,_that.primaryAddress,_that.secondaryAddress,_that.settings,_that.pastAddresses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? emptyId,  String? defaultId,  int age,  int? emptyAge,  int? defaultAge,  double grade,  double? emptyGrade,  double? defaultGrade,  List<String> friends,  List<String>? emptyFriends,  List<String>? defaultFriends,  Map<String, dynamic> group,  Map<String, dynamic>? emptyGroup,  Map<String, dynamic>? defaultGroup,  List<Map<String, dynamic>> listedGroup,  List<Map<String, dynamic>>? emptyListedGroup,  List<Map<String, dynamic>>? defaultListedGroup, @AccountStatusConverter()  AccountStatus status, @AccountStatusConverter()  AccountStatus? defaultStatus,  ExampleSubModel mainSubEntity,  ExampleSubModel? optionalSubEntity,  ExampleAddressModel primaryAddress,  ExampleAddressModel? secondaryAddress,  ExampleProfileSettingsModel settings,  List<ExampleAddressModel>? pastAddresses)?  $default,) {final _that = this;
switch (_that) {
case _ExampleRequestParams() when $default != null:
return $default(_that.id,_that.emptyId,_that.defaultId,_that.age,_that.emptyAge,_that.defaultAge,_that.grade,_that.emptyGrade,_that.defaultGrade,_that.friends,_that.emptyFriends,_that.defaultFriends,_that.group,_that.emptyGroup,_that.defaultGroup,_that.listedGroup,_that.emptyListedGroup,_that.defaultListedGroup,_that.status,_that.defaultStatus,_that.mainSubEntity,_that.optionalSubEntity,_that.primaryAddress,_that.secondaryAddress,_that.settings,_that.pastAddresses);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _ExampleRequestParams extends ExampleRequestParams {
  const _ExampleRequestParams({this.id, this.emptyId, this.defaultId = 'id', required this.age, this.emptyAge, this.defaultAge = 18, required this.grade, this.emptyGrade, this.defaultGrade = 99.6, required final  List<String> friends, final  List<String>? emptyFriends, final  List<String>? defaultFriends = const ['a', 'b', 'c'], required final  Map<String, dynamic> group, final  Map<String, dynamic>? emptyGroup, final  Map<String, dynamic>? defaultGroup = const {'a' : 1, 'b' : 2, 'c' : 3}, required final  List<Map<String, dynamic>> listedGroup, final  List<Map<String, dynamic>>? emptyListedGroup, final  List<Map<String, dynamic>>? defaultListedGroup = const [{'a' : 1, 'b' : 2, 'c' : 3}, {'d' : 4, 'e' : 5, 'f' : 6}], @AccountStatusConverter() required this.status, @AccountStatusConverter() this.defaultStatus = AccountStatus.pending, required this.mainSubEntity, this.optionalSubEntity, required this.primaryAddress, this.secondaryAddress, required this.settings, final  List<ExampleAddressModel>? pastAddresses = const []}): _friends = friends,_emptyFriends = emptyFriends,_defaultFriends = defaultFriends,_group = group,_emptyGroup = emptyGroup,_defaultGroup = defaultGroup,_listedGroup = listedGroup,_emptyListedGroup = emptyListedGroup,_defaultListedGroup = defaultListedGroup,_pastAddresses = pastAddresses,super._();
  factory _ExampleRequestParams.fromJson(Map<String, dynamic> json) => _$ExampleRequestParamsFromJson(json);

@override final  String? id;
@override final  String? emptyId;
@override@JsonKey() final  String? defaultId;
@override final  int age;
@override final  int? emptyAge;
@override@JsonKey() final  int? defaultAge;
@override final  double grade;
@override final  double? emptyGrade;
@override@JsonKey() final  double? defaultGrade;
 final  List<String> _friends;
@override List<String> get friends {
  if (_friends is EqualUnmodifiableListView) return _friends;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_friends);
}

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

 final  Map<String, dynamic> _group;
@override Map<String, dynamic> get group {
  if (_group is EqualUnmodifiableMapView) return _group;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_group);
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

 final  List<Map<String, dynamic>> _listedGroup;
@override List<Map<String, dynamic>> get listedGroup {
  if (_listedGroup is EqualUnmodifiableListView) return _listedGroup;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_listedGroup);
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

@override@AccountStatusConverter() final  AccountStatus status;
@override@JsonKey()@AccountStatusConverter() final  AccountStatus? defaultStatus;
@override final  ExampleSubModel mainSubEntity;
@override final  ExampleSubModel? optionalSubEntity;
@override final  ExampleAddressModel primaryAddress;
@override final  ExampleAddressModel? secondaryAddress;
@override final  ExampleProfileSettingsModel settings;
 final  List<ExampleAddressModel>? _pastAddresses;
@override@JsonKey() List<ExampleAddressModel>? get pastAddresses {
  final value = _pastAddresses;
  if (value == null) return null;
  if (_pastAddresses is EqualUnmodifiableListView) return _pastAddresses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExampleRequestParams&&(identical(other.id, id) || other.id == id)&&(identical(other.emptyId, emptyId) || other.emptyId == emptyId)&&(identical(other.defaultId, defaultId) || other.defaultId == defaultId)&&(identical(other.age, age) || other.age == age)&&(identical(other.emptyAge, emptyAge) || other.emptyAge == emptyAge)&&(identical(other.defaultAge, defaultAge) || other.defaultAge == defaultAge)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.emptyGrade, emptyGrade) || other.emptyGrade == emptyGrade)&&(identical(other.defaultGrade, defaultGrade) || other.defaultGrade == defaultGrade)&&const DeepCollectionEquality().equals(other._friends, _friends)&&const DeepCollectionEquality().equals(other._emptyFriends, _emptyFriends)&&const DeepCollectionEquality().equals(other._defaultFriends, _defaultFriends)&&const DeepCollectionEquality().equals(other._group, _group)&&const DeepCollectionEquality().equals(other._emptyGroup, _emptyGroup)&&const DeepCollectionEquality().equals(other._defaultGroup, _defaultGroup)&&const DeepCollectionEquality().equals(other._listedGroup, _listedGroup)&&const DeepCollectionEquality().equals(other._emptyListedGroup, _emptyListedGroup)&&const DeepCollectionEquality().equals(other._defaultListedGroup, _defaultListedGroup)&&(identical(other.status, status) || other.status == status)&&(identical(other.defaultStatus, defaultStatus) || other.defaultStatus == defaultStatus)&&(identical(other.mainSubEntity, mainSubEntity) || other.mainSubEntity == mainSubEntity)&&(identical(other.optionalSubEntity, optionalSubEntity) || other.optionalSubEntity == optionalSubEntity)&&(identical(other.primaryAddress, primaryAddress) || other.primaryAddress == primaryAddress)&&(identical(other.secondaryAddress, secondaryAddress) || other.secondaryAddress == secondaryAddress)&&(identical(other.settings, settings) || other.settings == settings)&&const DeepCollectionEquality().equals(other._pastAddresses, _pastAddresses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,emptyId,defaultId,age,emptyAge,defaultAge,grade,emptyGrade,defaultGrade,const DeepCollectionEquality().hash(_friends),const DeepCollectionEquality().hash(_emptyFriends),const DeepCollectionEquality().hash(_defaultFriends),const DeepCollectionEquality().hash(_group),const DeepCollectionEquality().hash(_emptyGroup),const DeepCollectionEquality().hash(_defaultGroup),const DeepCollectionEquality().hash(_listedGroup),const DeepCollectionEquality().hash(_emptyListedGroup),const DeepCollectionEquality().hash(_defaultListedGroup),status,defaultStatus,mainSubEntity,optionalSubEntity,primaryAddress,secondaryAddress,settings,const DeepCollectionEquality().hash(_pastAddresses)]);

@override
String toString() {
  return 'ExampleRequestParams(id: $id, emptyId: $emptyId, defaultId: $defaultId, age: $age, emptyAge: $emptyAge, defaultAge: $defaultAge, grade: $grade, emptyGrade: $emptyGrade, defaultGrade: $defaultGrade, friends: $friends, emptyFriends: $emptyFriends, defaultFriends: $defaultFriends, group: $group, emptyGroup: $emptyGroup, defaultGroup: $defaultGroup, listedGroup: $listedGroup, emptyListedGroup: $emptyListedGroup, defaultListedGroup: $defaultListedGroup, status: $status, defaultStatus: $defaultStatus, mainSubEntity: $mainSubEntity, optionalSubEntity: $optionalSubEntity, primaryAddress: $primaryAddress, secondaryAddress: $secondaryAddress, settings: $settings, pastAddresses: $pastAddresses)';
}


}

/// @nodoc
abstract mixin class _$ExampleRequestParamsCopyWith<$Res> implements $ExampleRequestParamsCopyWith<$Res> {
  factory _$ExampleRequestParamsCopyWith(_ExampleRequestParams value, $Res Function(_ExampleRequestParams) _then) = __$ExampleRequestParamsCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? emptyId, String? defaultId, int age, int? emptyAge, int? defaultAge, double grade, double? emptyGrade, double? defaultGrade, List<String> friends, List<String>? emptyFriends, List<String>? defaultFriends, Map<String, dynamic> group, Map<String, dynamic>? emptyGroup, Map<String, dynamic>? defaultGroup, List<Map<String, dynamic>> listedGroup, List<Map<String, dynamic>>? emptyListedGroup, List<Map<String, dynamic>>? defaultListedGroup,@AccountStatusConverter() AccountStatus status,@AccountStatusConverter() AccountStatus? defaultStatus, ExampleSubModel mainSubEntity, ExampleSubModel? optionalSubEntity, ExampleAddressModel primaryAddress, ExampleAddressModel? secondaryAddress, ExampleProfileSettingsModel settings, List<ExampleAddressModel>? pastAddresses
});


@override $ExampleSubModelCopyWith<$Res> get mainSubEntity;@override $ExampleSubModelCopyWith<$Res>? get optionalSubEntity;@override $ExampleAddressModelCopyWith<$Res> get primaryAddress;@override $ExampleAddressModelCopyWith<$Res>? get secondaryAddress;@override $ExampleProfileSettingsModelCopyWith<$Res> get settings;

}
/// @nodoc
class __$ExampleRequestParamsCopyWithImpl<$Res>
    implements _$ExampleRequestParamsCopyWith<$Res> {
  __$ExampleRequestParamsCopyWithImpl(this._self, this._then);

  final _ExampleRequestParams _self;
  final $Res Function(_ExampleRequestParams) _then;

/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? emptyId = freezed,Object? defaultId = freezed,Object? age = null,Object? emptyAge = freezed,Object? defaultAge = freezed,Object? grade = null,Object? emptyGrade = freezed,Object? defaultGrade = freezed,Object? friends = null,Object? emptyFriends = freezed,Object? defaultFriends = freezed,Object? group = null,Object? emptyGroup = freezed,Object? defaultGroup = freezed,Object? listedGroup = null,Object? emptyListedGroup = freezed,Object? defaultListedGroup = freezed,Object? status = null,Object? defaultStatus = freezed,Object? mainSubEntity = null,Object? optionalSubEntity = freezed,Object? primaryAddress = null,Object? secondaryAddress = freezed,Object? settings = null,Object? pastAddresses = freezed,}) {
  return _then(_ExampleRequestParams(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,emptyId: freezed == emptyId ? _self.emptyId : emptyId // ignore: cast_nullable_to_non_nullable
as String?,defaultId: freezed == defaultId ? _self.defaultId : defaultId // ignore: cast_nullable_to_non_nullable
as String?,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,emptyAge: freezed == emptyAge ? _self.emptyAge : emptyAge // ignore: cast_nullable_to_non_nullable
as int?,defaultAge: freezed == defaultAge ? _self.defaultAge : defaultAge // ignore: cast_nullable_to_non_nullable
as int?,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as double,emptyGrade: freezed == emptyGrade ? _self.emptyGrade : emptyGrade // ignore: cast_nullable_to_non_nullable
as double?,defaultGrade: freezed == defaultGrade ? _self.defaultGrade : defaultGrade // ignore: cast_nullable_to_non_nullable
as double?,friends: null == friends ? _self._friends : friends // ignore: cast_nullable_to_non_nullable
as List<String>,emptyFriends: freezed == emptyFriends ? _self._emptyFriends : emptyFriends // ignore: cast_nullable_to_non_nullable
as List<String>?,defaultFriends: freezed == defaultFriends ? _self._defaultFriends : defaultFriends // ignore: cast_nullable_to_non_nullable
as List<String>?,group: null == group ? _self._group : group // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,emptyGroup: freezed == emptyGroup ? _self._emptyGroup : emptyGroup // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,defaultGroup: freezed == defaultGroup ? _self._defaultGroup : defaultGroup // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,listedGroup: null == listedGroup ? _self._listedGroup : listedGroup // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,emptyListedGroup: freezed == emptyListedGroup ? _self._emptyListedGroup : emptyListedGroup // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,defaultListedGroup: freezed == defaultListedGroup ? _self._defaultListedGroup : defaultListedGroup // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,defaultStatus: freezed == defaultStatus ? _self.defaultStatus : defaultStatus // ignore: cast_nullable_to_non_nullable
as AccountStatus?,mainSubEntity: null == mainSubEntity ? _self.mainSubEntity : mainSubEntity // ignore: cast_nullable_to_non_nullable
as ExampleSubModel,optionalSubEntity: freezed == optionalSubEntity ? _self.optionalSubEntity : optionalSubEntity // ignore: cast_nullable_to_non_nullable
as ExampleSubModel?,primaryAddress: null == primaryAddress ? _self.primaryAddress : primaryAddress // ignore: cast_nullable_to_non_nullable
as ExampleAddressModel,secondaryAddress: freezed == secondaryAddress ? _self.secondaryAddress : secondaryAddress // ignore: cast_nullable_to_non_nullable
as ExampleAddressModel?,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as ExampleProfileSettingsModel,pastAddresses: freezed == pastAddresses ? _self._pastAddresses : pastAddresses // ignore: cast_nullable_to_non_nullable
as List<ExampleAddressModel>?,
  ));
}

/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleSubModelCopyWith<$Res> get mainSubEntity {
  
  return $ExampleSubModelCopyWith<$Res>(_self.mainSubEntity, (value) {
    return _then(_self.copyWith(mainSubEntity: value));
  });
}/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleSubModelCopyWith<$Res>? get optionalSubEntity {
    if (_self.optionalSubEntity == null) {
    return null;
  }

  return $ExampleSubModelCopyWith<$Res>(_self.optionalSubEntity!, (value) {
    return _then(_self.copyWith(optionalSubEntity: value));
  });
}/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleAddressModelCopyWith<$Res> get primaryAddress {
  
  return $ExampleAddressModelCopyWith<$Res>(_self.primaryAddress, (value) {
    return _then(_self.copyWith(primaryAddress: value));
  });
}/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleAddressModelCopyWith<$Res>? get secondaryAddress {
    if (_self.secondaryAddress == null) {
    return null;
  }

  return $ExampleAddressModelCopyWith<$Res>(_self.secondaryAddress!, (value) {
    return _then(_self.copyWith(secondaryAddress: value));
  });
}/// Create a copy of ExampleRequestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExampleProfileSettingsModelCopyWith<$Res> get settings {
  
  return $ExampleProfileSettingsModelCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on
