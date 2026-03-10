// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_icon_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppIconTheme {

 KAppColor? get color; double? get size; KAppColor? get backgroundColor; double? get containerHeight; double? get containerWidth; EdgeInsets? get containerPadding; KAppColor? get borderColor; double? get borderWidth; BorderRadius? get borderRadius; BoxShape? get shape; bool? get isCircular;
/// Create a copy of AppIconTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppIconThemeCopyWith<AppIconTheme> get copyWith => _$AppIconThemeCopyWithImpl<AppIconTheme>(this as AppIconTheme, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppIconTheme&&(identical(other.color, color) || other.color == color)&&(identical(other.size, size) || other.size == size)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.containerHeight, containerHeight) || other.containerHeight == containerHeight)&&(identical(other.containerWidth, containerWidth) || other.containerWidth == containerWidth)&&(identical(other.containerPadding, containerPadding) || other.containerPadding == containerPadding)&&(identical(other.borderColor, borderColor) || other.borderColor == borderColor)&&(identical(other.borderWidth, borderWidth) || other.borderWidth == borderWidth)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius)&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.isCircular, isCircular) || other.isCircular == isCircular));
}


@override
int get hashCode => Object.hash(runtimeType,color,size,backgroundColor,containerHeight,containerWidth,containerPadding,borderColor,borderWidth,borderRadius,shape,isCircular);

@override
String toString() {
  return 'AppIconTheme(color: $color, size: $size, backgroundColor: $backgroundColor, containerHeight: $containerHeight, containerWidth: $containerWidth, containerPadding: $containerPadding, borderColor: $borderColor, borderWidth: $borderWidth, borderRadius: $borderRadius, shape: $shape, isCircular: $isCircular)';
}


}

