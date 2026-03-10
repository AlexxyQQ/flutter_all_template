// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_button_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomButtonTheme {

 KAppColor? get backgroundColor; KAppColor? get foregroundColor; KAppColor? get backgroundDisabledColor; KAppColor? get foregroundDisabledColor; KAppColor? get labelColor; BorderRadius? get radius; EdgeInsets? get padding; bool? get showBorder; BorderSide? get border; KAppColor? get loaderColor; bool? get fixSize; bool? get expanded; bool? get translate;
/// Create a copy of CustomButtonTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomButtonThemeCopyWith<CustomButtonTheme> get copyWith => _$CustomButtonThemeCopyWithImpl<CustomButtonTheme>(this as CustomButtonTheme, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomButtonTheme&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.foregroundColor, foregroundColor) || other.foregroundColor == foregroundColor)&&(identical(other.backgroundDisabledColor, backgroundDisabledColor) || other.backgroundDisabledColor == backgroundDisabledColor)&&(identical(other.foregroundDisabledColor, foregroundDisabledColor) || other.foregroundDisabledColor == foregroundDisabledColor)&&(identical(other.labelColor, labelColor) || other.labelColor == labelColor)&&(identical(other.radius, radius) || other.radius == radius)&&(identical(other.padding, padding) || other.padding == padding)&&(identical(other.showBorder, showBorder) || other.showBorder == showBorder)&&(identical(other.border, border) || other.border == border)&&(identical(other.loaderColor, loaderColor) || other.loaderColor == loaderColor)&&(identical(other.fixSize, fixSize) || other.fixSize == fixSize)&&(identical(other.expanded, expanded) || other.expanded == expanded)&&(identical(other.translate, translate) || other.translate == translate));
}


@override
int get hashCode => Object.hash(runtimeType,backgroundColor,foregroundColor,backgroundDisabledColor,foregroundDisabledColor,labelColor,radius,padding,showBorder,border,loaderColor,fixSize,expanded,translate);

@override
String toString() {
  return 'CustomButtonTheme(backgroundColor: $backgroundColor, foregroundColor: $foregroundColor, backgroundDisabledColor: $backgroundDisabledColor, foregroundDisabledColor: $foregroundDisabledColor, labelColor: $labelColor, radius: $radius, padding: $padding, showBorder: $showBorder, border: $border, loaderColor: $loaderColor, fixSize: $fixSize, expanded: $expanded, translate: $translate)';
}


}

