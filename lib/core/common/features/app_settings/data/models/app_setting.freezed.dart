// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSetting {

 bool get hasOnboarded; bool get notification; bool get rememberUser; dynamic get loggedUser; ThemeMode get theme; String? get token; String? get refreshToken;@LocaleConverter() Locale? get locale;
/// Create a copy of AppSetting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingCopyWith<AppSetting> get copyWith => _$AppSettingCopyWithImpl<AppSetting>(this as AppSetting, _$identity);

  /// Serializes this AppSetting to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSetting&&(identical(other.hasOnboarded, hasOnboarded) || other.hasOnboarded == hasOnboarded)&&(identical(other.notification, notification) || other.notification == notification)&&(identical(other.rememberUser, rememberUser) || other.rememberUser == rememberUser)&&const DeepCollectionEquality().equals(other.loggedUser, loggedUser)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.token, token) || other.token == token)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.locale, locale) || other.locale == locale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasOnboarded,notification,rememberUser,const DeepCollectionEquality().hash(loggedUser),theme,token,refreshToken,locale);

@override
String toString() {
  return 'AppSetting(hasOnboarded: $hasOnboarded, notification: $notification, rememberUser: $rememberUser, loggedUser: $loggedUser, theme: $theme, token: $token, refreshToken: $refreshToken, locale: $locale)';
}


}

