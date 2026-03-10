// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_picture_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PictureTheme {

 KAppColor? get color; BoxFit? get fit; Alignment? get alignment; String? get semanticsLabel; bool? get matchTextDirection; KAppColor? get backgroundColor; double? get containerHeight; double? get containerWidth; EdgeInsets? get containerPadding; KAppColor? get borderColor; double? get borderWidth; BorderRadius? get borderRadius; BoxShape? get shape; TextStyle? get altTextStyle;
/// Create a copy of PictureTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PictureThemeCopyWith<PictureTheme> get copyWith => _$PictureThemeCopyWithImpl<PictureTheme>(this as PictureTheme, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PictureTheme&&(identical(other.color, color) || other.color == color)&&(identical(other.fit, fit) || other.fit == fit)&&(identical(other.alignment, alignment) || other.alignment == alignment)&&(identical(other.semanticsLabel, semanticsLabel) || other.semanticsLabel == semanticsLabel)&&(identical(other.matchTextDirection, matchTextDirection) || other.matchTextDirection == matchTextDirection)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.containerHeight, containerHeight) || other.containerHeight == containerHeight)&&(identical(other.containerWidth, containerWidth) || other.containerWidth == containerWidth)&&(identical(other.containerPadding, containerPadding) || other.containerPadding == containerPadding)&&(identical(other.borderColor, borderColor) || other.borderColor == borderColor)&&(identical(other.borderWidth, borderWidth) || other.borderWidth == borderWidth)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius)&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.altTextStyle, altTextStyle) || other.altTextStyle == altTextStyle));
}


@override
int get hashCode => Object.hash(runtimeType,color,fit,alignment,semanticsLabel,matchTextDirection,backgroundColor,containerHeight,containerWidth,containerPadding,borderColor,borderWidth,borderRadius,shape,altTextStyle);

@override
String toString() {
  return 'PictureTheme(color: $color, fit: $fit, alignment: $alignment, semanticsLabel: $semanticsLabel, matchTextDirection: $matchTextDirection, backgroundColor: $backgroundColor, containerHeight: $containerHeight, containerWidth: $containerWidth, containerPadding: $containerPadding, borderColor: $borderColor, borderWidth: $borderWidth, borderRadius: $borderRadius, shape: $shape, altTextStyle: $altTextStyle)';
}


}

/// @nodoc
abstract mixin class $PictureThemeCopyWith<$Res>  {
  factory $PictureThemeCopyWith(PictureTheme value, $Res Function(PictureTheme) _then) = _$PictureThemeCopyWithImpl;
@useResult
$Res call({
 KAppColor? color, BoxFit? fit, Alignment? alignment, String? semanticsLabel, bool? matchTextDirection, KAppColor? backgroundColor, double? containerHeight, double? containerWidth, EdgeInsets? containerPadding, KAppColor? borderColor, double? borderWidth, BorderRadius? borderRadius, BoxShape? shape, TextStyle? altTextStyle
});




}
/// @nodoc
class _$PictureThemeCopyWithImpl<$Res>
    implements $PictureThemeCopyWith<$Res> {
  _$PictureThemeCopyWithImpl(this._self, this._then);

  final PictureTheme _self;
  final $Res Function(PictureTheme) _then;

/// Create a copy of PictureTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? color = freezed,Object? fit = freezed,Object? alignment = freezed,Object? semanticsLabel = freezed,Object? matchTextDirection = freezed,Object? backgroundColor = freezed,Object? containerHeight = freezed,Object? containerWidth = freezed,Object? containerPadding = freezed,Object? borderColor = freezed,Object? borderWidth = freezed,Object? borderRadius = freezed,Object? shape = freezed,Object? altTextStyle = freezed,}) {
  return _then(_self.copyWith(
color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as KAppColor?,fit: freezed == fit ? _self.fit : fit // ignore: cast_nullable_to_non_nullable
as BoxFit?,alignment: freezed == alignment ? _self.alignment : alignment // ignore: cast_nullable_to_non_nullable
as Alignment?,semanticsLabel: freezed == semanticsLabel ? _self.semanticsLabel : semanticsLabel // ignore: cast_nullable_to_non_nullable
as String?,matchTextDirection: freezed == matchTextDirection ? _self.matchTextDirection : matchTextDirection // ignore: cast_nullable_to_non_nullable
as bool?,backgroundColor: freezed == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,containerHeight: freezed == containerHeight ? _self.containerHeight : containerHeight // ignore: cast_nullable_to_non_nullable
as double?,containerWidth: freezed == containerWidth ? _self.containerWidth : containerWidth // ignore: cast_nullable_to_non_nullable
as double?,containerPadding: freezed == containerPadding ? _self.containerPadding : containerPadding // ignore: cast_nullable_to_non_nullable
as EdgeInsets?,borderColor: freezed == borderColor ? _self.borderColor : borderColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,borderWidth: freezed == borderWidth ? _self.borderWidth : borderWidth // ignore: cast_nullable_to_non_nullable
as double?,borderRadius: freezed == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as BorderRadius?,shape: freezed == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as BoxShape?,altTextStyle: freezed == altTextStyle ? _self.altTextStyle : altTextStyle // ignore: cast_nullable_to_non_nullable
as TextStyle?,
  ));
}

}