/// @nodoc
abstract mixin class $CustomButtonThemeCopyWith<$Res>  {
  factory $CustomButtonThemeCopyWith(CustomButtonTheme value, $Res Function(CustomButtonTheme) _then) = _$CustomButtonThemeCopyWithImpl;
@useResult
$Res call({
 KAppColor? backgroundColor, KAppColor? foregroundColor, KAppColor? backgroundDisabledColor, KAppColor? foregroundDisabledColor, KAppColor? labelColor, BorderRadius? radius, EdgeInsets? padding, bool? showBorder, BorderSide? border, KAppColor? loaderColor, bool? fixSize, bool? expanded, bool? translate
});




}
/// @nodoc
class _$CustomButtonThemeCopyWithImpl<$Res>
    implements $CustomButtonThemeCopyWith<$Res> {
  _$CustomButtonThemeCopyWithImpl(this._self, this._then);

  final CustomButtonTheme _self;
  final $Res Function(CustomButtonTheme) _then;

/// Create a copy of CustomButtonTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? backgroundColor = freezed,Object? foregroundColor = freezed,Object? backgroundDisabledColor = freezed,Object? foregroundDisabledColor = freezed,Object? labelColor = freezed,Object? radius = freezed,Object? padding = freezed,Object? showBorder = freezed,Object? border = freezed,Object? loaderColor = freezed,Object? fixSize = freezed,Object? expanded = freezed,Object? translate = freezed,}) {
  return _then(_self.copyWith(
backgroundColor: freezed == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,foregroundColor: freezed == foregroundColor ? _self.foregroundColor : foregroundColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,backgroundDisabledColor: freezed == backgroundDisabledColor ? _self.backgroundDisabledColor : backgroundDisabledColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,foregroundDisabledColor: freezed == foregroundDisabledColor ? _self.foregroundDisabledColor : foregroundDisabledColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,labelColor: freezed == labelColor ? _self.labelColor : labelColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,radius: freezed == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as BorderRadius?,padding: freezed == padding ? _self.padding : padding // ignore: cast_nullable_to_non_nullable
as EdgeInsets?,showBorder: freezed == showBorder ? _self.showBorder : showBorder // ignore: cast_nullable_to_non_nullable
as bool?,border: freezed == border ? _self.border : border // ignore: cast_nullable_to_non_nullable
as BorderSide?,loaderColor: freezed == loaderColor ? _self.loaderColor : loaderColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,fixSize: freezed == fixSize ? _self.fixSize : fixSize // ignore: cast_nullable_to_non_nullable
as bool?,expanded: freezed == expanded ? _self.expanded : expanded // ignore: cast_nullable_to_non_nullable
as bool?,translate: freezed == translate ? _self.translate : translate // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomButtonTheme].
extension CustomButtonThemePatterns on CustomButtonTheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomButtonTheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomButtonTheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomButtonTheme value)  $default,){
final _that = this;
switch (_that) {
case _CustomButtonTheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomButtonTheme value)?  $default,){
final _that = this;
switch (_that) {
case _CustomButtonTheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( KAppColor? backgroundColor,  KAppColor? foregroundColor,  KAppColor? backgroundDisabledColor,  KAppColor? foregroundDisabledColor,  KAppColor? labelColor,  BorderRadius? radius,  EdgeInsets? padding,  bool? showBorder,  BorderSide? border,  KAppColor? loaderColor,  bool? fixSize,  bool? expanded,  bool? translate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomButtonTheme() when $default != null:
return $default(_that.backgroundColor,_that.foregroundColor,_that.backgroundDisabledColor,_that.foregroundDisabledColor,_that.labelColor,_that.radius,_that.padding,_that.showBorder,_that.border,_that.loaderColor,_that.fixSize,_that.expanded,_that.translate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( KAppColor? backgroundColor,  KAppColor? foregroundColor,  KAppColor? backgroundDisabledColor,  KAppColor? foregroundDisabledColor,  KAppColor? labelColor,  BorderRadius? radius,  EdgeInsets? padding,  bool? showBorder,  BorderSide? border,  KAppColor? loaderColor,  bool? fixSize,  bool? expanded,  bool? translate)  $default,) {final _that = this;
switch (_that) {
case _CustomButtonTheme():
return $default(_that.backgroundColor,_that.foregroundColor,_that.backgroundDisabledColor,_that.foregroundDisabledColor,_that.labelColor,_that.radius,_that.padding,_that.showBorder,_that.border,_that.loaderColor,_that.fixSize,_that.expanded,_that.translate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( KAppColor? backgroundColor,  KAppColor? foregroundColor,  KAppColor? backgroundDisabledColor,  KAppColor? foregroundDisabledColor,  KAppColor? labelColor,  BorderRadius? radius,  EdgeInsets? padding,  bool? showBorder,  BorderSide? border,  KAppColor? loaderColor,  bool? fixSize,  bool? expanded,  bool? translate)?  $default,) {final _that = this;
switch (_that) {
case _CustomButtonTheme() when $default != null:
return $default(_that.backgroundColor,_that.foregroundColor,_that.backgroundDisabledColor,_that.foregroundDisabledColor,_that.labelColor,_that.radius,_that.padding,_that.showBorder,_that.border,_that.loaderColor,_that.fixSize,_that.expanded,_that.translate);case _:
  return null;

}
}

}

/// @nodoc


class _CustomButtonTheme implements CustomButtonTheme {
  const _CustomButtonTheme({this.backgroundColor, this.foregroundColor, this.backgroundDisabledColor, this.foregroundDisabledColor, this.labelColor, this.radius, this.padding, this.showBorder = false, this.border, this.loaderColor, this.fixSize = false, this.expanded = false, this.translate = true});
  

@override final  KAppColor? backgroundColor;
@override final  KAppColor? foregroundColor;
@override final  KAppColor? backgroundDisabledColor;
@override final  KAppColor? foregroundDisabledColor;
@override final  KAppColor? labelColor;
@override final  BorderRadius? radius;
@override final  EdgeInsets? padding;
@override@JsonKey() final  bool? showBorder;
@override final  BorderSide? border;
@override final  KAppColor? loaderColor;
@override@JsonKey() final  bool? fixSize;
@override@JsonKey() final  bool? expanded;
@override@JsonKey() final  bool? translate;

/// Create a copy of CustomButtonTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomButtonThemeCopyWith<_CustomButtonTheme> get copyWith => __$CustomButtonThemeCopyWithImpl<_CustomButtonTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomButtonTheme&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.foregroundColor, foregroundColor) || other.foregroundColor == foregroundColor)&&(identical(other.backgroundDisabledColor, backgroundDisabledColor) || other.backgroundDisabledColor == backgroundDisabledColor)&&(identical(other.foregroundDisabledColor, foregroundDisabledColor) || other.foregroundDisabledColor == foregroundDisabledColor)&&(identical(other.labelColor, labelColor) || other.labelColor == labelColor)&&(identical(other.radius, radius) || other.radius == radius)&&(identical(other.padding, padding) || other.padding == padding)&&(identical(other.showBorder, showBorder) || other.showBorder == showBorder)&&(identical(other.border, border) || other.border == border)&&(identical(other.loaderColor, loaderColor) || other.loaderColor == loaderColor)&&(identical(other.fixSize, fixSize) || other.fixSize == fixSize)&&(identical(other.expanded, expanded) || other.expanded == expanded)&&(identical(other.translate, translate) || other.translate == translate));
}


@override
int get hashCode => Object.hash(runtimeType,backgroundColor,foregroundColor,backgroundDisabledColor,foregroundDisabledColor,labelColor,radius,padding,showBorder,border,loaderColor,fixSize,expanded,translate);

@override
String toString() {
  return 'CustomButtonTheme(backgroundColor: $backgroundColor, foregroundColor: $foregroundColor, backgroundDisabledColor: $backgroundDisabledColor, foregroundDisabledColor: $foregroundDisabledColor, labelColor: $labelColor, radius: $radius, padding: $padding, showBorder: $showBorder, border: $border, loaderColor: $loaderColor, fixSize: $fixSize, expanded: $expanded, translate: $translate)';
}


}

/// @nodoc
abstract mixin class _$CustomButtonThemeCopyWith<$Res> implements $CustomButtonThemeCopyWith<$Res> {
  factory _$CustomButtonThemeCopyWith(_CustomButtonTheme value, $Res Function(_CustomButtonTheme) _then) = __$CustomButtonThemeCopyWithImpl;
@override @useResult
$Res call({
 KAppColor? backgroundColor, KAppColor? foregroundColor, KAppColor? backgroundDisabledColor, KAppColor? foregroundDisabledColor, KAppColor? labelColor, BorderRadius? radius, EdgeInsets? padding, bool? showBorder, BorderSide? border, KAppColor? loaderColor, bool? fixSize, bool? expanded, bool? translate
});




}
/// @nodoc
class __$CustomButtonThemeCopyWithImpl<$Res>
    implements _$CustomButtonThemeCopyWith<$Res> {
  __$CustomButtonThemeCopyWithImpl(this._self, this._then);

  final _CustomButtonTheme _self;
  final $Res Function(_CustomButtonTheme) _then;

/// Create a copy of CustomButtonTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? backgroundColor = freezed,Object? foregroundColor = freezed,Object? backgroundDisabledColor = freezed,Object? foregroundDisabledColor = freezed,Object? labelColor = freezed,Object? radius = freezed,Object? padding = freezed,Object? showBorder = freezed,Object? border = freezed,Object? loaderColor = freezed,Object? fixSize = freezed,Object? expanded = freezed,Object? translate = freezed,}) {
  return _then(_CustomButtonTheme(
backgroundColor: freezed == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,foregroundColor: freezed == foregroundColor ? _self.foregroundColor : foregroundColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,backgroundDisabledColor: freezed == backgroundDisabledColor ? _self.backgroundDisabledColor : backgroundDisabledColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,foregroundDisabledColor: freezed == foregroundDisabledColor ? _self.foregroundDisabledColor : foregroundDisabledColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,labelColor: freezed == labelColor ? _self.labelColor : labelColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,radius: freezed == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as BorderRadius?,padding: freezed == padding ? _self.padding : padding // ignore: cast_nullable_to_non_nullable
as EdgeInsets?,showBorder: freezed == showBorder ? _self.showBorder : showBorder // ignore: cast_nullable_to_non_nullable
as bool?,border: freezed == border ? _self.border : border // ignore: cast_nullable_to_non_nullable
as BorderSide?,loaderColor: freezed == loaderColor ? _self.loaderColor : loaderColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,fixSize: freezed == fixSize ? _self.fixSize : fixSize // ignore: cast_nullable_to_non_nullable
as bool?,expanded: freezed == expanded ? _self.expanded : expanded // ignore: cast_nullable_to_non_nullable
as bool?,translate: freezed == translate ? _self.translate : translate // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
