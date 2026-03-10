// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TestState {

 bool get isLoading; bool get isSuccess; bool get isValid; bool get hasLocationPermission;
/// Create a copy of TestState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestStateCopyWith<TestState> get copyWith => _$TestStateCopyWithImpl<TestState>(this as TestState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.hasLocationPermission, hasLocationPermission) || other.hasLocationPermission == hasLocationPermission));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isSuccess,isValid,hasLocationPermission);

@override
String toString() {
  return 'TestState(isLoading: $isLoading, isSuccess: $isSuccess, isValid: $isValid, hasLocationPermission: $hasLocationPermission)';
}


}

/// @nodoc
abstract mixin class $TestStateCopyWith<$Res>  {
  factory $TestStateCopyWith(TestState value, $Res Function(TestState) _then) = _$TestStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isSuccess, bool isValid, bool hasLocationPermission
});




}
/// @nodoc
class _$TestStateCopyWithImpl<$Res>
    implements $TestStateCopyWith<$Res> {
  _$TestStateCopyWithImpl(this._self, this._then);

  final TestState _self;
  final $Res Function(TestState) _then;

/// Create a copy of TestState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isSuccess = null,Object? isValid = null,Object? hasLocationPermission = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,isValid: null == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool,hasLocationPermission: null == hasLocationPermission ? _self.hasLocationPermission : hasLocationPermission // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TestState].
extension TestStatePatterns on TestState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TestState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TestState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TestState value)  $default,){
final _that = this;
switch (_that) {
case _TestState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TestState value)?  $default,){
final _that = this;
switch (_that) {
case _TestState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isSuccess,  bool isValid,  bool hasLocationPermission)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TestState() when $default != null:
return $default(_that.isLoading,_that.isSuccess,_that.isValid,_that.hasLocationPermission);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isSuccess,  bool isValid,  bool hasLocationPermission)  $default,) {final _that = this;
switch (_that) {
case _TestState():
return $default(_that.isLoading,_that.isSuccess,_that.isValid,_that.hasLocationPermission);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isSuccess,  bool isValid,  bool hasLocationPermission)?  $default,) {final _that = this;
switch (_that) {
case _TestState() when $default != null:
return $default(_that.isLoading,_that.isSuccess,_that.isValid,_that.hasLocationPermission);case _:
  return null;

}
}

}

/// @nodoc


class _TestState implements TestState {
  const _TestState({this.isLoading = false, this.isSuccess = false, this.isValid = false, this.hasLocationPermission = false});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSuccess;
@override@JsonKey() final  bool isValid;
@override@JsonKey() final  bool hasLocationPermission;

/// Create a copy of TestState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TestStateCopyWith<_TestState> get copyWith => __$TestStateCopyWithImpl<_TestState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TestState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.hasLocationPermission, hasLocationPermission) || other.hasLocationPermission == hasLocationPermission));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isSuccess,isValid,hasLocationPermission);

@override
String toString() {
  return 'TestState(isLoading: $isLoading, isSuccess: $isSuccess, isValid: $isValid, hasLocationPermission: $hasLocationPermission)';
}


}

/// @nodoc
abstract mixin class _$TestStateCopyWith<$Res> implements $TestStateCopyWith<$Res> {
  factory _$TestStateCopyWith(_TestState value, $Res Function(_TestState) _then) = __$TestStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isSuccess, bool isValid, bool hasLocationPermission
});




}
/// @nodoc
class __$TestStateCopyWithImpl<$Res>
    implements _$TestStateCopyWith<$Res> {
  __$TestStateCopyWithImpl(this._self, this._then);

  final _TestState _self;
  final $Res Function(_TestState) _then;

/// Create a copy of TestState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isSuccess = null,Object? isValid = null,Object? hasLocationPermission = null,}) {
  return _then(_TestState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,isValid: null == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool,hasLocationPermission: null == hasLocationPermission ? _self.hasLocationPermission : hasLocationPermission // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
