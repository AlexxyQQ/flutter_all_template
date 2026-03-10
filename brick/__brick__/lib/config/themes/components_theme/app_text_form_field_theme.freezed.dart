// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_text_form_field_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FormFieldTheme implements DiagnosticableTreeMixin {

// --- Core Configuration ---
@AppInputTypeEnumConverter() AppInputTypeEnum get inputType; Key? get key; FocusNode? get focusNode; TextEditingController? get controller;// Ideally passed to the widget, but often kept here in config objects
// --- Styling ---
 KAppColor? get fillColor; KAppColor? get disabledTextColor; TextStyle? get contentStyle; TextStyle? get hintTextStyle; TextStyle? get labelTextStyle; TextStyle? get titleStyle; TextStyle? get errorTextStyle;// --- Borders ---
 BorderRadius? get borderRadius; KAppColor? get enabledBorderColor; KAppColor? get focusedBorderColor; KAppColor? get errorBorderColor; KAppColor? get disabledBorderColor; KAppColor? get fillDisabledColor; double? get borderWidth; bool? get noBorder; bool? get isCustomBorder;// --- Layout & Icons ---
 EdgeInsetsGeometry? get contentPadding; bool? get isDense; KAppColor? get iconColor; Widget? get prefixIcon; Widget? get suffixIcon; BoxConstraints? get prefixIconConstraints;// --- Behavior ---
 bool? get readOnly; bool? get enableSuggestions; bool? get autocorrect; bool? get obscureText;// Can override the default Enum behavior
 bool? get enableIMEPersonalizedLearning; int? get maxLines; int? get minLines; int? get maxLength; int? get errorMaxLines;// --- Input Logic ---
 TextInputAction? get inputAction; List<String>? get autofillHints; List<TextInputFormatter>? get inputFormatters; TextInputType? get keyboardType; String get obscuringCharacter;// --- Validation/Requirements ---
 String get requiredCharacter; KAppColor? get requiredColor;// --- Date/Time Specifics ---
 DateTime? get minDate; DateTime? get maxDate;
/// Create a copy of FormFieldTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormFieldThemeCopyWith<FormFieldTheme> get copyWith => _$FormFieldThemeCopyWithImpl<FormFieldTheme>(this as FormFieldTheme, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FormFieldTheme'))
    ..add(DiagnosticsProperty('inputType', inputType))..add(DiagnosticsProperty('key', key))..add(DiagnosticsProperty('focusNode', focusNode))..add(DiagnosticsProperty('controller', controller))..add(DiagnosticsProperty('fillColor', fillColor))..add(DiagnosticsProperty('disabledTextColor', disabledTextColor))..add(DiagnosticsProperty('contentStyle', contentStyle))..add(DiagnosticsProperty('hintTextStyle', hintTextStyle))..add(DiagnosticsProperty('labelTextStyle', labelTextStyle))..add(DiagnosticsProperty('titleStyle', titleStyle))..add(DiagnosticsProperty('errorTextStyle', errorTextStyle))..add(DiagnosticsProperty('borderRadius', borderRadius))..add(DiagnosticsProperty('enabledBorderColor', enabledBorderColor))..add(DiagnosticsProperty('focusedBorderColor', focusedBorderColor))..add(DiagnosticsProperty('errorBorderColor', errorBorderColor))..add(DiagnosticsProperty('disabledBorderColor', disabledBorderColor))..add(DiagnosticsProperty('fillDisabledColor', fillDisabledColor))..add(DiagnosticsProperty('borderWidth', borderWidth))..add(DiagnosticsProperty('noBorder', noBorder))..add(DiagnosticsProperty('isCustomBorder', isCustomBorder))..add(DiagnosticsProperty('contentPadding', contentPadding))..add(DiagnosticsProperty('isDense', isDense))..add(DiagnosticsProperty('iconColor', iconColor))..add(DiagnosticsProperty('prefixIcon', prefixIcon))..add(DiagnosticsProperty('suffixIcon', suffixIcon))..add(DiagnosticsProperty('prefixIconConstraints', prefixIconConstraints))..add(DiagnosticsProperty('readOnly', readOnly))..add(DiagnosticsProperty('enableSuggestions', enableSuggestions))..add(DiagnosticsProperty('autocorrect', autocorrect))..add(DiagnosticsProperty('obscureText', obscureText))..add(DiagnosticsProperty('enableIMEPersonalizedLearning', enableIMEPersonalizedLearning))..add(DiagnosticsProperty('maxLines', maxLines))..add(DiagnosticsProperty('minLines', minLines))..add(DiagnosticsProperty('maxLength', maxLength))..add(DiagnosticsProperty('errorMaxLines', errorMaxLines))..add(DiagnosticsProperty('inputAction', inputAction))..add(DiagnosticsProperty('autofillHints', autofillHints))..add(DiagnosticsProperty('inputFormatters', inputFormatters))..add(DiagnosticsProperty('keyboardType', keyboardType))..add(DiagnosticsProperty('obscuringCharacter', obscuringCharacter))..add(DiagnosticsProperty('requiredCharacter', requiredCharacter))..add(DiagnosticsProperty('requiredColor', requiredColor))..add(DiagnosticsProperty('minDate', minDate))..add(DiagnosticsProperty('maxDate', maxDate));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormFieldTheme&&(identical(other.inputType, inputType) || other.inputType == inputType)&&(identical(other.key, key) || other.key == key)&&(identical(other.focusNode, focusNode) || other.focusNode == focusNode)&&(identical(other.controller, controller) || other.controller == controller)&&(identical(other.fillColor, fillColor) || other.fillColor == fillColor)&&(identical(other.disabledTextColor, disabledTextColor) || other.disabledTextColor == disabledTextColor)&&(identical(other.contentStyle, contentStyle) || other.contentStyle == contentStyle)&&(identical(other.hintTextStyle, hintTextStyle) || other.hintTextStyle == hintTextStyle)&&(identical(other.labelTextStyle, labelTextStyle) || other.labelTextStyle == labelTextStyle)&&(identical(other.titleStyle, titleStyle) || other.titleStyle == titleStyle)&&(identical(other.errorTextStyle, errorTextStyle) || other.errorTextStyle == errorTextStyle)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius)&&(identical(other.enabledBorderColor, enabledBorderColor) || other.enabledBorderColor == enabledBorderColor)&&(identical(other.focusedBorderColor, focusedBorderColor) || other.focusedBorderColor == focusedBorderColor)&&(identical(other.errorBorderColor, errorBorderColor) || other.errorBorderColor == errorBorderColor)&&(identical(other.disabledBorderColor, disabledBorderColor) || other.disabledBorderColor == disabledBorderColor)&&(identical(other.fillDisabledColor, fillDisabledColor) || other.fillDisabledColor == fillDisabledColor)&&(identical(other.borderWidth, borderWidth) || other.borderWidth == borderWidth)&&(identical(other.noBorder, noBorder) || other.noBorder == noBorder)&&(identical(other.isCustomBorder, isCustomBorder) || other.isCustomBorder == isCustomBorder)&&(identical(other.contentPadding, contentPadding) || other.contentPadding == contentPadding)&&(identical(other.isDense, isDense) || other.isDense == isDense)&&(identical(other.iconColor, iconColor) || other.iconColor == iconColor)&&(identical(other.prefixIcon, prefixIcon) || other.prefixIcon == prefixIcon)&&(identical(other.suffixIcon, suffixIcon) || other.suffixIcon == suffixIcon)&&(identical(other.prefixIconConstraints, prefixIconConstraints) || other.prefixIconConstraints == prefixIconConstraints)&&(identical(other.readOnly, readOnly) || other.readOnly == readOnly)&&(identical(other.enableSuggestions, enableSuggestions) || other.enableSuggestions == enableSuggestions)&&(identical(other.autocorrect, autocorrect) || other.autocorrect == autocorrect)&&(identical(other.obscureText, obscureText) || other.obscureText == obscureText)&&(identical(other.enableIMEPersonalizedLearning, enableIMEPersonalizedLearning) || other.enableIMEPersonalizedLearning == enableIMEPersonalizedLearning)&&(identical(other.maxLines, maxLines) || other.maxLines == maxLines)&&(identical(other.minLines, minLines) || other.minLines == minLines)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength)&&(identical(other.errorMaxLines, errorMaxLines) || other.errorMaxLines == errorMaxLines)&&(identical(other.inputAction, inputAction) || other.inputAction == inputAction)&&const DeepCollectionEquality().equals(other.autofillHints, autofillHints)&&const DeepCollectionEquality().equals(other.inputFormatters, inputFormatters)&&(identical(other.keyboardType, keyboardType) || other.keyboardType == keyboardType)&&(identical(other.obscuringCharacter, obscuringCharacter) || other.obscuringCharacter == obscuringCharacter)&&(identical(other.requiredCharacter, requiredCharacter) || other.requiredCharacter == requiredCharacter)&&(identical(other.requiredColor, requiredColor) || other.requiredColor == requiredColor)&&(identical(other.minDate, minDate) || other.minDate == minDate)&&(identical(other.maxDate, maxDate) || other.maxDate == maxDate));
}