/// @nodoc
abstract mixin class $AppSettingCopyWith<$Res>  {
  factory $AppSettingCopyWith(AppSetting value, $Res Function(AppSetting) _then) = _$AppSettingCopyWithImpl;
@useResult
$Res call({
 bool hasOnboarded, bool notification, bool rememberUser, dynamic loggedUser, ThemeMode theme, String? token, String? refreshToken,@LocaleConverter() Locale? locale
});




}
/// @nodoc
class _$AppSettingCopyWithImpl<$Res>
    implements $AppSettingCopyWith<$Res> {
  _$AppSettingCopyWithImpl(this._self, this._then);

  final AppSetting _self;
  final $Res Function(AppSetting) _then;

/// Create a copy of AppSetting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasOnboarded = null,Object? notification = null,Object? rememberUser = null,Object? loggedUser = freezed,Object? theme = null,Object? token = freezed,Object? refreshToken = freezed,Object? locale = freezed,}) {
  return _then(_self.copyWith(
hasOnboarded: null == hasOnboarded ? _self.hasOnboarded : hasOnboarded // ignore: cast_nullable_to_non_nullable
as bool,notification: null == notification ? _self.notification : notification // ignore: cast_nullable_to_non_nullable
as bool,rememberUser: null == rememberUser ? _self.rememberUser : rememberUser // ignore: cast_nullable_to_non_nullable
as bool,loggedUser: freezed == loggedUser ? _self.loggedUser : loggedUser // ignore: cast_nullable_to_non_nullable
as dynamic,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeMode,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as Locale?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSetting].
extension AppSettingPatterns on AppSetting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSetting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSetting() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSetting value)  $default,){
final _that = this;
switch (_that) {
case _AppSetting():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSetting value)?  $default,){
final _that = this;
switch (_that) {
case _AppSetting() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool hasOnboarded,  bool notification,  bool rememberUser,  dynamic loggedUser,  ThemeMode theme,  String? token,  String? refreshToken, @LocaleConverter()  Locale? locale)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSetting() when $default != null:
return $default(_that.hasOnboarded,_that.notification,_that.rememberUser,_that.loggedUser,_that.theme,_that.token,_that.refreshToken,_that.locale);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool hasOnboarded,  bool notification,  bool rememberUser,  dynamic loggedUser,  ThemeMode theme,  String? token,  String? refreshToken, @LocaleConverter()  Locale? locale)  $default,) {final _that = this;
switch (_that) {
case _AppSetting():
return $default(_that.hasOnboarded,_that.notification,_that.rememberUser,_that.loggedUser,_that.theme,_that.token,_that.refreshToken,_that.locale);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool hasOnboarded,  bool notification,  bool rememberUser,  dynamic loggedUser,  ThemeMode theme,  String? token,  String? refreshToken, @LocaleConverter()  Locale? locale)?  $default,) {final _that = this;
switch (_that) {
case _AppSetting() when $default != null:
return $default(_that.hasOnboarded,_that.notification,_that.rememberUser,_that.loggedUser,_that.theme,_that.token,_that.refreshToken,_that.locale);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class _AppSetting extends AppSetting {
  const _AppSetting({this.hasOnboarded = false, this.notification = false, this.rememberUser = true, this.loggedUser, this.theme = ThemeMode.system, this.token, this.refreshToken, @LocaleConverter() this.locale = AppLocales.en}): super._();
  factory _AppSetting.fromJson(Map<String, dynamic> json) => _$AppSettingFromJson(json);

@override@JsonKey() final  bool hasOnboarded;
@override@JsonKey() final  bool notification;
@override@JsonKey() final  bool rememberUser;
@override final  dynamic loggedUser;
@override@JsonKey() final  ThemeMode theme;
@override final  String? token;
@override final  String? refreshToken;
@override@JsonKey()@LocaleConverter() final  Locale? locale;

/// Create a copy of AppSetting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingCopyWith<_AppSetting> get copyWith => __$AppSettingCopyWithImpl<_AppSetting>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSetting&&(identical(other.hasOnboarded, hasOnboarded) || other.hasOnboarded == hasOnboarded)&&(identical(other.notification, notification) || other.notification == notification)&&(identical(other.rememberUser, rememberUser) || other.rememberUser == rememberUser)&&const DeepCollectionEquality().equals(other.loggedUser, loggedUser)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.token, token) || other.token == token)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.locale, locale) || other.locale == locale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasOnboarded,notification,rememberUser,const DeepCollectionEquality().hash(loggedUser),theme,token,refreshToken,locale);

@override
String toString() {
  return 'AppSetting(hasOnboarded: $hasOnboarded, notification: $notification, rememberUser: $rememberUser, loggedUser: $loggedUser, theme: $theme, token: $token, refreshToken: $refreshToken, locale: $locale)';
}


}

/// @nodoc
abstract mixin class _$AppSettingCopyWith<$Res> implements $AppSettingCopyWith<$Res> {
  factory _$AppSettingCopyWith(_AppSetting value, $Res Function(_AppSetting) _then) = __$AppSettingCopyWithImpl;
@override @useResult
$Res call({
 bool hasOnboarded, bool notification, bool rememberUser, dynamic loggedUser, ThemeMode theme, String? token, String? refreshToken,@LocaleConverter() Locale? locale
});




}
/// @nodoc
class __$AppSettingCopyWithImpl<$Res>
    implements _$AppSettingCopyWith<$Res> {
  __$AppSettingCopyWithImpl(this._self, this._then);

  final _AppSetting _self;
  final $Res Function(_AppSetting) _then;

/// Create a copy of AppSetting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasOnboarded = null,Object? notification = null,Object? rememberUser = null,Object? loggedUser = freezed,Object? theme = null,Object? token = freezed,Object? refreshToken = freezed,Object? locale = freezed,}) {
  return _then(_AppSetting(
hasOnboarded: null == hasOnboarded ? _self.hasOnboarded : hasOnboarded // ignore: cast_nullable_to_non_nullable
as bool,notification: null == notification ? _self.notification : notification // ignore: cast_nullable_to_non_nullable
as bool,rememberUser: null == rememberUser ? _self.rememberUser : rememberUser // ignore: cast_nullable_to_non_nullable
as bool,loggedUser: freezed == loggedUser ? _self.loggedUser : loggedUser // ignore: cast_nullable_to_non_nullable
as dynamic,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeMode,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as Locale?,
  ));
}


}

// dart format on