/// Adds pattern-matching-related methods to [PictureTheme].
extension PictureThemePatterns on PictureTheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PictureTheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PictureTheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PictureTheme value)  $default,){
final _that = this;
switch (_that) {
case _PictureTheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PictureTheme value)?  $default,){
final _that = this;
switch (_that) {
case _PictureTheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( KAppColor? color,  BoxFit? fit,  Alignment? alignment,  String? semanticsLabel,  bool? matchTextDirection,  KAppColor? backgroundColor,  double? containerHeight,  double? containerWidth,  EdgeInsets? containerPadding,  KAppColor? borderColor,  double? borderWidth,  BorderRadius? borderRadius,  BoxShape? shape,  TextStyle? altTextStyle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PictureTheme() when $default != null:
return $default(_that.color,_that.fit,_that.alignment,_that.semanticsLabel,_that.matchTextDirection,_that.backgroundColor,_that.containerHeight,_that.containerWidth,_that.containerPadding,_that.borderColor,_that.borderWidth,_that.borderRadius,_that.shape,_that.altTextStyle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( KAppColor? color,  BoxFit? fit,  Alignment? alignment,  String? semanticsLabel,  bool? matchTextDirection,  KAppColor? backgroundColor,  double? containerHeight,  double? containerWidth,  EdgeInsets? containerPadding,  KAppColor? borderColor,  double? borderWidth,  BorderRadius? borderRadius,  BoxShape? shape,  TextStyle? altTextStyle)  $default,) {final _that = this;
switch (_that) {
case _PictureTheme():
return $default(_that.color,_that.fit,_that.alignment,_that.semanticsLabel,_that.matchTextDirection,_that.backgroundColor,_that.containerHeight,_that.containerWidth,_that.containerPadding,_that.borderColor,_that.borderWidth,_that.borderRadius,_that.shape,_that.altTextStyle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( KAppColor? color,  BoxFit? fit,  Alignment? alignment,  String? semanticsLabel,  bool? matchTextDirection,  KAppColor? backgroundColor,  double? containerHeight,  double? containerWidth,  EdgeInsets? containerPadding,  KAppColor? borderColor,  double? borderWidth,  BorderRadius? borderRadius,  BoxShape? shape,  TextStyle? altTextStyle)?  $default,) {final _that = this;
switch (_that) {
case _PictureTheme() when $default != null:
return $default(_that.color,_that.fit,_that.alignment,_that.semanticsLabel,_that.matchTextDirection,_that.backgroundColor,_that.containerHeight,_that.containerWidth,_that.containerPadding,_that.borderColor,_that.borderWidth,_that.borderRadius,_that.shape,_that.altTextStyle);case _:
  return null;

}
}

}

/// @nodoc


class _PictureTheme implements PictureTheme {
  const _PictureTheme({this.color, this.fit, this.alignment, this.semanticsLabel, this.matchTextDirection, this.backgroundColor, this.containerHeight, this.containerWidth, this.containerPadding, this.borderColor, this.borderWidth, this.borderRadius, this.shape, this.altTextStyle});
  

@override final  KAppColor? color;
@override final  BoxFit? fit;
@override final  Alignment? alignment;
@override final  String? semanticsLabel;
@override final  bool? matchTextDirection;
@override final  KAppColor? backgroundColor;
@override final  double? containerHeight;
@override final  double? containerWidth;
@override final  EdgeInsets? containerPadding;
@override final  KAppColor? borderColor;
@override final  double? borderWidth;
@override final  BorderRadius? borderRadius;
@override final  BoxShape? shape;
@override final  TextStyle? altTextStyle;

/// Create a copy of PictureTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PictureThemeCopyWith<_PictureTheme> get copyWith => __$PictureThemeCopyWithImpl<_PictureTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PictureTheme&&(identical(other.color, color) || other.color == color)&&(identical(other.fit, fit) || other.fit == fit)&&(identical(other.alignment, alignment) || other.alignment == alignment)&&(identical(other.semanticsLabel, semanticsLabel) || other.semanticsLabel == semanticsLabel)&&(identical(other.matchTextDirection, matchTextDirection) || other.matchTextDirection == matchTextDirection)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.containerHeight, containerHeight) || other.containerHeight == containerHeight)&&(identical(other.containerWidth, containerWidth) || other.containerWidth == containerWidth)&&(identical(other.containerPadding, containerPadding) || other.containerPadding == containerPadding)&&(identical(other.borderColor, borderColor) || other.borderColor == borderColor)&&(identical(other.borderWidth, borderWidth) || other.borderWidth == borderWidth)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius)&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.altTextStyle, altTextStyle) || other.altTextStyle == altTextStyle));
}


@override
int get hashCode => Object.hash(runtimeType,color,fit,alignment,semanticsLabel,matchTextDirection,backgroundColor,containerHeight,containerWidth,containerPadding,borderColor,borderWidth,borderRadius,shape,altTextStyle);

@override
String toString() {
  return 'PictureTheme(color: $color, fit: $fit, alignment: $alignment, semanticsLabel: $semanticsLabel, matchTextDirection: $matchTextDirection, backgroundColor: $backgroundColor, containerHeight: $containerHeight, containerWidth: $containerWidth, containerPadding: $containerPadding, borderColor: $borderColor, borderWidth: $borderWidth, borderRadius: $borderRadius, shape: $shape, altTextStyle: $altTextStyle)';
}


}

/// @nodoc
abstract mixin class _$PictureThemeCopyWith<$Res> implements $PictureThemeCopyWith<$Res> {
  factory _$PictureThemeCopyWith(_PictureTheme value, $Res Function(_PictureTheme) _then) = __$PictureThemeCopyWithImpl;
@override @useResult
$Res call({
 KAppColor? color, BoxFit? fit, Alignment? alignment, String? semanticsLabel, bool? matchTextDirection, KAppColor? backgroundColor, double? containerHeight, double? containerWidth, EdgeInsets? containerPadding, KAppColor? borderColor, double? borderWidth, BorderRadius? borderRadius, BoxShape? shape, TextStyle? altTextStyle
});




}
/// @nodoc
class __$PictureThemeCopyWithImpl<$Res>
    implements _$PictureThemeCopyWith<$Res> {
  __$PictureThemeCopyWithImpl(this._self, this._then);

  final _PictureTheme _self;
  final $Res Function(_PictureTheme) _then;

/// Create a copy of PictureTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? color = freezed,Object? fit = freezed,Object? alignment = freezed,Object? semanticsLabel = freezed,Object? matchTextDirection = freezed,Object? backgroundColor = freezed,Object? containerHeight = freezed,Object? containerWidth = freezed,Object? containerPadding = freezed,Object? borderColor = freezed,Object? borderWidth = freezed,Object? borderRadius = freezed,Object? shape = freezed,Object? altTextStyle = freezed,}) {
  return _then(_PictureTheme(
color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as KAppColor?,fit: freezed == fit ? _self.fit : fit // ignore: cast_nullable_to_non_nullable
as BoxFit?,alignment: freezed == alignment ? _self.alignment : alignment // ignore: cast_nullable_to_non_nullable
as Alignment?,semanticsLabel: freezed == semanticsLabel ? _self.semanticsLabel : semanticsLabel // ignore: cast_nullable_to_non_nullable
as String?,matchTextDirection: freezed == matchTextDirection ? _self.matchTextDirection : matchTextDirection // ignore: cast_nullable_to_non_nullable
as bool?,backgroundColor: freezed == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,containerHeight: freezed == containerHeight ? _self.containerHeight : containerHeight // ignore: cast_nullable_to_non_nullable
as double?,containerWidth: freezed == containerWidth ? _self.containerWidth : containerWidth // ignore: cast_nullable_to_non_nullable
as double?,containerPadding: freezed == containerPadding ? _self.containerPadding : containerPadding // ignore: cast_nullable_to_non_nullable
as EdgeInsets?,borderColor: freezed == borderColor ? _self.borderColor : borderColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,borderWidth: freezed == borderWidth ? _self.borderWidth : borderWidth // ignore: cast_nullable_to_non_nullable
as double?,borderRadius: freezed == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as BorderRadius?,shape: freezed == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as BoxShape?,altTextStyle: freezed == altTextStyle ? _self.altTextStyle : altTextStyle // ignore: cast_nullable_to_non_nullable
as TextStyle?,
  ));
}


}

// dart format on
