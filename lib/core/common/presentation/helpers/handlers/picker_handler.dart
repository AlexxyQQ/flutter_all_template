import 'package:flutter/material.dart';

import '../../../../../config/constants/date_time/date_time_formatter_string_constant.dart';
import '../../../../../config/constants/enums/text_form_filed_enum.dart';
import '../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../config/themes/components_theme/app_text_form_field_theme.dart';
import '../../../domain/services/navigation/navigation_service.dart';
import '../../../locator/service_locator.dart';
import '../../extensions/date_time/date_time_extension.dart';
import '../../routes/app_router.gr.dart';

/// Handles all date and time picker interactions.
///
/// Manages:
/// - Date picker
/// - Date range picker
/// - Time picker
/// - Default value setting
class PickerHandler {
  PickerHandler({required this.controller, this.onChanged});

  final TextEditingController controller;
  final void Function(dynamic)? onChanged;

  /// Sets default date value if this is a date picker field
  void setDatePickerDefaultIfNeeded(
    FormFieldTheme theme,
    String? initialValue,
  ) {
    if (theme.inputType == AppInputTypeEnum.datePicker &&
        controller.text.isEmpty) {
      // controller.text = DateTimeFormatter.formatDate(DateTime.now());
      final DateTime? initialValueConverted = DateTime.tryParse(
        initialValue ?? '',
      );

      if (initialValueConverted != null) {
        controller.text = initialValueConverted.formatDateTime(
          formatter: DateTimeFormatterString.fullYearMonthDate,
        );
      } else {
        controller.text = DateTime.now().formatDateTime(
          formatter: DateTimeFormatterString.fullYearMonthDate,
        );
      }
    }
    // For Range
    if (theme.inputType == AppInputTypeEnum.dateRangePicker &&
        controller.text.isEmpty) {}
  }

  /// Opens date picker dialog and updates the field
  Future<void> selectDate(
    BuildContext context,
    FormFieldTheme theme,
    String? initialValue,
  ) async {
    final DateTime? initialDate = DateTime.tryParse(initialValue ?? '');

    final DateTime? pickedDate = await sl<NavigationService>().push(
      DateSelectorBottomSheet(
        title: LocaleKeys.common_form_field_titles_selectDate,
        seed: initialDate ?? DateTime.now(),
        minDate: theme.minDate ?? DateTime(1900),
        maxDate: theme.maxDate ?? DateTime(2101),
      ),
    );

    if (!context.mounted) {
      return;
    }

    if (pickedDate != null) {
      controller.text = pickedDate.formatDateTime(
        formatter: DateTimeFormatterString.fullYearMonthDate,
      );
      onChanged?.call(pickedDate);
    }
  }

  /// Opens date range picker dialog and updates the field
  Future<void> selectDateRange(
    BuildContext context,
    FormFieldTheme theme,
    String? initialValue,
  ) async {
    // Convert the List<DateTime>? string to List<DateTime>
    final List<DateTime> parsedDates =
        initialValue?.replaceAll('[', '').replaceAll(']', '').split(',').map((
          dateString,
        ) {
          final DateTime? parsedDate = DateTime.tryParse(dateString.toString());
          return parsedDate ?? DateTime.now();
        }).toList() ??
        [];

    final DateTimeRange<DateTime>? pickedDate = await sl<NavigationService>()
        .push(
          DateRangeSelectorBottomSheet(
            title: LocaleKeys.common_form_field_titles_selectDate,
            seed: [parsedDates[0], parsedDates[1]],
            minDate: theme.minDate ?? DateTime(1900),
            maxDate: theme.maxDate ?? DateTime(2101),
          ),
        );

    if (!context.mounted) {
      return;
    }

    if (pickedDate != null) {
      controller.text = pickedDate.formatDateRange();
      onChanged?.call(pickedDate);
    }
  }

  /// Opens time picker dialog and updates the field
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (!context.mounted) return;

    if (pickedTime != null) {
      controller.text = pickedTime.formatTime();
      onChanged?.call(pickedTime);
    }
  }
}
