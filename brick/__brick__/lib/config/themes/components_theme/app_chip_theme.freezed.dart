// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_chip_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomAppChipTheme {

 KAppColor get disabledColor; KAppColor get selectedColor; KAppColor get selectedLabelColor; KAppColor get disabledLabelColor; TextStyle? get labelStyle; BorderRadius? get borderRadius; EdgeInsets? get padding; double get selectedBackgroundOpacity; double get iconSize; double get svgSize; double get gap; bool get border;
/// Create a copy of CustomAppChipTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomAppChipThemeCopyWith<CustomAppChipTheme> get copyWith => _$CustomAppChipThemeCopyWithImpl<CustomAppChipTheme>(this as CustomAppChipTheme, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomAppChipTheme&&(identical(other.disabledColor, disabledColor) || other.disabledColor == disabledColor)&&(identical(other.selectedColor, selectedColor) || other.selectedColor == selectedColor)&&(identical(other.selectedLabelColor, selectedLabelColor) || other.selectedLabelColor == selectedLabelColor)&&(identical(other.disabledLabelColor, disabledLabelColor) || other.disabledLabelColor == disabledLabelColor)&&(identical(other.labelStyle, labelStyle) || other.labelStyle == labelStyle)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius)&&(identical(other.padding, padding) || other.padding == padding)&&(identical(other.selectedBackgroundOpacity, selectedBackgroundOpacity) || other.selectedBackgroundOpacity == selectedBackgroundOpacity)&&(identical(other.iconSize, iconSize) || other.iconSize == iconSize)&&(identical(other.svgSize, svgSize) || other.svgSize == svgSize)&&(identical(other.gap, gap) || other.gap == gap)&&(identical(other.border, border) || other.border == border));
}


@override
int get hashCode => Object.hash(runtimeType,disabledColor,selectedColor,selectedLabelColor,disabledLabelColor,labelStyle,borderRadius,padding,selectedBackgroundOpacity,iconSize,svgSize,gap,border);

@override
String toString() {
  return 'CustomAppChipTheme(disabledColor: $disabledColor, selectedColor: $selectedColor, selectedLabelColor: $selectedLabelColor, disabledLabelColor: $disabledLabelColor, labelStyle: $labelStyle, borderRadius: $borderRadius, padding: $padding, selectedBackgroundOpacity: $selectedBackgroundOpacity, iconSize: $iconSize, svgSize: $svgSize, gap: $gap, border: $border)';
}


}

