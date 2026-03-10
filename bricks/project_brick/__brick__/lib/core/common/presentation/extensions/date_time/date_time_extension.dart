import 'package:flutter/material.dart';

import '../../../../../config/constants/date_time/date_time_formatter_string_constant.dart';
import '../../../locator/service_locator.dart';
import '../../helpers/date_time_helper.dart';

extension DateTimeExtension on DateTime {
  String formatDateTime({
    String formatter = DateTimeFormatterString.abbreviatedDayMonthDayFormat,
  }) {
    return sl<DateTimeHelper>().formatDateTime(
      dateTime: toLocal(),
      formatter: formatter.toString(),
    );
  }

  String agoDateTime() {
    return sl<DateTimeHelper>().agoDateTime(dateTime: this);
  }

  String timeLeft({int? days, DateTime? endDate}) {
    return sl<DateTimeHelper>().timeLeft(
      dateTime: this,
      days: days,
      endDate: endDate,
    );
  }
}

extension IntDateTimeCoveter on int {
  DateTime toDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(this);
  }
}

// Convert String to DateTime
extension StringDateTimeConverter on String {
  /// Parses a date string in YYYY-MM-DD format
  static DateTime? toDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    return DateTime.tryParse(dateString);
  }

  /// Parses a time string in HH:MM format
  static TimeOfDay? toTimeOfDay(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;

    final parts = timeString.split(':');
    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

    return TimeOfDay(hour: hour, minute: minute);
  }
}

extension TimeOfDayExtension on TimeOfDay {
  String formatTime() {
    return sl<DateTimeHelper>().formatTimeOfDay(time: this);
  }
}

extension DateTimeRangeExtension on DateTimeRange {
  String formatDateRange({
    String formatter = DateTimeFormatterString.fullYearMonthDate,
  }) {
    return sl<DateTimeHelper>().formatDateTimeRange(
      dateTimeRange: this,
      formatter: formatter,
    );
  }
}
