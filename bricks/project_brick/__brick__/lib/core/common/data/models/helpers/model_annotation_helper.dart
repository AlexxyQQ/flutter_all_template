import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../config/constants/locales/app_locales.dart';

/// A [JsonConverter] for the [IconData] class.
///
/// This converter enables the serialization and deserialization of [IconData]
/// objects to and from a JSON format. It is particularly useful when using
/// code generation libraries like `freezed` or `json_serializable` for data
/// models that include icons.
///
/// The JSON representation is a map containing the `codePoint`, `fontFamily`,
/// and `fontPackage` of the icon.
///
/// ### Example
///
/// To use this converter with a `freezed` model, annotate the `IconData`
/// field with `@IconDataConverter()`.
///
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:freezed_annotation/freezed_annotation.dart';
/// // Assuming IconDataConverter is in the same directory or imported correctly.
/// import 'model_annotations.helper.dart';
///
/// part 'my_model.freezed.dart';
/// part 'my_model.g.dart';
///
/// @freezed
/// class MyModel with _$MyModel {
///   const factory MyModel({
///     required String name,
///     @IconDataConverter() required IconData icon,
///   }) = _MyModel;
///
///   factory MyModel.fromJson(Map<String, dynamic> json) =>
///       _$MyModelFromJson(json);
/// }
///
/// void main() {
///   // Create an instance of the model.
///   final model = MyModel(name: 'Home', icon: Icons.home);
///
///   // Serialize the model to JSON.
///   final json = model.toJson();
///   print(json);
///   // Output:
///   // {
///   //   "name": "Home",
///   //   "icon": {
///   //     "codePoint": 59530,
///   //     "fontFamily": "MaterialIcons",
///   //     "fontPackage": null
///   //   }
///   // }
///
///   // Deserialize the JSON back to a model instance.
///   final newModel = MyModel.fromJson(json);
///   print(newModel.icon == Icons.home); // Output: true
/// }
/// ```
class IconDataConverter
    implements JsonConverter<IconData, Map<String, dynamic>> {
  const IconDataConverter();

  @override
  IconData fromJson(Map<String, dynamic> json) {
    return IconData(
      json['codePoint'] as int,
      fontFamily: json['fontFamily'] as String?,
      fontPackage: json['fontPackage'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson(IconData iconData) {
    return {
      'codePoint': iconData.codePoint,
      'fontFamily': iconData.fontFamily,
      'fontPackage': iconData.fontPackage,
    };
  }
}

class LocaleConverter implements JsonConverter<Locale, String?> {
  const LocaleConverter();

  @override
  Locale fromJson(String? json) {
    if (json == null) {
      return AppLocales.en;
    }
    final splitData = json.split('_');

    return AppLocales.fromString(languageCode: splitData[0]);
  }

  @override
  String? toJson(Locale object) {
    return object.languageCode;
  }
}

class TimeOfDayConverter implements JsonConverter<TimeOfDay, String> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(String json) {
    final parts = json.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  String toJson(TimeOfDay object) {
    return '${object.hour}:${object.minute}';
  }
}