@override
int get hashCode => Object.hashAll([runtimeType,inputType,key,focusNode,controller,fillColor,disabledTextColor,contentStyle,hintTextStyle,labelTextStyle,titleStyle,errorTextStyle,borderRadius,enabledBorderColor,focusedBorderColor,errorBorderColor,disabledBorderColor,fillDisabledColor,borderWidth,noBorder,isCustomBorder,contentPadding,isDense,iconColor,prefixIcon,suffixIcon,prefixIconConstraints,readOnly,enableSuggestions,autocorrect,obscureText,enableIMEPersonalizedLearning,maxLines,minLines,maxLength,errorMaxLines,inputAction,const DeepCollectionEquality().hash(autofillHints),const DeepCollectionEquality().hash(inputFormatters),keyboardType,obscuringCharacter,requiredCharacter,requiredColor,minDate,maxDate]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FormFieldTheme(inputType: $inputType, key: $key, focusNode: $focusNode, controller: $controller, fillColor: $fillColor, disabledTextColor: $disabledTextColor, contentStyle: $contentStyle, hintTextStyle: $hintTextStyle, labelTextStyle: $labelTextStyle, titleStyle: $titleStyle, errorTextStyle: $errorTextStyle, borderRadius: $borderRadius, enabledBorderColor: $enabledBorderColor, focusedBorderColor: $focusedBorderColor, errorBorderColor: $errorBorderColor, disabledBorderColor: $disabledBorderColor, fillDisabledColor: $fillDisabledColor, borderWidth: $borderWidth, noBorder: $noBorder, isCustomBorder: $isCustomBorder, contentPadding: $contentPadding, isDense: $isDense, iconColor: $iconColor, prefixIcon: $prefixIcon, suffixIcon: $suffixIcon, prefixIconConstraints: $prefixIconConstraints, readOnly: $readOnly, enableSuggestions: $enableSuggestions, autocorrect: $autocorrect, obscureText: $obscureText, enableIMEPersonalizedLearning: $enableIMEPersonalizedLearning, maxLines: $maxLines, minLines: $minLines, maxLength: $maxLength, errorMaxLines: $errorMaxLines, inputAction: $inputAction, autofillHints: $autofillHints, inputFormatters: $inputFormatters, keyboardType: $keyboardType, obscuringCharacter: $obscuringCharacter, requiredCharacter: $requiredCharacter, requiredColor: $requiredColor, minDate: $minDate, maxDate: $maxDate)';
}


}

