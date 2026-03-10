import 'package:flutter/material.dart';

import '../../../../../config/constants/date_time/date_time_formatter_string_constant.dart';
import '../../../../../config/constants/enums/text_form_filed_enum.dart';
import '../../../../../config/themes/components_theme/app_text_form_field_theme.dart';
import '../../../presentation/extensions/date_time/date_time_extension.dart';

/// Manages the text controller and focus node lifecycle for the text field.
///
/// Handles:
/// - Controller creation and disposal
/// - Focus node management
/// - Text change notifications
/// - Reset functionality
class TextFieldControllerManager {
  TextFieldControllerManager({
    required FormFieldTheme theme,
    TextEditingController? externalController,
    String? initialValue,
  }) {
    _initializeController(externalController, initialValue, theme);
    _setupTextListener();
  }

  late final TextEditingController _controller;
  FocusNode? _focusNode;
  bool _ownsController = false;
  bool _ownsFocusNode = false;

  final ValueNotifier<String> textNotifier = ValueNotifier('');

  TextEditingController get controller => _controller;

  void _initializeController(
    TextEditingController? externalController,
    String? initialValue,
    FormFieldTheme theme,
  ) {
    if (externalController != null) {
      _controller = externalController;
      _ownsController = false;
    } else {
      final formattedInitialValue = _getInitialValue(theme, initialValue);
      _controller = TextEditingController(text: formattedInitialValue);
      _ownsController = true;
    }
    textNotifier.value = _controller.text;
  }

  void _setupTextListener() {
    _controller.addListener(() {
      textNotifier.value = _controller.text;
    });
  }

  FocusNode getFocusNode(FormFieldTheme theme) {
    if (_focusNode != null) return _focusNode!;

    if (theme.focusNode != null) {
      _focusNode = theme.focusNode;
      _ownsFocusNode = false;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }

    return _focusNode!;
  }

  void resetToInitial(String? initialValue) {
    _controller.text = initialValue ?? '';
  }

  void dispose() {
    textNotifier.dispose();

    if (_ownsController) {
      _controller.dispose();
    }

    if (_ownsFocusNode && _focusNode != null) {
      _focusNode!.dispose();
    }
  }

  /// Sets default date value if this is a date picker field
  String _getInitialValue(FormFieldTheme theme, String? initialValue) {
    if (theme.inputType == AppInputTypeEnum.datePicker) {
      // controller.text = DateTimeFormatter.formatDate(DateTime.now());
      final DateTime? initialValueConverted = DateTime.tryParse(
        initialValue ?? '',
      );

      if (initialValueConverted != null) {
        return initialValueConverted.formatDateTime(
          formatter: DateTimeFormatterString.fullYearMonthDate,
        );
      } else {
        return DateTime.now().formatDateTime(
          formatter: DateTimeFormatterString.fullYearMonthDate,
        );
      }
    }
    // For Range
    else if (theme.inputType == AppInputTypeEnum.dateRangePicker) {
      final List<DateTime> parsedDates =
          initialValue?.replaceAll('[', '').replaceAll(']', '').split(',').map((
            dateString,
          ) {
            final DateTime? parsedDate = DateTime.tryParse(dateString);
            return parsedDate ?? DateTime.now();
          }).toList() ??
          [];

      return '${parsedDates[0].formatDateTime(formatter: DateTimeFormatterString.fullYearMonthDate)} - ${parsedDates[1].formatDateTime(formatter: DateTimeFormatterString.fullYearMonthDate)}';
    }
    return initialValue ?? '';
  }
}
