import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../config/constants/date_time/date_time_formatter_string_constant.dart';
import '../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../config/constants/text/material/app_material_text_primitives.dart';
import '../../../../../../config/themes/components_theme/app_chip_theme.dart';
import '../../../../domain/services/navigation/navigation_service.dart';
import '../../../../locator/service_locator.dart';
import '../../../extensions/date_time/date_time_extension.dart';
import '../../../extensions/size/size_extension.dart';
import '../../../extensions/theme/theme_extension.dart';
import '../../../themes/styles/app_chip_style.dart';
import '../../widgets/system/app_button.dart';
import '../../widgets/system/app_chip_widget.dart';
import '../../widgets/system/text/app_text_widget.dart';

@RoutePage(name: 'DateSelectorBottomSheet')
class StyledDatePickerSheet extends StatefulWidget {
  const StyledDatePickerSheet({
    required this.title,
    super.key,
    this.seed,
    this.minDate,
    this.maxDate,
  });

  final String title;
  final DateTime? seed;
  final DateTime? minDate;
  final DateTime? maxDate;

  @override
  State<StyledDatePickerSheet> createState() => _StyledDatePickerSheetState();
}

class _StyledDatePickerSheetState extends State<StyledDatePickerSheet> {
  DateTime? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.seed;
  }

  bool get _hasSelection => _value != null;

  void _apply() {
    if (!_hasSelection) {
      sl<NavigationService>().maybePop();
      return;
    }

    sl<NavigationService>().maybePop(DateUtils.dateOnly(_value!));
  }

  void _reset() => setState(() => _value = null);

  void _setPreset(DateTime date) {
    setState(() => _value = date);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final now = DateUtils.dateOnly(DateTime.now());

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      padding: media.viewInsets.bottom.bottomOnly,
      // EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: 28.borderCircular,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                10.verticalGap,
                Container(
                  width: 54,
                  height: 6,
                  decoration: BoxDecoration(
                    color: context.colors.outlineVariant,
                    borderRadius: (4).borderCircular,
                  ),
                ),
                Padding(
                  padding: 20.horizontalPadding + 14.verticalPadding,
                  child: Row(
                    children: [
                      Expanded(
                        child: AppText(
                          widget.title,
                          style: context.textStyles.titleLarge.copyWith(
                            fontWeight: AppMaterialTextPrimitives.semibold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _reset,
                        child: AppText(
                          LocaleKeys.common_words_reset,
                          style: context.textStyles.titleMedium.copyWith(
                            color: context.colors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ignore: avoid_sized_box_height
                Padding(
                  padding: 16.leftOnly,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: AppChipWidget.detail(
                      title: LocaleKeys.common_calender_today,
                      isSelected: _isPreset(now),
                      onTap: () => _setPreset(now),
                    ),
                  ),
                ),
                12.verticalGap,
                CalendarDatePicker2(
                  value: [_value].whereType<DateTime?>().toList(),

                  onValueChanged: (list) =>
                      setState(() => _value = list.isNotEmpty ? list[0] : null),
                  config: CalendarDatePicker2Config(
                    calendarType: CalendarDatePicker2Type.single,
                    firstDate: widget.minDate,
                    lastDate: widget.maxDate,
                    selectedDayHighlightColor: context.colors.primary,

                    weekdayLabels: [
                      LocaleKeys.common_calender_days_sun.tr(),
                      LocaleKeys.common_calender_days_mon.tr(),
                      LocaleKeys.common_calender_days_tue.tr(),
                      LocaleKeys.common_calender_days_wed.tr(),
                      LocaleKeys.common_calender_days_thu.tr(),
                      LocaleKeys.common_calender_days_fri.tr(),
                      LocaleKeys.common_calender_days_sat.tr(),
                    ],
                    dayBorderRadius: (8).borderCircular,
                    centerAlignModePicker: true,
                    controlsTextStyle: context.textStyles.bodyLarge,
                    dayTextStyle: context.textStyles.bodySmall,
                    selectedDayTextStyle: context.textStyles.bodySmall.copyWith(
                      fontWeight: AppMaterialTextPrimitives.bold,
                      color: context.colors.onPrimary,
                    ),
                  ),
                ),
                8.verticalGap,

                _DatePreview(value: _value),
                20.verticalGap,
                Padding(
                  padding:
                      (12 + context.bottomPadding).bottomOnly +
                      (16).leftOnly +
                      (16).rightOnly,
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton.stroke(
                          onPressed: () => sl<NavigationService>().maybePop(),
                          label: LocaleKeys.common_words_cancel,
                        ),
                      ),
                      12.horizontalGap,
                      Expanded(
                        child: AppButton.primary(
                          onPressed: _apply,
                          isDisabled: !_hasSelection,
                          label: LocaleKeys.common_words_apply,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isPreset(DateTime date) {
    if (_value == null) {
      return false;
    }
    return DateUtils.isSameDay(_value, date);
  }
}

@RoutePage(name: 'DateRangeSelectorBottomSheet')
class StyledDateRangeSheet extends StatefulWidget {
  const StyledDateRangeSheet({
    required this.title,
    required this.seed,
    super.key,
    this.minDate,
    this.maxDate,
  });

  final String title;
  final List<DateTime?> seed;
  final DateTime? minDate;
  final DateTime? maxDate;

  @override
  State<StyledDateRangeSheet> createState() => StyledDateRangeSheetState();
}

class StyledDateRangeSheetState extends State<StyledDateRangeSheet> {
  late List<DateTime?> _values;

  @override
  void initState() {
    super.initState();
    _values = [...widget.seed];
  }

  bool get _hasFullSelection =>
      _values.length == 2 && _values[0] != null && _values[1] != null;

  void _apply() {
    if (!_hasFullSelection) {
      sl<NavigationService>().maybePop();
      return;
    }
    DateTime start = DateUtils.dateOnly(_values[0]!);
    DateTime end = DateUtils.dateOnly(_values[1]!);
    if (end.isBefore(start)) {
      final tmp = start;
      start = end;
      end = tmp;
    }
    sl<NavigationService>().maybePop(DateTimeRange(start: start, end: end));
  }

  void _reset() => setState(() => _values = []);

  void _setPreset(DateTime start, DateTime end) {
    if (!_isRangeValid(start, end)) {
      return;
    }
    setState(() => _values = [start, end]);
  }

  CustomAppChipTheme _getTheme(DateTime start, DateTime end) {
    final s = DateUtils.dateOnly(start);
    final e = DateUtils.dateOnly(end);

    if (widget.minDate != null &&
        s.isBefore(DateUtils.dateOnly(widget.minDate!))) {
      return AppChipStyle.disabledTheme;
    }
    if (widget.maxDate != null &&
        e.isAfter(DateUtils.dateOnly(widget.maxDate!))) {
      return AppChipStyle.disabledTheme;
    }
    return AppChipStyle.primaryTheme;
  }

  // 1. New helper to check if a range is allowed
  bool _isRangeValid(DateTime start, DateTime end) {
    final s = DateUtils.dateOnly(start);
    final e = DateUtils.dateOnly(end);

    if (widget.minDate != null &&
        s.isBefore(DateUtils.dateOnly(widget.minDate!))) {
      return false;
    }
    if (widget.maxDate != null &&
        e.isAfter(DateUtils.dateOnly(widget.maxDate!))) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final now = DateUtils.dateOnly(DateTime.now());

    final thisWeekStart = now.subtract(Duration(days: now.weekday - 1));
    final thisWeekEnd = thisWeekStart.add(const Duration(days: 6));
    final last7Start = now.subtract(const Duration(days: 6));
    final monthStart = DateTime(now.year, now.month);
    final monthEnd = DateTime(now.year, now.month + 1, 0);

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      padding: media.viewInsets.bottom.bottomOnly,
      child: SafeArea(
        top: false,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                10.verticalGap,
                Container(
                  width: 54,
                  height: 6,
                  decoration: BoxDecoration(
                    color: context.colors.outlineVariant,
                    borderRadius: (4).borderCircular,
                  ),
                ),
                Padding(
                  padding: 20.horizontalPadding + 14.verticalPadding,
                  child: Row(
                    children: [
                      Expanded(
                        child: AppText(
                          widget.title,
                          style: context.textStyles.titleLarge.copyWith(
                            fontWeight: AppMaterialTextPrimitives.semibold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _reset,
                        child: AppText(
                          LocaleKeys.common_words_reset,
                          style: context.textStyles.titleMedium.copyWith(
                            color: context.colors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: 16.horizontalPadding,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        AppChipWidget.detail(
                          title: LocaleKeys.common_calender_today,
                          theme: _getTheme(now, now),
                          isSelected: _isPreset(now, now),
                          onTap: () => _setPreset(now, now),
                        ),
                        AppChipWidget.detail(
                          title: LocaleKeys.common_calender_last7Days,
                          theme: _getTheme(last7Start, now),
                          isSelected: _isPreset(last7Start, now),
                          onTap: () => _setPreset(last7Start, now),
                        ),
                        AppChipWidget.detail(
                          title: LocaleKeys.common_calender_thisWeek,
                          theme: _getTheme(thisWeekStart, thisWeekEnd),
                          isSelected: _isPreset(thisWeekStart, thisWeekEnd),
                          onTap: () => _setPreset(thisWeekStart, thisWeekEnd),
                        ),
                        AppChipWidget.detail(
                          title: LocaleKeys.common_calender_thisMonth,
                          theme: _getTheme(monthStart, monthEnd),
                          isSelected: _isPreset(monthStart, monthEnd),
                          onTap: () => _setPreset(monthStart, monthEnd),
                        ),
                      ],
                    ),
                  ),
                ),
                12.verticalGap,
                CalendarDatePicker2(
                  value: _values,
                  onValueChanged: (list) => setState(() => _values = list),
                  config: CalendarDatePicker2Config(
                    calendarType: CalendarDatePicker2Type.range,
                    firstDate: widget.minDate,
                    lastDate: widget.maxDate,
                    selectedDayHighlightColor: context.colors.primary,
                    selectedRangeHighlightColor: context.colors.primary
                        .withValues(alpha: 0.15),
                    weekdayLabels: [
                      LocaleKeys.common_calender_days_sun.tr(),
                      LocaleKeys.common_calender_days_mon.tr(),
                      LocaleKeys.common_calender_days_tue.tr(),
                      LocaleKeys.common_calender_days_wed.tr(),
                      LocaleKeys.common_calender_days_thu.tr(),
                      LocaleKeys.common_calender_days_fri.tr(),
                      LocaleKeys.common_calender_days_sat.tr(),
                    ],
                    dayBorderRadius: (8).borderCircular,
                    centerAlignModePicker: true,
                    controlsTextStyle: context.textStyles.bodyLarge,
                    dayTextStyle: context.textStyles.bodySmall,
                    selectedDayTextStyle: context.textStyles.bodySmall.copyWith(
                      fontWeight: AppMaterialTextPrimitives.bold,
                      color: context.colors.onPrimary,
                    ),
                  ),
                ),
                8.verticalGap,
                _RangePreview(values: _values),
                20.verticalGap,
                Padding(
                  padding: 16.horizontalPadding + 12.verticalPadding,
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton.stroke(
                          label: LocaleKeys.common_words_cancel,
                          onPressed: () => sl<NavigationService>().maybePop(),
                        ),
                      ),
                      12.horizontalGap,
                      Expanded(
                        child: AppButton.primary(
                          label: LocaleKeys.common_words_apply,
                          isDisabled: !_hasFullSelection,
                          onPressed: _apply,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isPreset(DateTime start, DateTime end) {
    if (!_hasFullSelection) {
      return false;
    }
    DateTime a = DateUtils.dateOnly(_values[0]!);
    DateTime b = DateUtils.dateOnly(_values[1]!);
    if (b.isBefore(a)) {
      final t = a;
      a = b;
      b = t;
    }
    return a == start && b == end;
  }
}

class _DatePreview extends StatelessWidget {
  const _DatePreview({required this.value});
  final DateTime? value;

  @override
  Widget build(BuildContext context) {
    String text;
    if (value == null) {
      text = LocaleKeys.common_errors_validation_notSelected.tr(
        namedArgs: {'title': LocaleKeys.common_words_date.tr()},
      );
    } else {
      text = _fmt(value!);
    }
    return Container(
      width: double.infinity,
      margin: 16.horizontalPadding,
      padding: 16.horizontalPadding + 14.verticalPadding,
      decoration: BoxDecoration(
        color: context.colors.outlineVariant,
        borderRadius: (16).borderCircular,
      ),
      child: AppText(
        text,
        style: context.textStyles.bodyLarge.copyWith(
          color: context.colors.outline,
        ),
      ),
    );
  }

  static String _fmt(DateTime d) =>
      d.formatDateTime(formatter: DateTimeFormatterString.fullYearMonthDate);
}

class _RangePreview extends StatelessWidget {
  const _RangePreview({required this.values});
  final List<DateTime?> values;

  @override
  Widget build(BuildContext context) {
    DateTime? s = values.isNotEmpty ? values[0] : null;
    DateTime? e = values.length > 1 ? values[1] : null;
    String text;
    if (s == null && e == null) {
      text = LocaleKeys.common_errors_validation_notSelected.tr(
        namedArgs: {'title': LocaleKeys.common_words_range.tr()},
      );
    } else if (s != null && e == null) {
      text = _fmt(s);
    } else if (s != null && e != null) {
      if (e.isBefore(s)) {
        final t = s;
        s = e;
        e = t;
      }
      text = '${_fmt(s)}  →  ${_fmt(e)}';
    } else {
      text = LocaleKeys.common_errors_validation_notSelected.tr(
        namedArgs: {'title': LocaleKeys.common_words_range.tr()},
      );
    }
    return Container(
      width: double.infinity,
      margin: 16.horizontalPadding,
      padding: 16.horizontalPadding + 14.verticalPadding,
      decoration: BoxDecoration(
        color: context.colors.outlineVariant.withValues(alpha: .25),
        borderRadius: (16).borderCircular,
      ),
      child: AppText(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }

  static String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