/// @nodoc
abstract mixin class $FormFieldThemeCopyWith<$Res>  {
  factory $FormFieldThemeCopyWith(FormFieldTheme value, $Res Function(FormFieldTheme) _then) = _$FormFieldThemeCopyWithImpl;
@useResult
$Res call({
@AppInputTypeEnumConverter() AppInputTypeEnum inputType, Key? key, FocusNode? focusNode, TextEditingController? controller, KAppColor? fillColor, KAppColor? disabledTextColor, TextStyle? contentStyle, TextStyle? hintTextStyle, TextStyle? labelTextStyle, TextStyle? titleStyle, TextStyle? errorTextStyle, BorderRadius? borderRadius, KAppColor? enabledBorderColor, KAppColor? focusedBorderColor, KAppColor? errorBorderColor, KAppColor? disabledBorderColor, KAppColor? fillDisabledColor, double? borderWidth, bool? noBorder, bool? isCustomBorder, EdgeInsetsGeometry? contentPadding, bool? isDense, KAppColor? iconColor, Widget? prefixIcon, Widget? suffixIcon, BoxConstraints? prefixIconConstraints, bool? readOnly, bool? enableSuggestions, bool? autocorrect, bool? obscureText, bool? enableIMEPersonalizedLearning, int? maxLines, int? minLines, int? maxLength, int? errorMaxLines, TextInputAction? inputAction, List<String>? autofillHints, List<TextInputFormatter>? inputFormatters, TextInputType? keyboardType, String obscuringCharacter, String requiredCharacter, KAppColor? requiredColor, DateTime? minDate, DateTime? maxDate
});




}
/// @nodoc
class _$FormFieldThemeCopyWithImpl<$Res>
    implements $FormFieldThemeCopyWith<$Res> {
  _$FormFieldThemeCopyWithImpl(this._self, this._then);

  final FormFieldTheme _self;
  final $Res Function(FormFieldTheme) _then;

/// Create a copy of FormFieldTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inputType = null,Object? key = freezed,Object? focusNode = freezed,Object? controller = freezed,Object? fillColor = freezed,Object? disabledTextColor = freezed,Object? contentStyle = freezed,Object? hintTextStyle = freezed,Object? labelTextStyle = freezed,Object? titleStyle = freezed,Object? errorTextStyle = freezed,Object? borderRadius = freezed,Object? enabledBorderColor = freezed,Object? focusedBorderColor = freezed,Object? errorBorderColor = freezed,Object? disabledBorderColor = freezed,Object? fillDisabledColor = freezed,Object? borderWidth = freezed,Object? noBorder = freezed,Object? isCustomBorder = freezed,Object? contentPadding = freezed,Object? isDense = freezed,Object? iconColor = freezed,Object? prefixIcon = freezed,Object? suffixIcon = freezed,Object? prefixIconConstraints = freezed,Object? readOnly = freezed,Object? enableSuggestions = freezed,Object? autocorrect = freezed,Object? obscureText = freezed,Object? enableIMEPersonalizedLearning = freezed,Object? maxLines = freezed,Object? minLines = freezed,Object? maxLength = freezed,Object? errorMaxLines = freezed,Object? inputAction = freezed,Object? autofillHints = freezed,Object? inputFormatters = freezed,Object? keyboardType = freezed,Object? obscuringCharacter = null,Object? requiredCharacter = null,Object? requiredColor = freezed,Object? minDate = freezed,Object? maxDate = freezed,}) {
  return _then(_self.copyWith(
inputType: null == inputType ? _self.inputType : inputType // ignore: cast_nullable_to_non_nullable
as AppInputTypeEnum,key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as Key?,focusNode: freezed == focusNode ? _self.focusNode : focusNode // ignore: cast_nullable_to_non_nullable
as FocusNode?,controller: freezed == controller ? _self.controller : controller // ignore: cast_nullable_to_non_nullable
as TextEditingController?,fillColor: freezed == fillColor ? _self.fillColor : fillColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,disabledTextColor: freezed == disabledTextColor ? _self.disabledTextColor : disabledTextColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,contentStyle: freezed == contentStyle ? _self.contentStyle : contentStyle // ignore: cast_nullable_to_non_nullable
as TextStyle?,hintTextStyle: freezed == hintTextStyle ? _self.hintTextStyle : hintTextStyle // ignore: cast_nullable_to_non_nullable
as TextStyle?,labelTextStyle: freezed == labelTextStyle ? _self.labelTextStyle : labelTextStyle // ignore: cast_nullable_to_non_nullable
as TextStyle?,titleStyle: freezed == titleStyle ? _self.titleStyle : titleStyle // ignore: cast_nullable_to_non_nullable
as TextStyle?,errorTextStyle: freezed == errorTextStyle ? _self.errorTextStyle : errorTextStyle // ignore: cast_nullable_to_non_nullable
as TextStyle?,borderRadius: freezed == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as BorderRadius?,enabledBorderColor: freezed == enabledBorderColor ? _self.enabledBorderColor : enabledBorderColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,focusedBorderColor: freezed == focusedBorderColor ? _self.focusedBorderColor : focusedBorderColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,errorBorderColor: freezed == errorBorderColor ? _self.errorBorderColor : errorBorderColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,disabledBorderColor: freezed == disabledBorderColor ? _self.disabledBorderColor : disabledBorderColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,fillDisabledColor: freezed == fillDisabledColor ? _self.fillDisabledColor : fillDisabledColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,borderWidth: freezed == borderWidth ? _self.borderWidth : borderWidth // ignore: cast_nullable_to_non_nullable
as double?,noBorder: freezed == noBorder ? _self.noBorder : noBorder // ignore: cast_nullable_to_non_nullable
as bool?,isCustomBorder: freezed == isCustomBorder ? _self.isCustomBorder : isCustomBorder // ignore: cast_nullable_to_non_nullable
as bool?,contentPadding: freezed == contentPadding ? _self.contentPadding : contentPadding // ignore: cast_nullable_to_non_nullable
as EdgeInsetsGeometry?,isDense: freezed == isDense ? _self.isDense : isDense // ignore: cast_nullable_to_non_nullable
as bool?,iconColor: freezed == iconColor ? _self.iconColor : iconColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,prefixIcon: freezed == prefixIcon ? _self.prefixIcon : prefixIcon // ignore: cast_nullable_to_non_nullable
as Widget?,suffixIcon: freezed == suffixIcon ? _self.suffixIcon : suffixIcon // ignore: cast_nullable_to_non_nullable
as Widget?,prefixIconConstraints: freezed == prefixIconConstraints ? _self.prefixIconConstraints : prefixIconConstraints // ignore: cast_nullable_to_non_nullable
as BoxConstraints?,readOnly: freezed == readOnly ? _self.readOnly : readOnly // ignore: cast_nullable_to_non_nullable
as bool?,enableSuggestions: freezed == enableSuggestions ? _self.enableSuggestions : enableSuggestions // ignore: cast_nullable_to_non_nullable
as bool?,autocorrect: freezed == autocorrect ? _self.autocorrect : autocorrect // ignore: cast_nullable_to_non_nullable
as bool?,obscureText: freezed == obscureText ? _self.obscureText : obscureText // ignore: cast_nullable_to_non_nullable
as bool?,enableIMEPersonalizedLearning: freezed == enableIMEPersonalizedLearning ? _self.enableIMEPersonalizedLearning : enableIMEPersonalizedLearning // ignore: cast_nullable_to_non_nullable
as bool?,maxLines: freezed == maxLines ? _self.maxLines : maxLines // ignore: cast_nullable_to_non_nullable
as int?,minLines: freezed == minLines ? _self.minLines : minLines // ignore: cast_nullable_to_non_nullable
as int?,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,errorMaxLines: freezed == errorMaxLines ? _self.errorMaxLines : errorMaxLines // ignore: cast_nullable_to_non_nullable
as int?,inputAction: freezed == inputAction ? _self.inputAction : inputAction // ignore: cast_nullable_to_non_nullable
as TextInputAction?,autofillHints: freezed == autofillHints ? _self.autofillHints : autofillHints // ignore: cast_nullable_to_non_nullable
as List<String>?,inputFormatters: freezed == inputFormatters ? _self.inputFormatters : inputFormatters // ignore: cast_nullable_to_non_nullable
as List<TextInputFormatter>?,keyboardType: freezed == keyboardType ? _self.keyboardType : keyboardType // ignore: cast_nullable_to_non_nullable
as TextInputType?,obscuringCharacter: null == obscuringCharacter ? _self.obscuringCharacter : obscuringCharacter // ignore: cast_nullable_to_non_nullable
as String,requiredCharacter: null == requiredCharacter ? _self.requiredCharacter : requiredCharacter // ignore: cast_nullable_to_non_nullable
as String,requiredColor: freezed == requiredColor ? _self.requiredColor : requiredColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,minDate: freezed == minDate ? _self.minDate : minDate // ignore: cast_nullable_to_non_nullable
as DateTime?,maxDate: freezed == maxDate ? _self.maxDate : maxDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FormFieldTheme].
extension FormFieldThemePatterns on FormFieldTheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormFieldTheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormFieldTheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormFieldTheme value)  $default,){
final _that = this;
switch (_that) {
case _FormFieldTheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormFieldTheme value)?  $default,){
final _that = this;
switch (_that) {
case _FormFieldTheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@AppInputTypeEnumConverter()  AppInputTypeEnum inputType,  Key? key,  FocusNode? focusNode,  TextEditingController? controller,  KAppColor? fillColor,  KAppColor? disabledTextColor,  TextStyle? contentStyle,  TextStyle? hintTextStyle,  TextStyle? labelTextStyle,  TextStyle? titleStyle,  TextStyle? errorTextStyle,  BorderRadius? borderRadius,  KAppColor? enabledBorderColor,  KAppColor? focusedBorderColor,  KAppColor? errorBorderColor,  KAppColor? disabledBorderColor,  KAppColor? fillDisabledColor,  double? borderWidth,  bool? noBorder,  bool? isCustomBorder,  EdgeInsetsGeometry? contentPadding,  bool? isDense,  KAppColor? iconColor,  Widget? prefixIcon,  Widget? suffixIcon,  BoxConstraints? prefixIconConstraints,  bool? readOnly,  bool? enableSuggestions,  bool? autocorrect,  bool? obscureText,  bool? enableIMEPersonalizedLearning,  int? maxLines,  int? minLines,  int? maxLength,  int? errorMaxLines,  TextInputAction? inputAction,  List<String>? autofillHints,  List<TextInputFormatter>? inputFormatters,  TextInputType? keyboardType,  String obscuringCharacter,  String requiredCharacter,  KAppColor? requiredColor,  DateTime? minDate,  DateTime? maxDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormFieldTheme() when $default != null:
return $default(_that.inputType,_that.key,_that.focusNode,_that.controller,_that.fillColor,_that.disabledTextColor,_that.contentStyle,_that.hintTextStyle,_that.labelTextStyle,_that.titleStyle,_that.errorTextStyle,_that.borderRadius,_that.enabledBorderColor,_that.focusedBorderColor,_that.errorBorderColor,_that.disabledBorderColor,_that.fillDisabledColor,_that.borderWidth,_that.noBorder,_that.isCustomBorder,_that.contentPadding,_that.isDense,_that.iconColor,_that.prefixIcon,_that.suffixIcon,_that.prefixIconConstraints,_that.readOnly,_that.enableSuggestions,_that.autocorrect,_that.obscureText,_that.enableIMEPersonalizedLearning,_that.maxLines,_that.minLines,_that.maxLength,_that.errorMaxLines,_that.inputAction,_that.autofillHints,_that.inputFormatters,_that.keyboardType,_that.obscuringCharacter,_that.requiredCharacter,_that.requiredColor,_that.minDate,_that.maxDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@AppInputTypeEnumConverter()  AppInputTypeEnum inputType,  Key? key,  FocusNode? focusNode,  TextEditingController? controller,  KAppColor? fillColor,  KAppColor? disabledTextColor,  TextStyle? contentStyle,  TextStyle? hintTextStyle,  TextStyle? labelTextStyle,  TextStyle? titleStyle,  TextStyle? errorTextStyle,  BorderRadius? borderRadius,  KAppColor? enabledBorderColor,  KAppColor? focusedBorderColor,  KAppColor? errorBorderColor,  KAppColor? disabledBorderColor,  KAppColor? fillDisabledColor,  double? borderWidth,  bool? noBorder,  bool? isCustomBorder,  EdgeInsetsGeometry? contentPadding,  bool? isDense,  KAppColor? iconColor,  Widget? prefixIcon,  Widget? suffixIcon,  BoxConstraints? prefixIconConstraints,  bool? readOnly,  bool? enableSuggestions,  bool? autocorrect,  bool? obscureText,  bool? enableIMEPersonalizedLearning,  int? maxLines,  int? minLines,  int? maxLength,  int? errorMaxLines,  TextInputAction? inputAction,  List<String>? autofillHints,  List<TextInputFormatter>? inputFormatters,  TextInputType? keyboardType,  String obscuringCharacter,  String requiredCharacter,  KAppColor? requiredColor,  DateTime? minDate,  DateTime? maxDate)  $default,) {final _that = this;
switch (_that) {
case _FormFieldTheme():
return $default(_that.inputType,_that.key,_that.focusNode,_that.controller,_that.fillColor,_that.disabledTextColor,_that.contentStyle,_that.hintTextStyle,_that.labelTextStyle,_that.titleStyle,_that.errorTextStyle,_that.borderRadius,_that.enabledBorderColor,_that.focusedBorderColor,_that.errorBorderColor,_that.disabledBorderColor,_that.fillDisabledColor,_that.borderWidth,_that.noBorder,_that.isCustomBorder,_that.contentPadding,_that.isDense,_that.iconColor,_that.prefixIcon,_that.suffixIcon,_that.prefixIconConstraints,_that.readOnly,_that.enableSuggestions,_that.autocorrect,_that.obscureText,_that.enableIMEPersonalizedLearning,_that.maxLines,_that.minLines,_that.maxLength,_that.errorMaxLines,_that.inputAction,_that.autofillHints,_that.inputFormatters,_that.keyboardType,_that.obscuringCharacter,_that.requiredCharacter,_that.requiredColor,_that.minDate,_that.maxDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@AppInputTypeEnumConverter()  AppInputTypeEnum inputType,  Key? key,  FocusNode? focusNode,  TextEditingController? controller,  KAppColor? fillColor,  KAppColor? disabledTextColor,  TextStyle? contentStyle,  TextStyle? hintTextStyle,  TextStyle? labelTextStyle,  TextStyle? titleStyle,  TextStyle? errorTextStyle,  BorderRadius? borderRadius,  KAppColor? enabledBorderColor,  KAppColor? focusedBorderColor,  KAppColor? errorBorderColor,  KAppColor? disabledBorderColor,  KAppColor? fillDisabledColor,  double? borderWidth,  bool? noBorder,  bool? isCustomBorder,  EdgeInsetsGeometry? contentPadding,  bool? isDense,  KAppColor? iconColor,  Widget? prefixIcon,  Widget? suffixIcon,  BoxConstraints? prefixIconConstraints,  bool? readOnly,  bool? enableSuggestions,  bool? autocorrect,  bool? obscureText,  bool? enableIMEPersonalizedLearning,  int? maxLines,  int? minLines,  int? maxLength,  int? errorMaxLines,  TextInputAction? inputAction,  List<String>? autofillHints,  List<TextInputFormatter>? inputFormatters,  TextInputType? keyboardType,  String obscuringCharacter,  String requiredCharacter,  KAppColor? requiredColor,  DateTime? minDate,  DateTime? maxDate)?  $default,) {final _that = this;
switch (_that) {
case _FormFieldTheme() when $default != null:
return $default(_that.inputType,_that.key,_that.focusNode,_that.controller,_that.fillColor,_that.disabledTextColor,_that.contentStyle,_that.hintTextStyle,_that.labelTextStyle,_that.titleStyle,_that.errorTextStyle,_that.borderRadius,_that.enabledBorderColor,_that.focusedBorderColor,_that.errorBorderColor,_that.disabledBorderColor,_that.fillDisabledColor,_that.borderWidth,_that.noBorder,_that.isCustomBorder,_that.contentPadding,_that.isDense,_that.iconColor,_that.prefixIcon,_that.suffixIcon,_that.prefixIconConstraints,_that.readOnly,_that.enableSuggestions,_that.autocorrect,_that.obscureText,_that.enableIMEPersonalizedLearning,_that.maxLines,_that.minLines,_that.maxLength,_that.errorMaxLines,_that.inputAction,_that.autofillHints,_that.inputFormatters,_that.keyboardType,_that.obscuringCharacter,_that.requiredCharacter,_that.requiredColor,_that.minDate,_that.maxDate);case _:
  return null;

}
}

}

/// @nodoc


class _FormFieldTheme extends FormFieldTheme with DiagnosticableTreeMixin {
   _FormFieldTheme({@AppInputTypeEnumConverter() this.inputType = AppInputTypeEnum.text, this.key, this.focusNode, this.controller, this.fillColor, this.disabledTextColor, this.contentStyle, this.hintTextStyle, this.labelTextStyle, this.titleStyle, this.errorTextStyle, this.borderRadius, this.enabledBorderColor, this.focusedBorderColor, this.errorBorderColor, this.disabledBorderColor, this.fillDisabledColor, this.borderWidth, this.noBorder, this.isCustomBorder, this.contentPadding, this.isDense, this.iconColor, this.prefixIcon, this.suffixIcon, this.prefixIconConstraints, this.readOnly, this.enableSuggestions, this.autocorrect, this.obscureText, this.enableIMEPersonalizedLearning, this.maxLines, this.minLines, this.maxLength, this.errorMaxLines, this.inputAction, final  List<String>? autofillHints, final  List<TextInputFormatter>? inputFormatters, this.keyboardType, this.obscuringCharacter = '*', this.requiredCharacter = '*', this.requiredColor = AppMaterialPrimitives.error50, this.minDate, this.maxDate}): _autofillHints = autofillHints,_inputFormatters = inputFormatters,super._();
  

// --- Core Configuration ---
@override@JsonKey()@AppInputTypeEnumConverter() final  AppInputTypeEnum inputType;
@override final  Key? key;
@override final  FocusNode? focusNode;
@override final  TextEditingController? controller;
// Ideally passed to the widget, but often kept here in config objects
// --- Styling ---
@override final  KAppColor? fillColor;
@override final  KAppColor? disabledTextColor;
@override final  TextStyle? contentStyle;
@override final  TextStyle? hintTextStyle;
@override final  TextStyle? labelTextStyle;
@override final  TextStyle? titleStyle;
@override final  TextStyle? errorTextStyle;
// --- Borders ---
@override final  BorderRadius? borderRadius;
@override final  KAppColor? enabledBorderColor;
@override final  KAppColor? focusedBorderColor;
@override final  KAppColor? errorBorderColor;
@override final  KAppColor? disabledBorderColor;
@override final  KAppColor? fillDisabledColor;
@override final  double? borderWidth;
@override final  bool? noBorder;
@override final  bool? isCustomBorder;
// --- Layout & Icons ---
@override final  EdgeInsetsGeometry? contentPadding;
@override final  bool? isDense;
@override final  KAppColor? iconColor;
@override final  Widget? prefixIcon;
@override final  Widget? suffixIcon;
@override final  BoxConstraints? prefixIconConstraints;
// --- Behavior ---
@override final  bool? readOnly;
@override final  bool? enableSuggestions;
@override final  bool? autocorrect;
@override final  bool? obscureText;
// Can override the default Enum behavior
@override final  bool? enableIMEPersonalizedLearning;
@override final  int? maxLines;
@override final  int? minLines;
@override final  int? maxLength;
@override final  int? errorMaxLines;
// --- Input Logic ---
@override final  TextInputAction? inputAction;
 final  List<String>? _autofillHints;
@override List<String>? get autofillHints {
  final value = _autofillHints;
  if (value == null) return null;
  if (_autofillHints is EqualUnmodifiableListView) return _autofillHints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<TextInputFormatter>? _inputFormatters;
@override List<TextInputFormatter>? get inputFormatters {
  final value = _inputFormatters;
  if (value == null) return null;
  if (_inputFormatters is EqualUnmodifiableListView) return _inputFormatters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  TextInputType? keyboardType;
@override@JsonKey() final  String obscuringCharacter;
// --- Validation/Requirements ---
@override@JsonKey() final  String requiredCharacter;
@override@JsonKey() final  KAppColor? requiredColor;
// --- Date/Time Specifics ---
@override final  DateTime? minDate;
@override final  DateTime? maxDate;

/// Create a copy of FormFieldTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormFieldThemeCopyWith<_FormFieldTheme> get copyWith => __$FormFieldThemeCopyWithImpl<_FormFieldTheme>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FormFieldTheme'))
    ..add(DiagnosticsProperty('inputType', inputType))..add(DiagnosticsProperty('key', key))..add(DiagnosticsProperty('focusNode', focusNode))..add(DiagnosticsProperty('controller', controller))..add(DiagnosticsProperty('fillColor', fillColor))..add(DiagnosticsProperty('disabledTextColor', disabledTextColor))..add(DiagnosticsProperty('contentStyle', contentStyle))..add(DiagnosticsProperty('hintTextStyle', hintTextStyle))..add(DiagnosticsProperty('labelTextStyle', labelTextStyle))..add(DiagnosticsProperty('titleStyle', titleStyle))..add(DiagnosticsProperty('errorTextStyle', errorTextStyle))..add(DiagnosticsProperty('borderRadius', borderRadius))..add(DiagnosticsProperty('enabledBorderColor', enabledBorderColor))..add(DiagnosticsProperty('focusedBorderColor', focusedBorderColor))..add(DiagnosticsProperty('errorBorderColor', errorBorderColor))..add(DiagnosticsProperty('disabledBorderColor', disabledBorderColor))..add(DiagnosticsProperty('fillDisabledColor', fillDisabledColor))..add(DiagnosticsProperty('borderWidth', borderWidth))..add(DiagnosticsProperty('noBorder', noBorder))..add(DiagnosticsProperty('isCustomBorder', isCustomBorder))..add(DiagnosticsProperty('contentPadding', contentPadding))..add(DiagnosticsProperty('isDense', isDense))..add(DiagnosticsProperty('iconColor', iconColor))..add(DiagnosticsProperty('prefixIcon', prefixIcon))..add(DiagnosticsProperty('suffixIcon', suffixIcon))..add(DiagnosticsProperty('prefixIconConstraints', prefixIconConstraints))..add(DiagnosticsProperty('readOnly', readOnly))..add(DiagnosticsProperty('enableSuggestions', enableSuggestions))..add(DiagnosticsProperty('autocorrect', autocorrect))..add(DiagnosticsProperty('obscureText', obscureText))..add(DiagnosticsProperty('enableIMEPersonalizedLearning', enableIMEPersonalizedLearning))..add(DiagnosticsProperty('maxLines', maxLines))..add(DiagnosticsProperty('minLines', minLines))..add(DiagnosticsProperty('maxLength', maxLength))..add(DiagnosticsProperty('errorMaxLines', errorMaxLines))..add(DiagnosticsProperty('inputAction', inputAction))..add(DiagnosticsProperty('autofillHints', autofillHints))..add(DiagnosticsProperty('inputFormatters', inputFormatters))..add(DiagnosticsProperty('keyboardType', keyboardType))..add(DiagnosticsProperty('obscuringCharacter', obscuringCharacter))..add(DiagnosticsProperty('requiredCharacter', requiredCharacter))..add(DiagnosticsProperty('requiredColor', requiredColor))..add(DiagnosticsProperty('minDate', minDate))..add(DiagnosticsProperty('maxDate', maxDate));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormFieldTheme&&(identical(other.inputType, inputType) || other.inputType == inputType)&&(identical(other.key, key) || other.key == key)&&(identical(other.focusNode, focusNode) || other.focusNode == focusNode)&&(identical(other.controller, controller) || other.controller == controller)&&(identical(other.fillColor, fillColor) || other.fillColor == fillColor)&&(identical(other.disabledTextColor, disabledTextColor) || other.disabledTextColor == disabledTextColor)&&(identical(other.contentStyle, contentStyle) || other.contentStyle == contentStyle)&&(identical(other.hintTextStyle, hintTextStyle) || other.hintTextStyle == hintTextStyle)&&(identical(other.labelTextStyle, labelTextStyle) || other.labelTextStyle == labelTextStyle)&&(identical(other.titleStyle, titleStyle) || other.titleStyle == titleStyle)&&(identical(other.errorTextStyle, errorTextStyle) || other.errorTextStyle == errorTextStyle)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius)&&(identical(other.enabledBorderColor, enabledBorderColor) || other.enabledBorderColor == enabledBorderColor)&&(identical(other.focusedBorderColor, focusedBorderColor) || other.focusedBorderColor == focusedBorderColor)&&(identical(other.errorBorderColor, errorBorderColor) || other.errorBorderColor == errorBorderColor)&&(identical(other.disabledBorderColor, disabledBorderColor) || other.disabledBorderColor == disabledBorderColor)&&(identical(other.fillDisabledColor, fillDisabledColor) || other.fillDisabledColor == fillDisabledColor)&&(identical(other.borderWidth, borderWidth) || other.borderWidth == borderWidth)&&(identical(other.noBorder, noBorder) || other.noBorder == noBorder)&&(identical(other.isCustomBorder, isCustomBorder) || other.isCustomBorder == isCustomBorder)&&(identical(other.contentPadding, contentPadding) || other.contentPadding == contentPadding)&&(identical(other.isDense, isDense) || other.isDense == isDense)&&(identical(other.iconColor, iconColor) || other.iconColor == iconColor)&&(identical(other.prefixIcon, prefixIcon) || other.prefixIcon == prefixIcon)&&(identical(other.suffixIcon, suffixIcon) || other.suffixIcon == suffixIcon)&&(identical(other.prefixIconConstraints, prefixIconConstraints) || other.prefixIconConstraints == prefixIconConstraints)&&(identical(other.readOnly, readOnly) || other.readOnly == readOnly)&&(identical(other.enableSuggestions, enableSuggestions) || other.enableSuggestions == enableSuggestions)&&(identical(other.autocorrect, autocorrect) || other.autocorrect == autocorrect)&&(identical(other.obscureText, obscureText) || other.obscureText == obscureText)&&(identical(other.enableIMEPersonalizedLearning, enableIMEPersonalizedLearning) || other.enableIMEPersonalizedLearning == enableIMEPersonalizedLearning)&&(identical(other.maxLines, maxLines) || other.maxLines == maxLines)&&(identical(other.minLines, minLines) || other.minLines == minLines)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength)&&(identical(other.errorMaxLines, errorMaxLines) || other.errorMaxLines == errorMaxLines)&&(identical(other.inputAction, inputAction) || other.inputAction == inputAction)&&const DeepCollectionEquality().equals(other._autofillHints, _autofillHints)&&const DeepCollectionEquality().equals(other._inputFormatters, _inputFormatters)&&(identical(other.keyboardType, keyboardType) || other.keyboardType == keyboardType)&&(identical(other.obscuringCharacter, obscuringCharacter) || other.obscuringCharacter == obscuringCharacter)&&(identical(other.requiredCharacter, requiredCharacter) || other.requiredCharacter == requiredCharacter)&&(identical(other.requiredColor, requiredColor) || other.requiredColor == requiredColor)&&(identical(other.minDate, minDate) || other.minDate == minDate)&&(identical(other.maxDate, maxDate) || other.maxDate == maxDate));
}