/// @nodoc
abstract mixin class $AppIconThemeCopyWith<$Res>  {
  factory $AppIconThemeCopyWith(AppIconTheme value, $Res Function(AppIconTheme) _then) = _$AppIconThemeCopyWithImpl;
@useResult
$Res call({
 KAppColor? color, double? size, KAppColor? backgroundColor, double? containerHeight, double? containerWidth, EdgeInsets? containerPadding, KAppColor? borderColor, double? borderWidth, BorderRadius? borderRadius, BoxShape? shape, bool? isCircular
});




}
/// @nodoc
class _$AppIconThemeCopyWithImpl<$Res>
    implements $AppIconThemeCopyWith<$Res> {
  _$AppIconThemeCopyWithImpl(this._self, this._then);

  final AppIconTheme _self;
  final $Res Function(AppIconTheme) _then;

/// Create a copy of AppIconTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? color = freezed,Object? size = freezed,Object? backgroundColor = freezed,Object? containerHeight = freezed,Object? containerWidth = freezed,Object? containerPadding = freezed,Object? borderColor = freezed,Object? borderWidth = freezed,Object? borderRadius = freezed,Object? shape = freezed,Object? isCircular = freezed,}) {
  return _then(_self.copyWith(
color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as KAppColor?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as double?,backgroundColor: freezed == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,containerHeight: freezed == containerHeight ? _self.containerHeight : containerHeight // ignore: cast_nullable_to_non_nullable
as double?,containerWidth: freezed == containerWidth ? _self.containerWidth : containerWidth // ignore: cast_nullable_to_non_nullable
as double?,containerPadding: freezed == containerPadding ? _self.containerPadding : containerPadding // ignore: cast_nullable_to_non_nullable
as EdgeInsets?,borderColor: freezed == borderColor ? _self.borderColor : borderColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,borderWidth: freezed == borderWidth ? _self.borderWidth : borderWidth // ignore: cast_nullable_to_non_nullable
as double?,borderRadius: freezed == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as BorderRadius?,shape: freezed == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as BoxShape?,isCircular: freezed == isCircular ? _self.isCircular : isCircular // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppIconTheme].
extension AppIconThemePatterns on AppIconTheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppIconTheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppIconTheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppIconTheme value)  $default,){
final _that = this;
switch (_that) {
case _AppIconTheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppIconTheme value)?  $default,){
final _that = this;
switch (_that) {
case _AppIconTheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( KAppColor? color,  double? size,  KAppColor? backgroundColor,  double? containerHeight,  double? containerWidth,  EdgeInsets? containerPadding,  KAppColor? borderColor,  double? borderWidth,  BorderRadius? borderRadius,  BoxShape? shape,  bool? isCircular)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppIconTheme() when $default != null:
return $default(_that.color,_that.size,_that.backgroundColor,_that.containerHeight,_that.containerWidth,_that.containerPadding,_that.borderColor,_that.borderWidth,_that.borderRadius,_that.shape,_that.isCircular);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( KAppColor? color,  double? size,  KAppColor? backgroundColor,  double? containerHeight,  double? containerWidth,  EdgeInsets? containerPadding,  KAppColor? borderColor,  double? borderWidth,  BorderRadius? borderRadius,  BoxShape? shape,  bool? isCircular)  $default,) {final _that = this;
switch (_that) {
case _AppIconTheme():
return $default(_that.color,_that.size,_that.backgroundColor,_that.containerHeight,_that.containerWidth,_that.containerPadding,_that.borderColor,_that.borderWidth,_that.borderRadius,_that.shape,_that.isCircular);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( KAppColor? color,  double? size,  KAppColor? backgroundColor,  double? containerHeight,  double? containerWidth,  EdgeInsets? containerPadding,  KAppColor? borderColor,  double? borderWidth,  BorderRadius? borderRadius,  BoxShape? shape,  bool? isCircular)?  $default,) {final _that = this;
switch (_that) {
case _AppIconTheme() when $default != null:
return $default(_that.color,_that.size,_that.backgroundColor,_that.containerHeight,_that.containerWidth,_that.containerPadding,_that.borderColor,_that.borderWidth,_that.borderRadius,_that.shape,_that.isCircular);case _:
  return null;

}
}

}

/// @nodoc


class _AppIconTheme implements AppIconTheme {
  const _AppIconTheme({this.color, this.size, this.backgroundColor, this.containerHeight, this.containerWidth, this.containerPadding, this.borderColor, this.borderWidth, this.borderRadius, this.shape, this.isCircular});
  

@override final  KAppColor? color;
@override final  double? size;
@override final  KAppColor? backgroundColor;
@override final  double? containerHeight;
@override final  double? containerWidth;
@override final  EdgeInsets? containerPadding;
@override final  KAppColor? borderColor;
@override final  double? borderWidth;
@override final  BorderRadius? borderRadius;
@override final  BoxShape? shape;
@override final  bool? isCircular;

/// Create a copy of AppIconTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppIconThemeCopyWith<_AppIconTheme> get copyWith => __$AppIconThemeCopyWithImpl<_AppIconTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppIconTheme&&(identical(other.color, color) || other.color == color)&&(identical(other.size, size) || other.size == size)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.containerHeight, containerHeight) || other.containerHeight == containerHeight)&&(identical(other.containerWidth, containerWidth) || other.containerWidth == containerWidth)&&(identical(other.containerPadding, containerPadding) || other.containerPadding == containerPadding)&&(identical(other.borderColor, borderColor) || other.borderColor == borderColor)&&(identical(other.borderWidth, borderWidth) || other.borderWidth == borderWidth)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius)&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.isCircular, isCircular) || other.isCircular == isCircular));
}


@override
int get hashCode => Object.hash(runtimeType,color,size,backgroundColor,containerHeight,containerWidth,containerPadding,borderColor,borderWidth,borderRadius,shape,isCircular);

@override
String toString() {
  return 'AppIconTheme(color: $color, size: $size, backgroundColor: $backgroundColor, containerHeight: $containerHeight, containerWidth: $containerWidth, containerPadding: $containerPadding, borderColor: $borderColor, borderWidth: $borderWidth, borderRadius: $borderRadius, shape: $shape, isCircular: $isCircular)';
}


}

/// @nodoc
abstract mixin class _$AppIconThemeCopyWith<$Res> implements $AppIconThemeCopyWith<$Res> {
  factory _$AppIconThemeCopyWith(_AppIconTheme value, $Res Function(_AppIconTheme) _then) = __$AppIconThemeCopyWithImpl;
@override @useResult
$Res call({
 KAppColor? color, double? size, KAppColor? backgroundColor, double? containerHeight, double? containerWidth, EdgeInsets? containerPadding, KAppColor? borderColor, double? borderWidth, BorderRadius? borderRadius, BoxShape? shape, bool? isCircular
});




}
/// @nodoc
class __$AppIconThemeCopyWithImpl<$Res>
    implements _$AppIconThemeCopyWith<$Res> {
  __$AppIconThemeCopyWithImpl(this._self, this._then);

  final _AppIconTheme _self;
  final $Res Function(_AppIconTheme) _then;

/// Create a copy of AppIconTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? color = freezed,Object? size = freezed,Object? backgroundColor = freezed,Object? containerHeight = freezed,Object? containerWidth = freezed,Object? containerPadding = freezed,Object? borderColor = freezed,Object? borderWidth = freezed,Object? borderRadius = freezed,Object? shape = freezed,Object? isCircular = freezed,}) {
  return _then(_AppIconTheme(
color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as KAppColor?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as double?,backgroundColor: freezed == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,containerHeight: freezed == containerHeight ? _self.containerHeight : containerHeight // ignore: cast_nullable_to_non_nullable
as double?,containerWidth: freezed == containerWidth ? _self.containerWidth : containerWidth // ignore: cast_nullable_to_non_nullable
as double?,containerPadding: freezed == containerPadding ? _self.containerPadding : containerPadding // ignore: cast_nullable_to_non_nullable
as EdgeInsets?,borderColor: freezed == borderColor ? _self.borderColor : borderColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,borderWidth: freezed == borderWidth ? _self.borderWidth : borderWidth // ignore: cast_nullable_to_non_nullable
as double?,borderRadius: freezed == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as BorderRadius?,shape: freezed == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as BoxShape?,isCircular: freezed == isCircular ? _self.isCircular : isCircular // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
