import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart'; // Needed if you want to return or use TimeOfDay types, otherwise optional
import 'package:injectable/injectable.dart';

import '../../../../config/constants/date_time/date_time_formatter_string_constant.dart';
import '../../../../config/constants/gen/locale_keys.g.dart';

@lazySingleton
class DateTimeHelper {
  String formatDateTime({
    required DateTime dateTime,
    String formatter = DateTimeFormatterString.abbreviatedDayMonthDayFormat,
  }) {
    return DateFormat(formatter).format(dateTime);
  }

  String formatDateTimeRange({
    required DateTimeRange dateTimeRange,
    String formatter = DateTimeFormatterString.fullYearMonthDate,
  }) {
    return '${formatDateTime(dateTime: dateTimeRange.start, formatter: formatter)} - ${formatDateTime(dateTime: dateTimeRange.end, formatter: formatter)}';
  }

  bool isToday(DateTime dateTime) {
    final DateTime now = DateTime.now();
    return now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;
  }

  String agoDateTime({required DateTime dateTime}) {
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays >= 365) {
      final int years = (difference.inDays / 365).floor();
      // return '${years}y ago';
      return LocaleKeys
          .core_common_presentation_helpers_date_time_helper_yearsAgo
          .tr(namedArgs: {'years': years.toString()});
    } else if (difference.inDays >= 30) {
      final int months = (difference.inDays / 30).floor();
      // return '${months}m ago';
      return LocaleKeys
          .core_common_presentation_helpers_date_time_helper_monthsAgo
          .tr(namedArgs: {'months': months.toString()});
    } else if (difference.inDays >= 7) {
      final int weeks = (difference.inDays / 7).floor();
      // return '${weeks}w ago';
      return LocaleKeys
          .core_common_presentation_helpers_date_time_helper_weeksAgo
          .tr(namedArgs: {'weeks': weeks.toString()});
    } else if (difference.inDays >= 1) {
      // return '${difference.inDays}d ago';
      return LocaleKeys
          .core_common_presentation_helpers_date_time_helper_daysAgo
          .tr(namedArgs: {'days': difference.inDays.toString()});
    } else if (difference.inHours >= 1) {
      // return '${difference.inHours}h ago';
      return LocaleKeys
          .core_common_presentation_helpers_date_time_helper_hoursAgo
          .tr(namedArgs: {'hours': difference.inHours.toString()});
    } else if (difference.inMinutes >= 1) {
      // return '${difference.inMinutes}m ago';
      return LocaleKeys
          .core_common_presentation_helpers_date_time_helper_minutesAgo
          .tr(namedArgs: {'minutes': difference.inMinutes.toString()});
    } else {
      // return '${difference.inSeconds}s ago';
      return LocaleKeys
          .core_common_presentation_helpers_date_time_helper_secondsAgo
          .tr(namedArgs: {'seconds': difference.inSeconds.toString()});
    }
  }

  String timeLeft({required DateTime dateTime, int? days, DateTime? endDate}) {
    final now = DateTime.now();

    if (days != null) {
      final nextResetDate = dateTime.add(Duration(days: days));
      final effectiveEndDate =
          endDate != null && endDate.isBefore(nextResetDate)
          ? endDate
          : nextResetDate;

      final remaining = effectiveEndDate.difference(now).inDays;

      if (remaining > 0) {
        // return '$remaining day(s) left';
        return LocaleKeys
            .core_common_presentation_helpers_date_time_helper_daysLeft
            .tr(namedArgs: {'days': remaining.toString()});
      } else {
        // return 'Reset due';
        return LocaleKeys
            .core_common_presentation_helpers_date_time_helper_resetDue;
      }
    }

    // Fallback to ago logic...
    // (Reuse the logic from agoDateTime or call it directly if preferred)
    return agoDateTime(dateTime: dateTime);
  }

  // --- NEW: Time of Day Methods ---

  /// Formats just the time portion.
  /// Example: "5:30 PM"
  String formatTime({required DateTime dateTime}) {
    return DateFormat.jm().format(dateTime);
  }

  /// Formats time in 24-hour format.
  /// Example: "17:30"
  String formatTime24({required DateTime dateTime}) {
    return DateFormat.Hm().format(dateTime);
  }

  /// Returns a greeting based on the time of day.
  /// Example: "Morning", "Afternoon", "Evening", "Night"
  String getGreeting({DateTime? dateTime}) {
    final DateTime targetTime = dateTime ?? DateTime.now();
    final int hour = targetTime.hour;

    if (hour >= 5 && hour < 12) {
      // return 'Morning';
      return LocaleKeys
          .core_common_presentation_helpers_date_time_helper_morning;
    } else if (hour >= 12 && hour < 17) {
      // return 'Afternoon';
      return LocaleKeys
          .core_common_presentation_helpers_date_time_helper_afternoon;
    } else if (hour >= 17 && hour < 21) {
      // return 'Evening';
      return LocaleKeys
          .core_common_presentation_helpers_date_time_helper_evening;
    } else {
      // return 'Night';
      return LocaleKeys.core_common_presentation_helpers_date_time_helper_night;
    }
  }

  String formatTimeOfDay({required TimeOfDay time}) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }
}