@override
int get hashCode => Object.hashAll([runtimeType,inputType,key,focusNode,controller,fillColor,disabledTextColor,contentStyle,hintTextStyle,labelTextStyle,titleStyle,errorTextStyle,borderRadius,enabledBorderColor,focusedBorderColor,errorBorderColor,disabledBorderColor,fillDisabledColor,borderWidth,noBorder,isCustomBorder,contentPadding,isDense,iconColor,prefixIcon,suffixIcon,prefixIconConstraints,readOnly,enableSuggestions,autocorrect,obscureText,enableIMEPersonalizedLearning,maxLines,minLines,maxLength,errorMaxLines,inputAction,const DeepCollectionEquality().hash(_autofillHints),const DeepCollectionEquality().hash(_inputFormatters),keyboardType,obscuringCharacter,requiredCharacter,requiredColor,minDate,maxDate]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FormFieldTheme(inputType: $inputType, key: $key, focusNode: $focusNode, controller: $controller, fillColor: $fillColor, disabledTextColor: $disabledTextColor, contentStyle: $contentStyle, hintTextStyle: $hintTextStyle, labelTextStyle: $labelTextStyle, titleStyle: $titleStyle, errorTextStyle: $errorTextStyle, borderRadius: $borderRadius, enabledBorderColor: $enabledBorderColor, focusedBorderColor: $focusedBorderColor, errorBorderColor: $errorBorderColor, disabledBorderColor: $disabledBorderColor, fillDisabledColor: $fillDisabledColor, borderWidth: $borderWidth, noBorder: $noBorder, isCustomBorder: $isCustomBorder, contentPadding: $contentPadding, isDense: $isDense, iconColor: $iconColor, prefixIcon: $prefixIcon, suffixIcon: $suffixIcon, prefixIconConstraints: $prefixIconConstraints, readOnly: $readOnly, enableSuggestions: $enableSuggestions, autocorrect: $autocorrect, obscureText: $obscureText, enableIMEPersonalizedLearning: $enableIMEPersonalizedLearning, maxLines: $maxLines, minLines: $minLines, maxLength: $maxLength, errorMaxLines: $errorMaxLines, inputAction: $inputAction, autofillHints: $autofillHints, inputFormatters: $inputFormatters, keyboardType: $keyboardType, obscuringCharacter: $obscuringCharacter, requiredCharacter: $requiredCharacter, requiredColor: $requiredColor, minDate: $minDate, maxDate: $maxDate)';
}


}

