// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FilterParams {

 int get page; int get limit; String? get query;
/// Create a copy of FilterParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilterParamsCopyWith<FilterParams> get copyWith => _$FilterParamsCopyWithImpl<FilterParams>(this as FilterParams, _$identity);

  /// Serializes this FilterParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterParams&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.query, query) || other.query == query));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,limit,query);

@override
String toString() {
  return 'FilterParams(page: $page, limit: $limit, query: $query)';
}


}

/// @nodoc
abstract mixin class $FilterParamsCopyWith<$Res>  {
  factory $FilterParamsCopyWith(FilterParams value, $Res Function(FilterParams) _then) = _$FilterParamsCopyWithImpl;
@useResult
$Res call({
 int page, int limit, String? query
});




}
/// @nodoc
class _$FilterParamsCopyWithImpl<$Res>
    implements $FilterParamsCopyWith<$Res> {
  _$FilterParamsCopyWithImpl(this._self, this._then);

  final FilterParams _self;
  final $Res Function(FilterParams) _then;

/// Create a copy of FilterParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? limit = null,Object? query = freezed,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FilterParams].
extension FilterParamsPatterns on FilterParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FilterParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FilterParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FilterParams value)  $default,){
final _that = this;
switch (_that) {
case _FilterParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FilterParams value)?  $default,){
final _that = this;
switch (_that) {
case _FilterParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page,  int limit,  String? query)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FilterParams() when $default != null:
return $default(_that.page,_that.limit,_that.query);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page,  int limit,  String? query)  $default,) {final _that = this;
switch (_that) {
case _FilterParams():
return $default(_that.page,_that.limit,_that.query);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page,  int limit,  String? query)?  $default,) {final _that = this;
switch (_that) {
case _FilterParams() when $default != null:
return $default(_that.page,_that.limit,_that.query);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _FilterParams extends FilterParams {
  const _FilterParams({this.page = 1, this.limit = 10, this.query}): super._();
  factory _FilterParams.fromJson(Map<String, dynamic> json) => _$FilterParamsFromJson(json);

@override@JsonKey() final  int page;
@override@JsonKey() final  int limit;
@override final  String? query;

/// Create a copy of FilterParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilterParamsCopyWith<_FilterParams> get copyWith => __$FilterParamsCopyWithImpl<_FilterParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FilterParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilterParams&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.query, query) || other.query == query));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,limit,query);

@override
String toString() {
  return 'FilterParams(page: $page, limit: $limit, query: $query)';
}


}

/// @nodoc
abstract mixin class _$FilterParamsCopyWith<$Res> implements $FilterParamsCopyWith<$Res> {
  factory _$FilterParamsCopyWith(_FilterParams value, $Res Function(_FilterParams) _then) = __$FilterParamsCopyWithImpl;
@override @useResult
$Res call({
 int page, int limit, String? query
});




}
/// @nodoc
class __$FilterParamsCopyWithImpl<$Res>
    implements _$FilterParamsCopyWith<$Res> {
  __$FilterParamsCopyWithImpl(this._self, this._then);

  final _FilterParams _self;
  final $Res Function(_FilterParams) _then;

/// Create a copy of FilterParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? limit = null,Object? query = freezed,}) {
  return _then(_FilterParams(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
