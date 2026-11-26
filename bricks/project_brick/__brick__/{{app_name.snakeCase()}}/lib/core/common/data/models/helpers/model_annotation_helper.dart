import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../config/constants/locales/app_locales.dart';

// JSON converters for Flutter types used in data models.
//
// ```dart
// @freezed
// abstract class ReminderModel with _$ReminderModel {
//   const factory ReminderModel({
//     @LocaleConverter() required Locale locale,
//     @TimeOfDayConverter() required TimeOfDay at,
//   }) = _ReminderModel;
//
//   factory ReminderModel.fromJson(Map<String, dynamic> json) =>
//       _$ReminderModelFromJson(json);
// }
// ```
//
// Icons are intentionally not serialisable: building `IconData` from a stored
// code point defeats icon tree-shaking. Store a stable key (e.g. an enum
// name) and map it to a `const` icon in the presentation layer instead.

/// Serialises a [Locale] as a BCP-47-like tag (`en-GB`, `ne-NP`, `fr`),
/// keeping the country code. Accepts `_` or `-` as separator when reading.
/// `null` reads as [AppLocales.en].
class LocaleConverter implements JsonConverter<Locale, String?> {
  const LocaleConverter();

  @override
  Locale fromJson(String? json) {
    if (json == null || json.trim().isEmpty) {
      return AppLocales.en;
    }
    final parts = json.trim().split(RegExp('[-_]'));
    final country = parts.length > 1 && parts[1].isNotEmpty ? parts[1] : null;
    return Locale(parts[0], country);
  }

  @override
  String? toJson(Locale object) => object.toLanguageTag();
}

/// Serialises a [TimeOfDay] as zero-padded `HH:mm`.
class TimeOfDayConverter implements JsonConverter<TimeOfDay, String> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(String json) {
    final parts = json.split(':');
    if (parts.length < 2) {
      throw FormatException('Expected HH:mm', json);
    }
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  String toJson(TimeOfDay object) =>
      '${object.hour.toString().padLeft(2, '0')}:'
      '${object.minute.toString().padLeft(2, '0')}';
}