/// @nodoc
abstract mixin class _$FormFieldThemeCopyWith<$Res> implements $FormFieldThemeCopyWith<$Res> {
  factory _$FormFieldThemeCopyWith(_FormFieldTheme value, $Res Function(_FormFieldTheme) _then) = __$FormFieldThemeCopyWithImpl;
@override @useResult
$Res call({
@AppInputTypeEnumConverter() AppInputTypeEnum inputType, Key? key, FocusNode? focusNode, TextEditingController? controller, KAppColor? fillColor, KAppColor? disabledTextColor, TextStyle? contentStyle, TextStyle? hintTextStyle, TextStyle? labelTextStyle, TextStyle? titleStyle, TextStyle? errorTextStyle, BorderRadius? borderRadius, KAppColor? enabledBorderColor, KAppColor? focusedBorderColor, KAppColor? errorBorderColor, KAppColor? disabledBorderColor, KAppColor? fillDisabledColor, double? borderWidth, bool? noBorder, bool? isCustomBorder, EdgeInsetsGeometry? contentPadding, bool? isDense, KAppColor? iconColor, Widget? prefixIcon, Widget? suffixIcon, BoxConstraints? prefixIconConstraints, bool? readOnly, bool? enableSuggestions, bool? autocorrect, bool? obscureText, bool? enableIMEPersonalizedLearning, int? maxLines, int? minLines, int? maxLength, int? errorMaxLines, TextInputAction? inputAction, List<String>? autofillHints, List<TextInputFormatter>? inputFormatters, TextInputType? keyboardType, String obscuringCharacter, String requiredCharacter, KAppColor? requiredColor, DateTime? minDate, DateTime? maxDate
});




}
/// @nodoc
class __$FormFieldThemeCopyWithImpl<$Res>
    implements _$FormFieldThemeCopyWith<$Res> {
  __$FormFieldThemeCopyWithImpl(this._self, this._then);

  final _FormFieldTheme _self;
  final $Res Function(_FormFieldTheme) _then;

/// Create a copy of FormFieldTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inputType = null,Object? key = freezed,Object? focusNode = freezed,Object? controller = freezed,Object? fillColor = freezed,Object? disabledTextColor = freezed,Object? contentStyle = freezed,Object? hintTextStyle = freezed,Object? labelTextStyle = freezed,Object? titleStyle = freezed,Object? errorTextStyle = freezed,Object? borderRadius = freezed,Object? enabledBorderColor = freezed,Object? focusedBorderColor = freezed,Object? errorBorderColor = freezed,Object? disabledBorderColor = freezed,Object? fillDisabledColor = freezed,Object? borderWidth = freezed,Object? noBorder = freezed,Object? isCustomBorder = freezed,Object? contentPadding = freezed,Object? isDense = freezed,Object? iconColor = freezed,Object? prefixIcon = freezed,Object? suffixIcon = freezed,Object? prefixIconConstraints = freezed,Object? readOnly = freezed,Object? enableSuggestions = freezed,Object? autocorrect = freezed,Object? obscureText = freezed,Object? enableIMEPersonalizedLearning = freezed,Object? maxLines = freezed,Object? minLines = freezed,Object? maxLength = freezed,Object? errorMaxLines = freezed,Object? inputAction = freezed,Object? autofillHints = freezed,Object? inputFormatters = freezed,Object? keyboardType = freezed,Object? obscuringCharacter = null,Object? requiredCharacter = null,Object? requiredColor = freezed,Object? minDate = freezed,Object? maxDate = freezed,}) {
  return _then(_FormFieldTheme(
inputType: null == inputType ? _self.inputType : inputType // ignore: cast_nullable_to_non_nullable
as AppInputTypeEnum,key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as Key?,focusNode: freezed == focusNode ? _self.focusNode : focusNode // ignore: cast_nullable_to_non_nullable
as FocusNode?,controller: freezed == controller ? _self.controller : controller // ignore: cast_nullable_to_non_nullable
as TextEditingController?,fillColor: freezed == fillColor ? _self.fillColor : fillColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,disabledTextColor: freezed == disabledTextColor ? _self.disabledTextColor : disabledTextColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,contentStyle: freezed == contentStyle ? _self.contentStyle : contentStyle // ignore: cast_nullable_to_non_nullable
as TextStyle?,hintTextStyle: freezed == hintTextStyle ? _self.hintTextStyle : hintTextStyle // ignore: cast_nullable_to_non_nullable
as TextStyle?,labelTextStyle: freezed == labelTextStyle ? _self.labelTextStyle : labelTextStyle // ignore: cast_nullable_to_non_nullable
as TextStyle?,titleStyle: freezed == titleStyle ? _self.titleStyle : titleStyle // ignore: cast_nullable_to_non_nullable
as TextStyle?,errorTextStyle: freezed == errorTextStyle ? _self.errorTextStyle : errorTextStyle // ignore: cast_nullable_to_non_nullable
as TextStyle?,borderRadius: freezed == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as BorderRadius?,enabledBorderColor: freezed == enabledBorderColor ? _self.enabledBorderColor : enabledBorderColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,focusedBorderColor: freezed == focusedBorderColor ? _self.focusedBorderColor : focusedBorderColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,errorBorderColor: freezed == errorBorderColor ? _self.errorBorderColor : errorBorderColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,disabledBorderColor: freezed == disabledBorderColor ? _self.disabledBorderColor : disabledBorderColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,fillDisabledColor: freezed == fillDisabledColor ? _self.fillDisabledColor : fillDisabledColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,borderWidth: freezed == borderWidth ? _self.borderWidth : borderWidth // ignore: cast_nullable_to_non_nullable
as double?,noBorder: freezed == noBorder ? _self.noBorder : noBorder // ignore: cast_nullable_to_non_nullable
as bool?,isCustomBorder: freezed == isCustomBorder ? _self.isCustomBorder : isCustomBorder // ignore: cast_nullable_to_non_nullable
as bool?,contentPadding: freezed == contentPadding ? _self.contentPadding : contentPadding // ignore: cast_nullable_to_non_nullable
as EdgeInsetsGeometry?,isDense: freezed == isDense ? _self.isDense : isDense // ignore: cast_nullable_to_non_nullable
as bool?,iconColor: freezed == iconColor ? _self.iconColor : iconColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,prefixIcon: freezed == prefixIcon ? _self.prefixIcon : prefixIcon // ignore: cast_nullable_to_non_nullable
as Widget?,suffixIcon: freezed == suffixIcon ? _self.suffixIcon : suffixIcon // ignore: cast_nullable_to_non_nullable
as Widget?,prefixIconConstraints: freezed == prefixIconConstraints ? _self.prefixIconConstraints : prefixIconConstraints // ignore: cast_nullable_to_non_nullable
as BoxConstraints?,readOnly: freezed == readOnly ? _self.readOnly : readOnly // ignore: cast_nullable_to_non_nullable
as bool?,enableSuggestions: freezed == enableSuggestions ? _self.enableSuggestions : enableSuggestions // ignore: cast_nullable_to_non_nullable
as bool?,autocorrect: freezed == autocorrect ? _self.autocorrect : autocorrect // ignore: cast_nullable_to_non_nullable
as bool?,obscureText: freezed == obscureText ? _self.obscureText : obscureText // ignore: cast_nullable_to_non_nullable
as bool?,enableIMEPersonalizedLearning: freezed == enableIMEPersonalizedLearning ? _self.enableIMEPersonalizedLearning : enableIMEPersonalizedLearning // ignore: cast_nullable_to_non_nullable
as bool?,maxLines: freezed == maxLines ? _self.maxLines : maxLines // ignore: cast_nullable_to_non_nullable
as int?,minLines: freezed == minLines ? _self.minLines : minLines // ignore: cast_nullable_to_non_nullable
as int?,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,errorMaxLines: freezed == errorMaxLines ? _self.errorMaxLines : errorMaxLines // ignore: cast_nullable_to_non_nullable
as int?,inputAction: freezed == inputAction ? _self.inputAction : inputAction // ignore: cast_nullable_to_non_nullable
as TextInputAction?,autofillHints: freezed == autofillHints ? _self._autofillHints : autofillHints // ignore: cast_nullable_to_non_nullable
as List<String>?,inputFormatters: freezed == inputFormatters ? _self._inputFormatters : inputFormatters // ignore: cast_nullable_to_non_nullable
as List<TextInputFormatter>?,keyboardType: freezed == keyboardType ? _self.keyboardType : keyboardType // ignore: cast_nullable_to_non_nullable
as TextInputType?,obscuringCharacter: null == obscuringCharacter ? _self.obscuringCharacter : obscuringCharacter // ignore: cast_nullable_to_non_nullable
as String,requiredCharacter: null == requiredCharacter ? _self.requiredCharacter : requiredCharacter // ignore: cast_nullable_to_non_nullable
as String,requiredColor: freezed == requiredColor ? _self.requiredColor : requiredColor // ignore: cast_nullable_to_non_nullable
as KAppColor?,minDate: freezed == minDate ? _self.minDate : minDate // ignore: cast_nullable_to_non_nullable
as DateTime?,maxDate: freezed == maxDate ? _self.maxDate : maxDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