/// @nodoc
abstract mixin class $CustomAppChipThemeCopyWith<$Res>  {
  factory $CustomAppChipThemeCopyWith(CustomAppChipTheme value, $Res Function(CustomAppChipTheme) _then) = _$CustomAppChipThemeCopyWithImpl;
@useResult
$Res call({
 KAppColor disabledColor, KAppColor selectedColor, KAppColor selectedLabelColor, KAppColor disabledLabelColor, TextStyle? labelStyle, BorderRadius? borderRadius, EdgeInsets? padding, double selectedBackgroundOpacity, double iconSize, double svgSize, double gap, bool border
});




}
/// @nodoc
class _$CustomAppChipThemeCopyWithImpl<$Res>
    implements $CustomAppChipThemeCopyWith<$Res> {
  _$CustomAppChipThemeCopyWithImpl(this._self, this._then);

  final CustomAppChipTheme _self;
  final $Res Function(CustomAppChipTheme) _then;

/// Create a copy of CustomAppChipTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? disabledColor = null,Object? selectedColor = null,Object? selectedLabelColor = null,Object? disabledLabelColor = null,Object? labelStyle = freezed,Object? borderRadius = freezed,Object? padding = freezed,Object? selectedBackgroundOpacity = null,Object? iconSize = null,Object? svgSize = null,Object? gap = null,Object? border = null,}) {
  return _then(_self.copyWith(
disabledColor: null == disabledColor ? _self.disabledColor : disabledColor // ignore: cast_nullable_to_non_nullable
as KAppColor,selectedColor: null == selectedColor ? _self.selectedColor : selectedColor // ignore: cast_nullable_to_non_nullable
as KAppColor,selectedLabelColor: null == selectedLabelColor ? _self.selectedLabelColor : selectedLabelColor // ignore: cast_nullable_to_non_nullable
as KAppColor,disabledLabelColor: null == disabledLabelColor ? _self.disabledLabelColor : disabledLabelColor // ignore: cast_nullable_to_non_nullable
as KAppColor,labelStyle: freezed == labelStyle ? _self.labelStyle : labelStyle // ignore: cast_nullable_to_non_nullable
as TextStyle?,borderRadius: freezed == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as BorderRadius?,padding: freezed == padding ? _self.padding : padding // ignore: cast_nullable_to_non_nullable
as EdgeInsets?,selectedBackgroundOpacity: null == selectedBackgroundOpacity ? _self.selectedBackgroundOpacity : selectedBackgroundOpacity // ignore: cast_nullable_to_non_nullable
as double,iconSize: null == iconSize ? _self.iconSize : iconSize // ignore: cast_nullable_to_non_nullable
as double,svgSize: null == svgSize ? _self.svgSize : svgSize // ignore: cast_nullable_to_non_nullable
as double,gap: null == gap ? _self.gap : gap // ignore: cast_nullable_to_non_nullable
as double,border: null == border ? _self.border : border // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomAppChipTheme].
extension CustomAppChipThemePatterns on CustomAppChipTheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomAppChipTheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomAppChipTheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomAppChipTheme value)  $default,){
final _that = this;
switch (_that) {
case _CustomAppChipTheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomAppChipTheme value)?  $default,){
final _that = this;
switch (_that) {
case _CustomAppChipTheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( KAppColor disabledColor,  KAppColor selectedColor,  KAppColor selectedLabelColor,  KAppColor disabledLabelColor,  TextStyle? labelStyle,  BorderRadius? borderRadius,  EdgeInsets? padding,  double selectedBackgroundOpacity,  double iconSize,  double svgSize,  double gap,  bool border)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomAppChipTheme() when $default != null:
return $default(_that.disabledColor,_that.selectedColor,_that.selectedLabelColor,_that.disabledLabelColor,_that.labelStyle,_that.borderRadius,_that.padding,_that.selectedBackgroundOpacity,_that.iconSize,_that.svgSize,_that.gap,_that.border);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( KAppColor disabledColor,  KAppColor selectedColor,  KAppColor selectedLabelColor,  KAppColor disabledLabelColor,  TextStyle? labelStyle,  BorderRadius? borderRadius,  EdgeInsets? padding,  double selectedBackgroundOpacity,  double iconSize,  double svgSize,  double gap,  bool border)  $default,) {final _that = this;
switch (_that) {
case _CustomAppChipTheme():
return $default(_that.disabledColor,_that.selectedColor,_that.selectedLabelColor,_that.disabledLabelColor,_that.labelStyle,_that.borderRadius,_that.padding,_that.selectedBackgroundOpacity,_that.iconSize,_that.svgSize,_that.gap,_that.border);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( KAppColor disabledColor,  KAppColor selectedColor,  KAppColor selectedLabelColor,  KAppColor disabledLabelColor,  TextStyle? labelStyle,  BorderRadius? borderRadius,  EdgeInsets? padding,  double selectedBackgroundOpacity,  double iconSize,  double svgSize,  double gap,  bool border)?  $default,) {final _that = this;
switch (_that) {
case _CustomAppChipTheme() when $default != null:
return $default(_that.disabledColor,_that.selectedColor,_that.selectedLabelColor,_that.disabledLabelColor,_that.labelStyle,_that.borderRadius,_that.padding,_that.selectedBackgroundOpacity,_that.iconSize,_that.svgSize,_that.gap,_that.border);case _:
  return null;

}
}

}

/// @nodoc


class _CustomAppChipTheme extends CustomAppChipTheme {
  const _CustomAppChipTheme({required this.disabledColor, required this.selectedColor, required this.selectedLabelColor, required this.disabledLabelColor, this.labelStyle, this.borderRadius, this.padding, this.selectedBackgroundOpacity = 0.2, this.iconSize = 24.0, this.svgSize = 20.0, this.gap = 8.0, this.border = false}): super._();
  

@override final  KAppColor disabledColor;
@override final  KAppColor selectedColor;
@override final  KAppColor selectedLabelColor;
@override final  KAppColor disabledLabelColor;
@override final  TextStyle? labelStyle;
@override final  BorderRadius? borderRadius;
@override final  EdgeInsets? padding;
@override@JsonKey() final  double selectedBackgroundOpacity;
@override@JsonKey() final  double iconSize;
@override@JsonKey() final  double svgSize;
@override@JsonKey() final  double gap;
@override@JsonKey() final  bool border;

/// Create a copy of CustomAppChipTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomAppChipThemeCopyWith<_CustomAppChipTheme> get copyWith => __$CustomAppChipThemeCopyWithImpl<_CustomAppChipTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomAppChipTheme&&(identical(other.disabledColor, disabledColor) || other.disabledColor == disabledColor)&&(identical(other.selectedColor, selectedColor) || other.selectedColor == selectedColor)&&(identical(other.selectedLabelColor, selectedLabelColor) || other.selectedLabelColor == selectedLabelColor)&&(identical(other.disabledLabelColor, disabledLabelColor) || other.disabledLabelColor == disabledLabelColor)&&(identical(other.labelStyle, labelStyle) || other.labelStyle == labelStyle)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius)&&(identical(other.padding, padding) || other.padding == padding)&&(identical(other.selectedBackgroundOpacity, selectedBackgroundOpacity) || other.selectedBackgroundOpacity == selectedBackgroundOpacity)&&(identical(other.iconSize, iconSize) || other.iconSize == iconSize)&&(identical(other.svgSize, svgSize) || other.svgSize == svgSize)&&(identical(other.gap, gap) || other.gap == gap)&&(identical(other.border, border) || other.border == border));
}


@override
int get hashCode => Object.hash(runtimeType,disabledColor,selectedColor,selectedLabelColor,disabledLabelColor,labelStyle,borderRadius,padding,selectedBackgroundOpacity,iconSize,svgSize,gap,border);

@override
String toString() {
  return 'CustomAppChipTheme(disabledColor: $disabledColor, selectedColor: $selectedColor, selectedLabelColor: $selectedLabelColor, disabledLabelColor: $disabledLabelColor, labelStyle: $labelStyle, borderRadius: $borderRadius, padding: $padding, selectedBackgroundOpacity: $selectedBackgroundOpacity, iconSize: $iconSize, svgSize: $svgSize, gap: $gap, border: $border)';
}


}

/// @nodoc
abstract mixin class _$CustomAppChipThemeCopyWith<$Res> implements $CustomAppChipThemeCopyWith<$Res> {
  factory _$CustomAppChipThemeCopyWith(_CustomAppChipTheme value, $Res Function(_CustomAppChipTheme) _then) = __$CustomAppChipThemeCopyWithImpl;
@override @useResult
$Res call({
 KAppColor disabledColor, KAppColor selectedColor, KAppColor selectedLabelColor, KAppColor disabledLabelColor, TextStyle? labelStyle, BorderRadius? borderRadius, EdgeInsets? padding, double selectedBackgroundOpacity, double iconSize, double svgSize, double gap, bool border
});




}
/// @nodoc
class __$CustomAppChipThemeCopyWithImpl<$Res>
    implements _$CustomAppChipThemeCopyWith<$Res> {
  __$CustomAppChipThemeCopyWithImpl(this._self, this._then);

  final _CustomAppChipTheme _self;
  final $Res Function(_CustomAppChipTheme) _then;

/// Create a copy of CustomAppChipTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? disabledColor = null,Object? selectedColor = null,Object? selectedLabelColor = null,Object? disabledLabelColor = null,Object? labelStyle = freezed,Object? borderRadius = freezed,Object? padding = freezed,Object? selectedBackgroundOpacity = null,Object? iconSize = null,Object? svgSize = null,Object? gap = null,Object? border = null,}) {
  return _then(_CustomAppChipTheme(
disabledColor: null == disabledColor ? _self.disabledColor : disabledColor // ignore: cast_nullable_to_non_nullable
as KAppColor,selectedColor: null == selectedColor ? _self.selectedColor : selectedColor // ignore: cast_nullable_to_non_nullable
as KAppColor,selectedLabelColor: null == selectedLabelColor ? _self.selectedLabelColor : selectedLabelColor // ignore: cast_nullable_to_non_nullable
as KAppColor,disabledLabelColor: null == disabledLabelColor ? _self.disabledLabelColor : disabledLabelColor // ignore: cast_nullable_to_non_nullable
as KAppColor,labelStyle: freezed == labelStyle ? _self.labelStyle : labelStyle // ignore: cast_nullable_to_non_nullable
as TextStyle?,borderRadius: freezed == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as BorderRadius?,padding: freezed == padding ? _self.padding : padding // ignore: cast_nullable_to_non_nullable
as EdgeInsets?,selectedBackgroundOpacity: null == selectedBackgroundOpacity ? _self.selectedBackgroundOpacity : selectedBackgroundOpacity // ignore: cast_nullable_to_non_nullable
as double,iconSize: null == iconSize ? _self.iconSize : iconSize // ignore: cast_nullable_to_non_nullable
as double,svgSize: null == svgSize ? _self.svgSize : svgSize // ignore: cast_nullable_to_non_nullable
as double,gap: null == gap ? _self.gap : gap // ignore: cast_nullable_to_non_nullable
as double,border: null == border ? _self.border : border // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
