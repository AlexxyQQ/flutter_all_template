// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example_sub_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExampleSubEntity {

 String get subId; String get description; bool get isActive; bool get isVisible; DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of ExampleSubEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExampleSubEntityCopyWith<ExampleSubEntity> get copyWith => _$ExampleSubEntityCopyWithImpl<ExampleSubEntity>(this as ExampleSubEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExampleSubEntity&&(identical(other.subId, subId) || other.subId == subId)&&(identical(other.description, description) || other.description == description)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,subId,description,isActive,isVisible,createdAt,updatedAt);

@override
String toString() {
  return 'ExampleSubEntity(subId: $subId, description: $description, isActive: $isActive, isVisible: $isVisible, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ExampleSubEntityCopyWith<$Res>  {
  factory $ExampleSubEntityCopyWith(ExampleSubEntity value, $Res Function(ExampleSubEntity) _then) = _$ExampleSubEntityCopyWithImpl;
@useResult
$Res call({
 String subId, String description, bool isActive, bool isVisible, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$ExampleSubEntityCopyWithImpl<$Res>
    implements $ExampleSubEntityCopyWith<$Res> {
  _$ExampleSubEntityCopyWithImpl(this._self, this._then);

  final ExampleSubEntity _self;
  final $Res Function(ExampleSubEntity) _then;

/// Create a copy of ExampleSubEntity
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


/// Adds pattern-matching-related methods to [ExampleSubEntity].
extension ExampleSubEntityPatterns on ExampleSubEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExampleSubEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExampleSubEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExampleSubEntity value)  $default,){
final _that = this;
switch (_that) {
case _ExampleSubEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExampleSubEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ExampleSubEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subId,  String description,  bool isActive,  bool isVisible,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExampleSubEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subId,  String description,  bool isActive,  bool isVisible,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ExampleSubEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subId,  String description,  bool isActive,  bool isVisible,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ExampleSubEntity() when $default != null:
return $default(_that.subId,_that.description,_that.isActive,_that.isVisible,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ExampleSubEntity extends ExampleSubEntity {
  const _ExampleSubEntity({required this.subId, required this.description, required this.isActive, this.isVisible = true, required this.createdAt, this.updatedAt}): super._();
  

@override final  String subId;
@override final  String description;
@override final  bool isActive;
@override@JsonKey() final  bool isVisible;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of ExampleSubEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExampleSubEntityCopyWith<_ExampleSubEntity> get copyWith => __$ExampleSubEntityCopyWithImpl<_ExampleSubEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExampleSubEntity&&(identical(other.subId, subId) || other.subId == subId)&&(identical(other.description, description) || other.description == description)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,subId,description,isActive,isVisible,createdAt,updatedAt);

@override
String toString() {
  return 'ExampleSubEntity(subId: $subId, description: $description, isActive: $isActive, isVisible: $isVisible, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ExampleSubEntityCopyWith<$Res> implements $ExampleSubEntityCopyWith<$Res> {
  factory _$ExampleSubEntityCopyWith(_ExampleSubEntity value, $Res Function(_ExampleSubEntity) _then) = __$ExampleSubEntityCopyWithImpl;
@override @useResult
$Res call({
 String subId, String description, bool isActive, bool isVisible, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$ExampleSubEntityCopyWithImpl<$Res>
    implements _$ExampleSubEntityCopyWith<$Res> {
  __$ExampleSubEntityCopyWithImpl(this._self, this._then);

  final _ExampleSubEntity _self;
  final $Res Function(_ExampleSubEntity) _then;

/// Create a copy of ExampleSubEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subId = null,Object? description = null,Object? isActive = null,Object? isVisible = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_ExampleSubEntity(
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
