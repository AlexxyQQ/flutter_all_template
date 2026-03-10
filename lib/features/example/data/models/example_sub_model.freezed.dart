// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example_sub_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExampleSubModel {

 String get subId; String get description; bool get isActive; bool get isVisible;@JsonKey(fromJson: ModelGeneratorHelper.generateCreatedAtFromJson) DateTime get createdAt;@JsonKey(fromJson: ModelGeneratorHelper.generateUpdatedAtFromJson) DateTime? get updatedAt;
/// Create a copy of ExampleSubModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExampleSubModelCopyWith<ExampleSubModel> get copyWith => _$ExampleSubModelCopyWithImpl<ExampleSubModel>(this as ExampleSubModel, _$identity);

  /// Serializes this ExampleSubModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExampleSubModel&&(identical(other.subId, subId) || other.subId == subId)&&(identical(other.description, description) || other.description == description)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subId,description,isActive,isVisible,createdAt,updatedAt);

@override
String toString() {
  return 'ExampleSubModel(subId: $subId, description: $description, isActive: $isActive, isVisible: $isVisible, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ExampleSubModelCopyWith<$Res>  {
  factory $ExampleSubModelCopyWith(ExampleSubModel value, $Res Function(ExampleSubModel) _then) = _$ExampleSubModelCopyWithImpl;
@useResult
$Res call({
 String subId, String description, bool isActive, bool isVisible,@JsonKey(fromJson: ModelGeneratorHelper.generateCreatedAtFromJson) DateTime createdAt,@JsonKey(fromJson: ModelGeneratorHelper.generateUpdatedAtFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$ExampleSubModelCopyWithImpl<$Res>
    implements $ExampleSubModelCopyWith<$Res> {
  _$ExampleSubModelCopyWithImpl(this._self, this._then);

  final ExampleSubModel _self;
  final $Res Function(ExampleSubModel) _then;

/// Create a copy of ExampleSubModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subId = null,Object? description = null,Object? isActive = null,Object? isVisible = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
subId: null == subId ? _self.subId : subId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExampleSubModel].
extension ExampleSubModelPatterns on ExampleSubModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExampleSubModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExampleSubModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExampleSubModel value)  $default,){
final _that = this;
switch (_that) {
case _ExampleSubModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExampleSubModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExampleSubModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subId,  String description,  bool isActive,  bool isVisible, @JsonKey(fromJson: ModelGeneratorHelper.generateCreatedAtFromJson)  DateTime createdAt, @JsonKey(fromJson: ModelGeneratorHelper.generateUpdatedAtFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExampleSubModel() when $default != null:
return $default(_that.subId,_that.description,_that.isActive,_that.isVisible,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subId,  String description,  bool isActive,  bool isVisible, @JsonKey(fromJson: ModelGeneratorHelper.generateCreatedAtFromJson)  DateTime createdAt, @JsonKey(fromJson: ModelGeneratorHelper.generateUpdatedAtFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ExampleSubModel():
return $default(_that.subId,_that.description,_that.isActive,_that.isVisible,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subId,  String description,  bool isActive,  bool isVisible, @JsonKey(fromJson: ModelGeneratorHelper.generateCreatedAtFromJson)  DateTime createdAt, @JsonKey(fromJson: ModelGeneratorHelper.generateUpdatedAtFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ExampleSubModel() when $default != null:
return $default(_that.subId,_that.description,_that.isActive,_that.isVisible,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class _ExampleSubModel extends ExampleSubModel {
  const _ExampleSubModel({required this.subId, required this.description, required this.isActive, this.isVisible = true, @JsonKey(fromJson: ModelGeneratorHelper.generateCreatedAtFromJson) required this.createdAt, @JsonKey(fromJson: ModelGeneratorHelper.generateUpdatedAtFromJson) this.updatedAt}): super._();
  factory _ExampleSubModel.fromJson(Map<String, dynamic> json) => _$ExampleSubModelFromJson(json);

@override final  String subId;
@override final  String description;
@override final  bool isActive;
@override@JsonKey() final  bool isVisible;
@override@JsonKey(fromJson: ModelGeneratorHelper.generateCreatedAtFromJson) final  DateTime createdAt;
@override@JsonKey(fromJson: ModelGeneratorHelper.generateUpdatedAtFromJson) final  DateTime? updatedAt;

/// Create a copy of ExampleSubModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExampleSubModelCopyWith<_ExampleSubModel> get copyWith => __$ExampleSubModelCopyWithImpl<_ExampleSubModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExampleSubModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExampleSubModel&&(identical(other.subId, subId) || other.subId == subId)&&(identical(other.description, description) || other.description == description)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subId,description,isActive,isVisible,createdAt,updatedAt);

@override
String toString() {
  return 'ExampleSubModel(subId: $subId, description: $description, isActive: $isActive, isVisible: $isVisible, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ExampleSubModelCopyWith<$Res> implements $ExampleSubModelCopyWith<$Res> {
  factory _$ExampleSubModelCopyWith(_ExampleSubModel value, $Res Function(_ExampleSubModel) _then) = __$ExampleSubModelCopyWithImpl;
@override @useResult
$Res call({
 String subId, String description, bool isActive, bool isVisible,@JsonKey(fromJson: ModelGeneratorHelper.generateCreatedAtFromJson) DateTime createdAt,@JsonKey(fromJson: ModelGeneratorHelper.generateUpdatedAtFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$ExampleSubModelCopyWithImpl<$Res>
    implements _$ExampleSubModelCopyWith<$Res> {
  __$ExampleSubModelCopyWithImpl(this._self, this._then);

  final _ExampleSubModel _self;
  final $Res Function(_ExampleSubModel) _then;

/// Create a copy of ExampleSubModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subId = null,Object? description = null,Object? isActive = null,Object? isVisible = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_ExampleSubModel(
subId: null == subId ? _self.subId : subId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
